import Image from 'next/image';

interface AuthorCardProps {
  lang: 'en' | 'ko';
}

export default function AuthorCard({ lang }: AuthorCardProps) {
  const content = {
    en: {
      title: "Henry — Robot Education Founder",
      desc: "Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning.",
      follow: "Follow the journey"
    },
    ko: {
      title: "Henry — 로봇 교육 창시자",
      desc: "모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다.",
      follow: "기술 여정 함께하기"
    }
  }[lang];

  return (
    <div className="my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5">
      <div className="flex flex-col md:flex-row items-center gap-8">
        <div className="relative group">
          <div className="absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"></div>
          <div className="relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm">
            {/* The favicon.svg should be in public/ in the monorepo too */}
            <Image 
              src="/favicon.svg" 
              alt="Henry" 
              fill
              className="object-cover"
            />
          </div>
        </div>
        
        <div className="flex-1 text-center md:text-left">
          <h3 className="text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight">
            {content.title}
          </h3>
          <p className="text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl">
            {content.desc}
          </p>
          <div className="flex justify-center md:justify-start">
            <span className="inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer">
              {content.follow}
              <svg className="w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </span>
          </div>
        </div>
      </div>
    </div>
  );
}
