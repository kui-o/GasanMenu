package com.example.gasanmenu

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import jakarta.servlet.annotation.*
import jakarta.servlet.http.*
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import java.time.DayOfWeek
import java.time.Duration
import java.time.Instant
import java.time.LocalDate
import java.time.MonthDay
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.temporal.TemporalAdjusters


class RestServlet : HttpServlet() {

    val objectMapper = ObjectMapper()
    val httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build()

    val restList: MutableList<Restaurant> = arrayListOf()

    var lastReload: Long = 0

    private lateinit var rapidApiKey: String

    fun String.connectJsoup(): Document {
        return Jsoup.connect(this)
            .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
            .timeout(3000)
            .get()
    }

    fun String.connectHttpClient(): JsonNode {
        val request = HttpRequest.newBuilder(URI.create(this))
            .GET()
            .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
            .timeout(Duration.ofSeconds(3))
            .build()

        val response = httpClient.send(request, HttpResponse.BodyHandlers.ofString())
        if (response.statusCode() !in 200..299) {
            throw RuntimeException("Http status code: ${response.statusCode()}")
        }

        return objectMapper.readTree(response.body())
    }

    fun String.connectHttpClientForInsta(): JsonNode {
        val request = HttpRequest.newBuilder(URI.create("https://instagram120.p.rapidapi.com/api/instagram/posts"))
            .header("Content-Type", "application/json")
            .header("x-rapidapi-host", "instagram120.p.rapidapi.com")
            .header("x-rapidapi-key", rapidApiKey)
            .timeout(Duration.ofSeconds(10))
            .POST(HttpRequest.BodyPublishers.ofString(String.format("{\"username\": \"%s\", \"max_id\": \"\"}", this)))
            .build()

        val response = httpClient.send(request, HttpResponse.BodyHandlers.ofString())
        if (response.statusCode() !in 200..299) {
            throw RuntimeException("Http status code: ${response.statusCode()}")
        }

        return objectMapper.readTree(response.body())
    }

    override fun init() {
        val apiKey = servletContext.getInitParameter("RAPID_API_KEY")
        require(!apiKey.isNullOrBlank() && apiKey != "YOUR_API_KEY_HERE") {
            """
            [ERROR] RAPID_API_KEY 가 설정되지 않았습니다! 
            WEB-INF/web.xml 파일에서 'YOUR_API_KEY_HERE' 부분을 실제 API 키로 교체해주세요.
            https://rapidapi.com/hub
            """.trimIndent()
        }
        this.rapidApiKey = apiKey

        restList.add(Restaurant("5ssTAt5Z", "윤셰프 갤러리", "11:10 ~ 14:30", "7,000원", "38m", "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20191221_1%2F1576858977107tvV7l_JPEG%2FGrKoyHTf_5oFTlHcuGH-1A1U.jpeg.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124227.9790843,4505683.9943255,%EC%9C%A4%EC%85%B0%ED%94%84%20%EA%B0%A4%EB%9F%AC%EB%A6%AC%20%EA%B5%AC%EB%82%B4%EC%8B%9D%EB%8B%B9,1318668744,PLACE_POI/-/walk?c=19.00,0,0,0,dh", "") {
            Pair("/images/yoon_menu.png", MonthDay.now())
        })

        restList.add(Restaurant("GQ1Z8AZ2", "까사미아푸드", "11:00 ~ 14:00, 17:00~ 18:50", "7,500원", "140m", "/images/casamia.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124261.1856884,4505930.1015207,%EA%B9%8C%EC%82%AC%EB%AF%B8%EC%95%84%ED%91%B8%EB%93%9C,1252353176,PLACE_POI/-/walk?c=18.00,0,0,0,dh", "https://www.instagram.com/casamia__food/") {
            val zoneId = ZoneId.of("Asia/Seoul")
            val today = LocalDate.now()
            val thisMonday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY))

            val json = "casamia__food".connectHttpClientForInsta()

            val todayMenu = json.get("result")?.get("edges")?.filter { post ->
                val createdDt = post?.get("node")?.get("taken_at")?.asLong() ?: return@filter false
                val postDate = Instant.ofEpochSecond(createdDt)
                    .atZone(zoneId)
                    .toLocalDate()

                val carouselMediaCount = post.get("node")?.get("carousel_media_count")?.asInt()

                postDate == thisMonday && carouselMediaCount == 0
            } ?.minByOrNull { post ->
                post?.get("node")?.get("taken_at")?.asLong() ?: Long.MAX_VALUE
            } ?.get("node") ?: throw RuntimeException("not found")

            val menuImage = todayMenu?.get("image_versions2")?.get("candidates")?.get(0)?.get("url")?.asText() ?: throw RuntimeException("not found menu")
            val monthDay : MonthDay? = """\d+월 \d+일""".toRegex()
                .find(todayMenu.get("caption")?.get("text")?.asText() ?: "")
                ?.value
                ?.let {
                    MonthDay.parse(
                        it,
                        DateTimeFormatter.ofPattern("M월 d일")
                    )
                }

            Pair(menuImage, monthDay)
        })

        restList.add(Restaurant("FgTdMAgT", "아임셰프", "11:00 ~ 14:00", "7,000원", "174m", "https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNTA1MTZfMjk5%2FMDAxNzQ3Mzg2MzgyMDgw.0_fPvRxT52Z6Uve5_Kx4WeGrZTKa80e4Fvqy0Cf2xaUg.J43D01pdQxKkIZHQqXFPD9Rk_lttTuqh4NpEllKx2Lgg.JPEG%2F20250516_135905.jpg.jpg%3Ftype%3Dw1500_60_sharpen", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124099.6388433,4505929.4282073,%EC%95%84%EC%9E%84%EC%85%B0%ED%94%84%20%EA%B5%AC%EB%82%B4%EC%8B%9D%EB%8B%B9,1566768349,PLACE_POI/-/walk?c=18.00,0,0,0,dh", "https://pf.kakao.com/_FQrfn") {
            val json = "https://pf.kakao.com/rocket-web/web/v2/profiles/_FQrfn".connectHttpClient()

            val todayMenu = json.get("cards")?.find { it.get("title")?.asText() == "소식" }?.get("posts")?.get(1)
            val menuImage = todayMenu?.get("media")?.get(0)?.get("xlarge_url")?.asText() ?: throw RuntimeException("not found menu")
            val monthDay : MonthDay? = """오늘의 메뉴 \d+\.\d+""".toRegex()
                .find(todayMenu.get("title")?.asText() ?: "")
                ?.value
                ?.let {
                    MonthDay.parse(
                        it,
                        DateTimeFormatter.ofPattern("오늘의 메뉴 M.d")
                    )
                }

            Pair(menuImage, monthDay)
        })

        restList.add(Restaurant("GZZm3LtP", "롯데IT캐슬", "11:00 ~ 14:00, 17:00~ 19:00", "7,000원", "184m", "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA0MDlfMjU0%2FMDAxNzQ0MTc4ODgzMjU1.s_t-7IfZjynb8SNQ4ukgKPRlwk4lLuT0Kvrye382PD4g.caZHPUyACnw3fFPEY4Hj7qatZDi3b8fIO0nND8APqSQg.JPEG%2FIMG_2784.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124352.3340874,4505866.7541407,%EB%A1%AF%EB%8D%B0IT%EC%BA%90%EC%8A%AC2%EB%8F%99,18980263,PLACE_POI/-/walk?c=18.00,0,0,0,dh", "https://www.instagram.com/lotte.it.0910/") {
            val zoneId = ZoneId.of("Asia/Seoul")
            val today = LocalDate.now()

            val json = "lotte.it.0910".connectHttpClientForInsta()
            val todayMenu = json.get("result")?.get("edges")?.filter { post ->
                /*val createdDt = post?.get("node")?.get("taken_at")?.asLong() ?: return@filter false
                val postDate = Instant.ofEpochSecond(createdDt)
                    .atZone(zoneId)
                    .toLocalDate()

                postDate == today*/
                val carouselMediaCount = post.get("node")?.get("carousel_media_count")?.asInt()
                carouselMediaCount == 2
            } ?.maxByOrNull { post ->
                post?.get("node")?.get("taken_at")?.asLong() ?: Long.MAX_VALUE
            } ?.get("node") ?: throw RuntimeException("not found")

            val menuImage = todayMenu?.get("image_versions2")?.get("candidates")?.get(0)?.get("url")?.asText() ?: throw RuntimeException("not found menu")
            val monthDay : MonthDay? = """\d+월 \d+일""".toRegex()
                .find(todayMenu.get("title")?.asText() ?: "")
                ?.value
                ?.let {
                    MonthDay.parse(
                        it,
                        DateTimeFormatter.ofPattern("M월 d일")
                    )
                }

            Pair(menuImage, monthDay)
        })

        restList.add(Restaurant("GeUXgFOx", "바른식탁", "11:20 ~ 14:00", "7,500원", "360m", "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA4MDFfOCAg%2FMDAxNzIyNDkwMTExNzA2.9xCugjI1Ae_0yUCPOaFigpGccjSC-Yobr3uNkz1TWkMg.XEpPsMLrf8gmf8hWfvNB3wLo64Y24a_cV-MxG0XdKCcg.JPEG%2F20240729%25A3%25DF122921.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124436.0574765,4505810.5890691,%EB%B0%94%EB%A5%B8%EC%8B%9D%ED%83%81,1741562430,PLACE_POI/-/walk?c=18.00,0,0,0,dh", "https://pf.kakao.com/_bXxkxhb") {
            val json = "https://pf.kakao.com/rocket-web/web/v2/profiles/_bXxkxhb".connectHttpClient()

            val menuImage = json.get("cards")?.get(0)?.get("profile")?.get("profile_image")?.get("xlarge_url")?.asText() ?: throw RuntimeException("not found menu")
            val monthDay : MonthDay? = null

            Pair(menuImage, monthDay)
        })

        restList.add(Restaurant("xGI3atAC", "윤스푸드", "11:00 ~ 14:00", "7,500원", "526m", "https://k.kakaocdn.net/dn/TAQph/btrdHl4knix/ckCLOvNCsqclTvCvUuqXYK/img_xl.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124395.047376,4505968.6487851,%EC%9C%A4%EC%8A%A4%ED%91%B8%EB%93%9C,1129743375,PLACE_POI/-/walk?c=17.00,0,0,0,dh", "https://pf.kakao.com/_aKxdLs") {
            val json = "https://pf.kakao.com/rocket-web/web/v2/profiles/_aKxdLs".connectHttpClient()
            val todayMenu = json.get("cards")?.find { it.get("title")?.asText() == "오늘의 메뉴" }?.get("posts")?.get(0)

            val menuImage = todayMenu?.get("media")?.let { media ->
                media.get(media.size() - 1)
            }?.get("xlarge_url")?.asText() ?: throw RuntimeException("not found menu")

            val monthDay : MonthDay? = """\d+월 \d+일""".toRegex()
                .find(todayMenu.get("title")?.asText() ?: "")
                ?.value
                ?.let {
                    MonthDay.parse(
                        it,
                        DateTimeFormatter.ofPattern("M월 d일")
                    )
                }

            Pair(menuImage, monthDay)
        })

        restList.add(Restaurant("xs3VF95q", "돈토", "11:00 ~ 14:00, 17:00 ~ 19:00", "7,500원", "526m", "https://k.kakaocdn.net/dn/bUdBlN/btrPybZ1blc/B1Aevq6s9dGBgGBRGFHqhK/img_xl.jpg", "https://map.naver.com/p/directions/14124201.6742886,4505730.5501538,%EB%8B%A8%EB%B9%84%EC%95%84%EC%9D%B4%EC%97%94%EC%94%A8,1337038683,PLACE_POI/14124395.8043486,4505971.9452281,%EB%8F%88%ED%86%A0,13344767,PLACE_POI/-/walk?c=17.00,0,0,0,dh", "https://www.instagram.com/donto_gasan/") {
            val json = "donto_gasan".connectHttpClientForInsta()
            val todayMenu = json.get("result")?.get("edges")?.get(0)?.get("node")

            val menuImage = todayMenu?.get("image_versions2")?.get("candidates")?.get(0)?.get("url")?.asText() ?: throw RuntimeException("not found menu")
            val monthDay : MonthDay? = """\d+월 \d+일""".toRegex()
                .find(todayMenu.get("caption")?.get("text")?.asText() ?: "")
                ?.value
                ?.let {
                    MonthDay.parse(
                        it,
                        DateTimeFormatter.ofPattern("M월 d일")
                    )
                }

            Pair(menuImage, monthDay)
        })

    }

    public override fun doGet(request: HttpServletRequest, response: HttpServletResponse) {
        if(request.getParameter("id") == null) {
            request.setAttribute("restList", restList)
            request.getRequestDispatcher("/restList.jsp").forward(request, response)

        } else {
            val rest = restList.find { it.id == request.getParameter("id") } ?: run {
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }

            if(request.getParameter("force") == "true") {
                if(System.currentTimeMillis() - lastReload > 10000) {
                    lastReload = System.currentTimeMillis()
                    rest.forceRefresh()
                    response.status = HttpServletResponse.SC_NO_CONTENT
                } else {
                    response.status = 429 //Too Many Requests
                }
            } else {
                request.setAttribute("rest", rest)
                request.getRequestDispatcher("/restaurant.jsp").forward(request, response)
            }
        }
    }
}