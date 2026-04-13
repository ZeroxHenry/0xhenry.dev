# Ollama와 Python으로 구축하는 생애 첫 로컬 RAG

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

이전 포스트들에서 우리는 RAG가 무엇인지, 그리고 왜 로컬 환경에서 실행하는 것이 보안 측면에서 유리한지 알아봤습니다. 오늘은 직접 손을 움직여볼 시간입니다. 특정 텍스트 파일의 내용에 대해 답변할 수 있는, 작지만 강력한 로컬 RAG 시스템을 구축해 보겠습니다.

**준비물:**
- Python 3.10 이상 설치
- [Ollama](https://ollama.com/) 설치 및 실행 중
- 기본적인 Python 지식

---

### 1단계: 필수 라이브러리 설치

워크플로우 관리를 위한 `langchain`, 벡터 데이터베이스인 `chromadb`, 그리고 로컬 LLM과 통신하기 위한 `ollama` 라이브러리가 필요합니다.

```bash
pip install langchain langchain-community chromadb ollama
```

### 2단계: 사용할 모델 내려받기

터미널을 열고 필요한 모델들을 미리 준비합니다. 답변 생성을 위한 **Llama 3**와 텍스트를 숫자로 변환하기 위한 **nomic-embed-text** 모델을 사용하겠습니다.

```bash
ollama pull llama3
ollama pull nomic-embed-text
```

### 3단계: Python 스크립트 작성

`local_rag.py` 파일을 생성합니다. 코드는 크게 문서 로드, 임베딩, 그리고 검색 및 답변 생성의 3단계로 나뉩니다.

```python
from langchain_community.llms import Ollama
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import TextLoader

# 1. 데이터 로드 (분석하고 싶은 텍스트 파일)
loader = TextLoader("data.txt")
documents = loader.load()

# 2. 텍스트 분할 (Chunking)
# 너무 긴 글은 AI가 한 번에 읽기 힘들기 때문에 500자 단위로 자릅니다.
text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = text_splitter.split_documents(documents)

# 3. 벡터 저장소(Vector Store) 생성
# 텍스트를 숫자로 변환하여 ChromaDB에 저장합니다.
embeddings = OllamaEmbeddings(model="nomic-embed-text")
vector_db = Chroma.from_documents(
    documents=chunks, 
    embedding=embeddings,
    collection_name="local-rag"
)

# 4. 검색 및 답변 체인 설정
llm = Ollama(model="llama3")
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vector_db.as_retriever()
)

# 5. 질문 던지기
query = "이 문서의 핵심 주제는 무엇인가요?"
response = qa_chain.invoke(query)
print(response["result"])
```

---

### 작동 원리 이해하기

1.  **로드(Loading)**: 우리가 준비한 텍스트 파일을 읽어옵니다.
2.  **분할(Chunking)**: 방대한 문서를 AI가 처리하기 쉬운 크기(여기서는 500자)로 나눕니다.
3.  **임베딩(Embedding)**: `nomic-embed-text` 모델을 이용해 텍스트를 숫자의 나열(벡터)로 변환합니다. 의미가 비슷한 글들은 비슷한 숫자 값을 갖게 됩니다.
4.  **벡터 DB**: 이 숫자들을 ChromaDB에 저장합니다. 일종의 '의미 기반 검색 엔진'이 되는 셈입니다.
5.  **검색 및 생성**: 질문을 던지면 시스템이 가장 관련 있는 텍스트 조각들을 찾아 LLM(Lama 3)에게 전달하고, LLM은 그 내용을 참고해 답변을 만듭니다.

### 요약

축하합니다! 여러분은 방금 외부 클라우드나 API 키 없이도 내가 준 데이터만으로 정확하게 답하는 '프라이빗 AI'를 만드셨습니다.

다음 포스트에서는 **벡터 임베딩**에 대해 더 깊이 다뤄보겠습니다. 컴퓨터는 어떻게 "안녕"이라는 글자를 숫자로 이해하는 걸까요?

---

**다음 주제:** [벡터 임베딩의 이해: 의미를 숫자로 바꾸는 마법](/ko/study/vector-embeddings-explained)