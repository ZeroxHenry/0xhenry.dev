'use client';

import { useEffect } from 'react';
import Script from 'next/script';
import Link from 'next/link';

export default function RadarPage({ params }: { params: { lang: string } }) {
  const lang = params.lang === 'ko' ? 'ko' : 'en';

  const labels = {
    en: {
      title: "Tech Radar — 2026 Q3",
      desc: "Our vision for the technologies shaping robot education and engineering.",
      wait: "Loading Radar...",
    },
    ko: {
      title: "기술 레이더 — 2026 Q3",
      desc: "로봇 교육과 엔지니어링의 미래를 결정짓는 핵심 기술 로드맵.",
      wait: "레이더를 불러오는 중...",
    }
  }[lang];

  useEffect(() => {
    // Initialize radar after scripts are loaded
    const checkD3 = setInterval(() => {
      // @ts-ignore
      if (window.d3 && window.initRadar) {
        clearInterval(checkD3);
        // @ts-ignore
        window.initRadar('tech-radar', '/data/radar/2026-q3.json');
      }
    }, 100);
    return () => clearInterval(checkD3);
  }, []);

  return (
    <div className="max-w-6xl mx-auto px-5 py-16">
      <link rel="stylesheet" href="/css/radar.css" />
      
      <header className="text-center mb-12">
        <h1 className="text-4xl font-black mb-4 tracking-tight">{labels.title}</h1>
        <p className="text-gray-600 dark:text-gray-400 max-w-2xl mx-auto text-lg leading-relaxed">
          {labels.desc}
        </p>
      </header>

      <div className="relative aspect-square max-w-[850px] mx-auto bg-white dark:bg-gray-950 rounded-3xl border border-gray-100 dark:border-gray-900 shadow-2xl shadow-indigo-500/5 overflow-hidden">
        <div id="tech-radar" className="w-full h-full" />
        <div id="radar-loader" className="absolute inset-0 flex items-center justify-center text-gray-400 font-medium">
          {labels.wait}
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-12 mt-16">
        <div id="radar-legend" className="space-y-6" />
        <div id="radar-blip-list" className="space-y-4" />
      </div>

      <Script src="https://d3js.org/d3.v7.min.js" strategy="afterInteractive" />
      <Script src="/js/radar.js" strategy="afterInteractive" />
    </div>
  );
}
