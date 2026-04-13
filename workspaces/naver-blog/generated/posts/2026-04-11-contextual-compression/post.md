# 컨텍스트 압축(Contextual Compression): 노이즈 속에서 핵심만 추출하기

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

RAG 시스템의 고질적인 문제 중 하나는 바로 '불필요한 컨텍스트'입니다. 검색 키워드가 포함되어 있다는 이유로 500단어짜리 문서 조각을 가져왔지만, 정작 사용자의 질문에 대한 답은 그 안의 단 20단어뿐인 경우가 많습니다. 불필요한 480단어를 LLM에게 그대로 전달하는 것은 토큰 낭비, 비용 증가, 그리고 무엇보다 AI가 핵심 정보에 집중하지 못하게 방해하는 원인이 됩니다.

**컨텍스트 압축(Contextual Compression)**은 이를 해결하기 위한 기술입니다. 검색된 문서 조각을 LLM에게 보내기 전에, 사용자의 의도에 맞게 요약하거나 핵심 문장만 필터링하는 과정입니다.

---

### 작동 원리: 지식의 증류 과정

1.  **검색 (Retrieval)**: 검색기가 관련성이 있어 보이는 문서 조각들을 찾아옵니다.
2.  **압축 (Compression)**: 별도의 '압축기(Compressor)' 모델(주로 작은 규모의 LLM이나 특화된 모델)이 각 조각과 사용자의 질문을 대조합니다. 질문과 직접적인 관련이 있는 문장만 추출하거나, 질문에 맞게 내용을 요약합니다.
3.  **최종 프롬프트**: AI는 불순물이 제거된, 고농축된 정보만을 전달받아 답변을 생성합니다.

---

### 왜 실무에서 필수적인가요?

-   **비용 절감**: LLM에게 보내는 토큰 양이 줄어들어 API 비용을 획기적으로 낮출 수 있습니다.
-   **속도 향상**: 프롬프트가 작아질수록 LLM의 추론 속도는 빨라집니다.
-   **정확도 향상**: LLM은 '주의력(Attention)'에 한계가 있습니다. 노이즈를 제거해 줄수록 모델이 실제 사실에 기반한 정확한 답을 내릴 확률이 높아집니다.

---

### LangChain에서의 구현

LangChain은 `ContextualCompressionRetriever`를 사용하여 기존 검색기에 압축 기능을 쉽게 덧붙일 수 있게 해줍니다.

```python
from langchain.retrievers import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import LLMChainExtractor
from langchain_openai import OpenAI

# 1. 압축기 설정 (LLMChainExtractor는 관련 없는 문장을 제거함)
llm = OpenAI(temperature=0)
compressor = LLMChainExtractor.from_llm(llm)

# 2. 기본 검색기 설정
base_retriever = vectorstore.as_retriever()

# 3. 압축 검색기 생성
compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor, 
    base_retriever=base_retriever
)

# 4. 검색 및 압축 실행
compressed_docs = compression_retriever.get_relevant_documents(
    "3분기 매출 지표에 대해 구체적으로 알려줘"
)
```

---

### 요약

컨텍스트 압축은 RAG 파이프라인을 '단순 검색 시스템'에서 '세련된 지식 전달 시스템'으로 진화시킵니다. 비용, 속도, 정확도라는 세 마리 토끼를 동시에 잡고 싶은 전문 AI 개발자에게 컨텍스트 압축은 선택이 아닌 필수입니다.

다음 포스트에서는 텍스트만으로는 해결되지 않는 난제, **RAG에서의 PDF 표(Table) 처리**에 대해 알아보겠습니다.

---

**다음 주제:** [PDF 표 처리: 텍스트 분할만으로는 부족할 때](/ko/study/handling-pdf-tables)