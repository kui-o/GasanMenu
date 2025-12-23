<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>단비아이엔씨 환영 화면</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            user-select: none;
        }

        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            font-family: system-ui, -apple-system, "Noto Sans KR", sans-serif;
            background: linear-gradient(180deg, #0a1a2f 0%, #0d213d 100%); /* 남색 배경 */
        }

        body {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .kiosk-wrapper {
            width: 100vw;
            height: 100vh;
            max-width: 1080px;
            max-height: 1920px;
            padding: 4vh 4vw;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .content {
            width: 100%;
            height: 100%;
            border-radius: 32px;
            padding: 6vh 4vw;
            position: relative;
            overflow: hidden;
            background: #ffffff;              /* 완전 흰색 패널 */
            box-shadow: 0 40px 80px rgba(0,0,0,0.35);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            color: #1a1a1a;
        }

        /* 오렌지 글로우 (패널 안쪽 장식) */
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
        }

        .glow-circle.second {
            background: radial-gradient(circle, rgba(255,107,0,0.4), transparent 70%);
            bottom: -10%;
            right: -15%;
            top: auto;
            left: auto;
            animation-duration: 18s;
        }

        @keyframes float {
            0% { transform: translate(-10%, -10%) scale(1); }
            100% { transform: translate(5%, 10%) scale(1.1); }
        }

        /* 키워드 레인 – 패널 안에서 떨어짐 */
        .keyword-layer {
            position: absolute;
            inset: 0;
            overflow: hidden;
            pointer-events: none;
            z-index: 1;
        }

        .keyword-drop {
            position: absolute;
            top:-10%;
            bottom:0;
            font-size: min(2.4vw, 2.4vh);      /* 눈에 띄게 */
            color: rgba(255, 150, 70, 0.65);
            white-space: nowrap;
            animation-name: keywordFall;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            text-shadow: 0 0 14px rgba(255, 160, 90, 0.9);
            mix-blend-mode: multiply;
        }

        @keyframes keywordFall {
            0%   { transform: translateY(-130%); opacity: 0; }
            10%  { opacity: 0.9; }
            100% { transform: translateY(140%); opacity: 0; }
        }

        .top-section {
            text-align: center;
            width: 100%;
            z-index: 2;
        }

        .logo-img {
            height: 48px;
            margin-bottom: 1.5vh;
        }

        .center-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            z-index: 2;
        }

        /* 메인 카피 – 충분히 크게 */
        .welcome-title {
            font-size: min(6.8vw, 6.8vh);
            font-weight: 900;
            line-height: 1.18;
            background: linear-gradient(120deg, #ff6b00, #ff8c42, #ffaa66);
            -webkit-background-clip: text;
            color: transparent;
            text-shadow: 0 0 24px rgba(255,150,50,0.5);
        }

        .welcome-sub {
            margin-top: 2.5vh;
            font-size: min(3.6vw, 3.6vh);
            color: #333;
            line-height: 1.3;
        }

        .bottom-section {
            width: 100%;
            text-align: center;
            z-index: 2;
        }

        /* 솔루션 회전 문구 – 크기 다시 키움 + 행간 붙임 */
        .message-rotator {
            min-height: 3.6em;
            margin-bottom: 2vh;
            color: #ff6b00;
        }

        .message-desc {
            display: block;
            font-size: min(3vw, 3.2vh);      /* 소개문구 */
            font-weight: 400;
            line-height: 1.15;
            color: #444;
        }

        .message-name {
            display: block;
            margin-top: 0.25em;
            font-size: min(3.6vw, 3.8vh);    /* 솔루션명 */
            font-weight: 700;
            line-height: 1.1;
            color: #ff6b00;
        }

        .fade {
            opacity: 0;
            transform: translateY(8px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }
        .fade.show {
            opacity: 1;
            transform: translateY(0);
        }

        .info-row {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.4rem;
            margin-bottom: 1vh;
        }

        .clock {
            font-size: min(2.6vw, 2.6vh);
            color: #555;
        }

        .weather {
            font-size: min(2.6vw, 2.6vh);
            font-weight: 600;
            color: #ff6b00;
            display: flex;
            align-items: center;
            gap: 0.25rem;
            white-space: nowrap;
        }

        @media (max-width: 768px) {
            .content {
                border-radius: 24px;
                padding: 5vh 3vw;
            }
            .welcome-title {
                font-size: 4.8vh;
            }
            .welcome-sub {
                font-size: 2.8vh;
            }
            .message-desc {
                font-size: 2.4vh;
            }
            .message-name {
                font-size: 3vh;
            }
            .clock, .weather {
                font-size: 1.8vh;
            }
            .logo-img {
                height: 42px;
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
    </style>
</head>

<body>
<div class="kiosk-wrapper">
    <div class="content">

        <!-- 오렌지 빛 -->
        <div class="glow-circle" style="top:-15%; left:-20%;"></div>
        <div class="glow-circle second"></div>

        <!-- 키워드 레인 -->
        <div class="keyword-layer" id="keyword-rain"></div>

        <!-- 로고 -->
        <div class="top-section">
            <img src="images/logo_danbeeinc.svg" alt="danbee Inc." class="logo-img" />
        </div>

        <!-- 메인 카피 -->
        <div class="center-section">
            <div class="welcome-title">
                일상에<br />
                인공지능이<br />
                단비처럼<br />
                똑똑
            </div>

            <div class="welcome-sub">
                단비아이엔씨에<br />
                오신 것을 환영합니다.
            </div>
        </div>

        <!-- 솔루션 회전 + 날짜 + 날씨 -->
        <div class="bottom-section">
            <div id="rotator" class="message-rotator fade"></div>

            <div class="info-row">
                <div id="clock" class="clock"></div>
                <div id="weather" class="weather"></div>
            </div>
        </div>

    </div>
</div>

<a href="/rest.jsp" class="menu-fab">
    <img src="/images/food-restaurant-icon.svg" alt="메뉴 아이콘" class="menu-icon-img" />
</a>

<script>
    /* ========= 솔루션 회전 문구 ========= */
    const messages = [
        { desc: "대한민국 대표 챗봇빌더",              name: "단비AI" },
        { desc: "챗봇을 만들며 AI를 배우는",           name: "에이아이런" },
        { desc: "LLM기반 상담녹취 분석", name: "만타고" },
        { desc: "설치형 개인정보 비식별화 sLLM",         name: "언네이머" }
    ];

    const rotatorEl = document.getElementById("rotator");
    let messageIndex = 0;

    function renderMessage(i) {
        const m = messages[i];
        rotatorEl.innerHTML =
            `<span class="message-desc">\${m.desc}</span>` +
            `<span class="message-name">\${m.name}</span>`;
    }

    function showNextMessage() {
        rotatorEl.classList.remove("show");
        setTimeout(() => {
            renderMessage(messageIndex);
            rotatorEl.classList.add("show");
            messageIndex = (messageIndex + 1) % messages.length;
        }, 600);
    }

    /* ========= 날짜 ========= */
    const clockEl = document.getElementById("clock");

    function updateClock() {
        const now = new Date();
        const local = new Date(
            now.toLocaleString("en-US", { timeZone: "Asia/Seoul" })
        );

        const y  = local.getFullYear();
        const mo = local.getMonth() + 1;
        const d  = local.getDate();
        const wd = ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"][local.getDay()];
        const hh = String(local.getHours()).padStart(2, "0");
        const mm = String(local.getMinutes()).padStart(2, "0");

        clockEl.textContent = `\${y}년 \${mo}월 \${d}일 \${wd} \${hh}:\${mm}`;
    }

    /* ========= 날씨 ========= */
    const weatherEl = document.getElementById("weather");

    function weatherIcon(code, isDay) {
        if (code === 0) return isDay ? "☀️" : "🌙";
        if (code >= 1 && code <= 3) return isDay ? "🌤️" : "☁️";
        if (code === 45 || code === 48) return "🌫️";
        if (code >= 51 && code <= 82) return "🌧️";
        if ((code >= 71 && code <= 77) || code >= 85) return "🌨️";
        if (code >= 95) return "⛈️";
        return "🌡️";
    }

    async function updateWeather() {
        try {
            const url =
                "https://api.open-meteo.com/v1/forecast" +
                "?latitude=37.4776&longitude=126.8878" +
                "&current_weather=true&timezone=Asia%2FSeoul";
            const res = await fetch(url);
            const data = await res.json();
            const cw = data.current_weather;
            if (!cw) throw new Error("no current weather");
            const emoji = weatherIcon(cw.weathercode, cw.is_day === 1);
            const temp  = Math.round(cw.temperature);
            weatherEl.textContent = `\${emoji} 가산동 \${temp}°C`;
        } catch (e) {
            weatherEl.textContent = "날씨 정보를 불러오지 못했어요";
        }
    }

    /* ========= 키워드 레인 ========= */
    const keywords = [
        "GenAI","LLM","RAG","MLOps","Kubernetes","Docker","Microservices","Serverless",
        "DevSecOps","GitOps","CI/CD","IaC","Terraform","Ansible","OpenTelemetry",
        "SRE","Edge Computing","Kafka","Event-Driven","Cloud Native",
        "요구사항 분석","시스템 설계","아키텍처 설계","코드 리뷰","객체지향",
        "ERD","SQL","Spring Framework","REST API","배치 처리"
    ];

    const keywordLayer = document.getElementById("keyword-rain");

    function createKeywordRain() {
        const count = keywords.length * 2;  // 좀 넉넉하게
        for (let i = 0; i < count; i++) {
            const span = document.createElement("span");
            const rainbowColors = [
                "#ff3b30", // 빨강
                "#ff9500", // 주황
                "#ffcc00", // 노랑
                "#34c759", // 초록
                "#007aff", // 파랑
                "#5856d6", // 남색/보라
                "#af52de"  // 보라
            ];
            span.className = "keyword-drop";
            span.textContent = keywords[i % keywords.length];


            span.style.left = (5 + Math.random() * 90) + "%";
            span.style.animationDelay = (Math.random() * 30) + "s";
            span.style.animationDuration = (24 + Math.random() * 12) + "s";

            // 🌈 랜덤 무지개 컬러 적용
            const color = rainbowColors[Math.floor(Math.random() * rainbowColors.length)];
            span.style.color = color;

            // 글씨랑 같은 색으로 부드러운 글로우
            span.style.textShadow = '0 0 18px \${color}';

            keywordLayer.appendChild(span);
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        // 여기에 실행할 코드를 넣으세요
        console.log("페이지 로드 완료! 스크립트 실행됨");

        // 초기 표시
        renderMessage(0);
        requestAnimationFrame(() => rotatorEl.classList.add("show"));
        messageIndex = 1;
        setInterval(showNextMessage, 4000);

        updateClock();
        setInterval(updateClock, 1000);

        updateWeather();
        setInterval(updateWeather, 600000); // 10분마다 갱신

        createKeywordRain();
    });
</script>
</body>
</html>
