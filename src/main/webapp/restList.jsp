<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가산 구내식당 목록</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(180deg, #0a1a2f 0%, #0d213d 100%); /* 남색 배경 */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        /* 화이트 박스 컨테이너 기본값 (가로가 길 때: 전체 채움) */
        .content-container {
            background-color: white;
            width: 100%;
            min-height: 100vh;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative; /* 자식 요소(오렌지 글로우) 절대 위치 기준 */
            overflow: hidden;   /* 둥근 모서리 밖으로 글로우가 나가지 않게 자름 */
        }

        @keyframes float {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 20px); }
        }

        .glow-circle {
            position: absolute;
            width: 45vh;
            height: 45vh;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,140,66,0.45), transparent 70%);
            filter: blur(18px);
            opacity: 0.7;
            animation: float 14s ease-in-out infinite alternate;
            pointer-events: none;
            z-index: 0;

            /* 좌상단 배치 기본값 */
            top: -10%;
            left: -10%;
        }

        .glow-circle.second {
            background: radial-gradient(circle, rgba(255,107,0,0.4), transparent 70%);
            bottom: -10%;
            right: -15%;
            top: auto;
            left: auto;
            animation-duration: 18s;
        }

        /* 세로가 더 긴 환경 (Mobile Portrait 등) */
        @media (orientation: portrait) {
            .content-container {
                margin: 4vh 4vw; /* 남색 배경이 보이도록 마진 부여 */
                border-radius: 30px; /* 테두리 둥글게 */
                min-height: calc(100vh - 8vh); /* 마진만큼 제외한 높이 */
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            }
        }

        /* 텍스트 가독성을 위한 그림자 */
        .text-shadow {
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }

        .menu-fab {
            position: fixed;
            left: 7vw;
            bottom: 6vh;
            z-index: 9999;

            /* ★ 핵심: 너비와 높이를 같게 하고 반지름 50% 설정 ★ */
            width: 100px;
            height: 100px;
            border-radius: 50%;

            /* 아이콘 정중앙 배치 */
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0; /* 패딩 제거 */

            /* 색상 및 디자인 */
            background-color: #007bff; /* 파란색 */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            cursor: pointer;
            transition: transform 0.2s ease, background-color 0.2s ease;
        }

        /* 호버/클릭 효과 */
        .menu-fab:hover {
            background-color: #0056b3;
            transform: translateY(-4px);
            box-shadow: 0 6px 14px rgba(0, 0, 0, 0.4);
        }
        .menu-fab:active {
            transform: scale(0.95);
        }

        .menu-icon-img {
            width: 60px;       /* 아이콘 너비 */
            height: 60px;      /* 아이콘 높이 */
            object-fit: contain;

            /* ★ 핵심: 어떤 색상의 아이콘이든 흰색으로 변경 ★ */
            filter: brightness(0) invert(1);
        }
    </style>
</head>
<body>

<!-- 흰색 박스 컨테이너 -->
<div class="content-container">
    <!-- 오렌지 빛 -->
    <div class="glow-circle"></div>
    <div class="glow-circle second"></div>

    <!-- 실제 콘텐츠 (배경 위에 오도록 z-index 설정) -->
    <div class="relative z-10 max-w-7xl mx-auto">
        <header class="mb-6 md:mb-10">
            <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-2">오늘 뭐 먹지?</h1>
            <p class="text-xl text-gray-600">주변의 구내 식당을 찾아보세요.</p>
        </header>

        <!-- 식당 리스트 그리드 컨테이너 -->
        <div id="restaurant-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
            <c:forEach var="rest" items="${restList}">
                <button class="group relative w-full aspect-square rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition-all duration-300 focus:outline-none focus:ring-4 focus:ring-blue-300 bg-gray-200" data-id="${rest.id}">
                    <img
                            src="${rest.thumbnail}"
                            alt="${rest.name}"
                            class="absolute inset-0 w-full h-full object-cover transform group-hover:scale-110 transition-transform duration-500 ease-in-out"
                            loading="lazy"
                    >

                    <!-- 그라디언트 오버레이 -->
                    <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent opacity-70 group-hover:opacity-80 transition-opacity duration-300"></div>

                    <!-- 텍스트 정보 -->
                    <div class="absolute inset-0 p-3 md:p-5 flex flex-col justify-end text-left text-white">
                        <h3 class="text-lg md:text-2xl font-bold mb-1 leading-tight text-shadow">${rest.name}</h3>

                        <div class="space-y-0.5 text-xs md:text-sm font-medium opacity-90">
                            <div class="flex items-center gap-1">
                                <span>🕒</span> <span style="overflow: hidden;white-space: nowrap;">${rest.time}</span>
                            </div>
                            <div class="flex items-center gap-1">
                                <span>💰</span> <span>${rest.price}</span>
                            </div>
                            <div class="flex items-center gap-1 text-yellow-300">
                                <span>📍</span> <span>${rest.distance}</span>
                            </div>
                        </div>
                    </div>
                </button>
            </c:forEach>
        </div>
    </div>
</div>

<a href="/index.jsp" class="menu-fab">
    <img src="/images/home-icon.svg" alt="홈 아이콘" class="menu-icon-img" />
</a>

<script>
    document.body.addEventListener('click', function(e) {

        // 1. 클릭된 요소(e.target) 혹은 그 상위 요소 중 data-id를 가진 녀석을 찾습니다.
        // closest를 쓰는 이유: 버튼 안에 <span>이나 아이콘이 있어도 버튼을 인식하기 위해
        const target = e.target.closest('[data-id]');

        // 2. data-id를 가진 요소를 클릭했을 때만 실행
        if (target) {
            const id = target.dataset.id;

            if (id) {
                window.location.href = `/rest.jsp?id=\${id}`;
            }
        }
    });
</script>
</body>
</html>