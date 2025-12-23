<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${rest.name} - 상세 정보</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.11.6/viewer.min.css">
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

        /* 화이트 박스 컨테이너 */
        .content-container {
            background-color: white;
            width: 100%;
            min-height: 100vh;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
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
                margin: 4vh 4vw;
                border-radius: 30px;
                min-height: calc(100vh - 8vh);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            }
            #site-button {
                display: none;
            }
            #map-button {
                display: none;
            }
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

        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>

<!-- 흰색 박스 컨테이너 -->
<div class="content-container">
    <!-- 오렌지 빛 배경 효과 -->
    <div class="glow-circle"></div>
    <div class="glow-circle second"></div>

    <!-- 실제 콘텐츠 -->
    <div class="relative z-10 max-w-3xl mx-auto">

        <!-- 상단 네비게이션 (뒤로가기) -->
        <nav class="flex items-center justify-between mb-6">
            <button onclick="history.back()" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors group">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 transform group-hover:-translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
                <span class="font-medium">목록으로</span>
            </button>
        </nav>

        <!-- 식당 헤더 정보 -->
        <header class="mb-8">
            <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4 tracking-tight">${rest.name}</h1>

            <!-- 주요 정보 뱃지 -->
            <div class="flex flex-wrap gap-3">
                <div class="inline-flex items-center px-3 py-1.5 rounded-full bg-blue-50 text-blue-700 text-sm font-medium border border-blue-100">
                    <span class="mr-1.5">🕒</span> ${rest.time}
                </div>
                <div class="inline-flex items-center px-3 py-1.5 rounded-full bg-green-50 text-green-700 text-sm font-medium border border-green-100">
                    <span class="mr-1.5">💰</span> ${rest.price}
                </div>
                <div class="inline-flex items-center px-3 py-1.5 rounded-full bg-yellow-50 text-yellow-700 text-sm font-medium border border-yellow-100">
                    <span class="mr-1.5">📍</span> ${rest.distance}
                </div>
            </div>
        </header>

        <!-- 메인 콘텐츠: 메뉴 이미지 -->
        <main>
            <div class="bg-gray-50 rounded-3xl p-2 md:p-4 shadow-inner border border-gray-100">
                <div class="flex justify-between items-center px-2 mb-3">
                    <h2 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                        <span>📋</span> 오늘의 메뉴
                    </h2>
                </div>

                <!-- 메뉴 이미지 컨테이너 -->
                <div id="menuImg" class="relative w-full rounded-2xl overflow-hidden shadow-lg bg-white group cursor-zoom-in">
                    <!-- 이미지가 없을 경우를 대비한 대체 텍스트/이미지 처리 (onerror) -->
                    <c:choose>
                        <c:when test="${not empty rest.menuImageURL}">
                            <img
                                    src="${rest.menuImageURL}"
                                    alt="${rest.name} 메뉴판"
                                    class="w-full h-auto object-cover transform hover:scale-[1.02] transition-transform duration-500"
                                    onerror="this.src='https://via.placeholder.com/600x800?text=메뉴+이미지+준비중'"
                            >
                            <!-- 돋보기 아이콘 오버레이 -->
                            <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors flex items-center justify-center pointer-events-none">
                                <div class="bg-white/90 rounded-full p-3 opacity-0 group-hover:opacity-100 transition-opacity shadow-lg transform translate-y-4 group-hover:translate-y-0 duration-300">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                                    </svg>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-col items-center justify-center h-64 bg-gray-100 text-gray-400">
                                <svg class="w-12 h-12 mb-2 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                <span>등록된 메뉴 이미지가 없습니다.</span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- 이미지 하단 그라디언트 (시각적 효과) -->
                    <div class="absolute bottom-0 left-0 right-0 h-20 bg-gradient-to-t from-black/10 to-transparent pointer-events-none"></div>
                </div>
                <!-- 리로드 버튼 -->
                <div class="mt-4" id="reload-button">
                    <a href="#" class="group block w-full">
                        <div class="flex items-center justify-center gap-2 w-full py-3.5 bg-slate-500 hover:bg-slate-600 text-white rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="#ffffff" viewBox="0 0 24 24" stroke="currentColor">
                                <path d="M19.146 4.854l-1.489 1.489A8 8 0 1 0 12 20a8.094 8.094 0 0 0 7.371-4.886 1 1 0 1 0-1.842-.779A6.071 6.071 0 0 1 12 18a6 6 0 1 1 4.243-10.243l-1.39 1.39a.5.5 0 0 0 .354.854H19.5A.5.5 0 0 0 20 9.5V5.207a.5.5 0 0 0-.854-.353z"/>
                            </svg>
                            <span class="font-bold text-lg">메뉴 다시 불러오기</span>
                        </div>
                    </a>
                </div>
                <!-- // 리로드 버튼 끝 -->
                <c:if test="${not empty rest.menuUrl}">
                    <!-- 메뉴 직접 보기 버튼 -->
                    <div class="mt-4" id="site-button">
                        <a href="${rest.menuUrl}" target="_blank" rel="noopener noreferrer" class="group block w-full">
                            <div class="flex items-center justify-center gap-2 w-full py-3.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                                <?xml version="1.0" encoding="utf-8"?><!-- Uploaded to: SVG Repo, www.svgrepo.com, Generator: SVG Repo Mixer Tools -->
                                <svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5">
                                    <path d="M7.05025 1.53553C8.03344 0.552348 9.36692 0 10.7574 0C13.6528 0 16 2.34721 16 5.24264C16 6.63308 15.4477 7.96656 14.4645 8.94975L12.4142 11L11 9.58579L13.0503 7.53553C13.6584 6.92742 14 6.10264 14 5.24264C14 3.45178 12.5482 2 10.7574 2C9.89736 2 9.07258 2.34163 8.46447 2.94975L6.41421 5L5 3.58579L7.05025 1.53553Z" fill="#ffffff"/>
                                    <path d="M7.53553 13.0503L9.58579 11L11 12.4142L8.94975 14.4645C7.96656 15.4477 6.63308 16 5.24264 16C2.34721 16 0 13.6528 0 10.7574C0 9.36693 0.552347 8.03344 1.53553 7.05025L3.58579 5L5 6.41421L2.94975 8.46447C2.34163 9.07258 2 9.89736 2 10.7574C2 12.5482 3.45178 14 5.24264 14C6.10264 14 6.92742 13.6584 7.53553 13.0503Z" fill="#ffffff"/>
                                    <path d="M5.70711 11.7071L11.7071 5.70711L10.2929 4.29289L4.29289 10.2929L5.70711 11.7071Z" fill="#ffffff"/>
                                </svg>
                                <span class="font-bold text-lg">메뉴 직접 보기</span>
                            </div>
                        </a>
                    </div>
                    <!-- // 메뉴 직접 보기 끝 -->
                </c:if>
                <!-- 지도 보기 버튼 -->
                <div class="mt-4" id="map-button">
                    <a href="${rest.mapUrl}" target="_blank" rel="noopener noreferrer" class="group block w-full">
                        <div class="flex items-center justify-center gap-2 w-full py-3.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                            <span class="font-bold text-lg">지도 보기</span>
                        </div>
                    </a>
                </div>
                <!-- // 지도 보기 버튼 끝 -->
            </div>
        </main>

        <!-- 푸터 여백 -->
        <div class="h-10"></div>
    </div>
</div>

<a href="/index.jsp" class="menu-fab">
    <img src="/images/home-icon.svg" alt="홈 아이콘" class="menu-icon-img" />
</a>

<!-- 로딩 오버레이 -->
<div id="loading-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center; cursor: wait;">
    <div class="spinner"></div>
</div>

<!-- 3. Viewer.js 자바스크립트 불러오기 (CDN) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.11.6/viewer.min.js"></script>

<script>
    // 4. Viewer.js 초기화
    // 이미지가 들어있는 부모 요소를 선택합니다.
    const galleryElement = document.getElementById('menuImg');

    const viewer = new Viewer(galleryElement, {
        // 옵션 설정 (필요에 따라 수정)
        toolbar: false,       // 하단 툴바 표시 여부
        navbar: false,      // 하단 네비게이션
        transition: false,  //애니메이션
        title: true,         // 이미지 제목(alt 속성) 표시 여부
        tooltip: true,       // 줌 퍼센트 툴팁 표시
        movable: true,       // 이미지 드래그 이동 가능 여부
        zoomable: true,      // 줌 가능 여부
        rotatable: false,     // 회전 가능 여부
        scalable: false,      // 뒤집기(상하좌우 반전) 가능 여부
    });

    document.querySelector('#reload-button a').addEventListener('click', function(event) {
        event.preventDefault();

        const overlay = document.getElementById('loading-overlay');
        overlay.style.display = 'flex';

        // 1. 현재 URL 정보를 가져옵니다.
        const url = new URL(window.location.href);

        // 2. 파라미터에 force=true를 추가하거나 수정합니다.
        // (이미 있으면 덮어쓰고, 없으면 새로 추가합니다)
        url.searchParams.set('force', 'true');

        // 3. fetch를 이용해 AJAX 요청을 보냅니다.
        fetch(url.toString(), {
            method: 'GET',
        })
            .then(response => {
                // 204 No Content: 성공적인 처리
                if (response.status === 204) {
                    window.location.reload();
                    return;
                }

                // 429 Too Many Requests: 너무 많은 요청
                if (response.status === 429) {
                    alert('최근에 업데이트했습니다.\n잠시 후 다시 시도해주세요.');
                    return;
                }

                // 그 외 상태 코드 (400, 500 등)는 에러로 간주
                if (!response.ok) {
                    alert('요청 처리 중 문제가 발생했습니다.');
                }
            })
            .catch(error => {
                // 네트워크 연결 실패 또는 위에서 throw한 에러 처리
                console.error('에러 발생:', error);
                alert('요청 처리 중 문제가 발생했습니다.');
            })
            .finally(() => {
                // 2. 로딩 종료 (통신이 성공하든 실패하든 무조건 화면 잠금 해제)
                overlay.style.display = 'none';
            });
    });

</script>

</body>
</html>