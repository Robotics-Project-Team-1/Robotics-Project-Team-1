# Install all libraries: pip3 install -r ./requirements.txt
# Run the app: streamlit run ./pepper.py


import streamlit as st
import os
import tiktoken
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI
from dotenv import load_dotenv, find_dotenv
from langchain.document_loaders import PyPDFLoader
from langchain.document_loaders import Docx2txtLoader
from langchain.document_loaders import TextLoader


# Loading PDF, DOCX and TXT files as LangChain documents
def load_document(file):
    name, extension = os.path.splitext(file)

    if extension == '.pdf':
        print(f'Loading {file}')
        loader = PyPDFLoader(file)
    elif extension == '.docx':
        print(f'Loading {file}')
        loader = Docx2txtLoader(file)
    elif extension == '.txt':
        loader = TextLoader(file)
    else:
        print('Document format is not supported!')
        return None

    data = loader.load()
    return data


# Splitting data in chunks
def chunk_data(data, chunk_size=256, chunk_overlap=20):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    chunks = text_splitter.split_documents(data)
    return chunks


# Create embeddings using OpenAIEmbeddings() and save them in a Chroma vector store
def create_embeddings(chunks):
    embeddings = OpenAIEmbeddings(model= 'text-embedding-3-large')
    vector_store = Chroma.from_documents(chunks, embeddings)
    return vector_store

# Retrieving the answer from the vector store
def ask_and_get_answer(vector_store, q, k=3):
    llm = ChatOpenAI(model='gpt-3.5-turbo', temperature=1)
    retriever = vector_store.as_retriever(search_type='similarity', search_kwargs={'k': k})
    chain = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever)
    answer = chain.run(q)
    return answer


# Clear the chat history from streamlit session state
def clear_history():
    if 'history' in st.session_state:
        del st.session_state['history']

# styles
def set_custom_style():
    st.markdown("""
        <style>
        /* Main container styling */
        .stApp {
            background-color: white;
        }
        
        /* Sidebar styling */
        section[data-testid="stSidebar"] {
            background-color: #0039A6 !important;
            padding: 1rem;
        }
        
        section[data-testid="stSidebar"] > div {
            background-color: #0039A6 !important;
        }
        
        section[data-testid="stSidebar"] .stButton button {
            width: 100%;
            background-color: rgba(255, 255, 255, 1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #0039A6 !important;
            margin: 0.5rem 0;
        }

        /* Update all other blue instances to #0039A6 */
        .user-bubble {
            background-color: #0039A6;
            color: white;
            padding: 15px;
            border-radius: 15px;
            margin: 10px 0;
            max-width: 80%;
            margin-left: auto;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
        }
        
        /* Make sidebar labels white */
        section[data-testid="stSidebar"] label,
        section[data-testid="stSidebar"] .stMarkdown,
        section[data-testid="stSidebar"] .stText,
        section[data-testid="stSidebar"] h3 {
            color: white !important;
        }
        
        /* Make file uploader text white */
        section[data-testid="stSidebar"] .stFileUploader label,
        section[data-testid="stSidebar"] .stFileUploader span {
            color: white !important;
        }
        
        /* Make number input labels white */
        section[data-testid="stSidebar"] .stNumberInput label {
            color: white !important;
        }
        
        /* Main Chat Area Styling */
        .stHeading h1{
            color: black;
        }
        .stAlert p{
            color: #0039A6;
        }

        .stMainBlockContainer h3, p, li{
            color: black !important
        }
        .st-emotion-cache-janbn0 { background-color: aliceblue !important; }
        </style>
    """, unsafe_allow_html=True)
def display_logos():
    col1, col2 = st.sidebar.columns(2)
    with col1:
        st.image("./gsu.svg", width=100)
    with col2:
        st.image("./avatar.svg", width=100)
    st.markdown("### Pepper Chatbot")
#ui
if __name__ == "__main__":
    # Loading the OpenAI api key from .env
    load_dotenv(find_dotenv(), override=True)
    set_custom_style()
    st.title('Pepper Chatbot')

    with st.sidebar:
        display_logos()
        # text_input for the OpenAI API key (alternative to python-dotenv and .env)
        api_key = st.text_input('OpenAI API Key:', type='password')
        if api_key:
            os.environ['OPENAI_API_KEY'] = api_key

        # File uploader widget
        uploaded_file = st.file_uploader('Upload a file:', type=['pdf', 'docx', 'txt'])

        # Chunk size number widget
        chunk_size = st.number_input('Chunk size:', min_value=100, max_value=2048, value=512, on_change=clear_history)

        # k number input widget
        k = st.number_input('k number:', min_value=1, max_value=20, value=3, on_change=clear_history)

        # Add data button widget
        add_data = st.button('Add Data', on_click=clear_history)

        if uploaded_file and add_data: # If the user browsed a file
            with st.spinner('Reading, chunking and embedding file ...'):

                # Writing the file from RAM to the current directory on disk
                bytes_data = uploaded_file.read()
                file_name = os.path.join('./', uploaded_file.name)
                with open(file_name, 'wb') as f:
                    f.write(bytes_data)

                data = load_document(file_name)
                chunks = chunk_data(data, chunk_size=chunk_size)
                st.write(f'Chunk size: {chunk_size}, Chunks: {len(chunks)}')

                # Creating the embeddings and returning the Chroma vector store
                vector_store = create_embeddings(chunks)

                # Saving the vector store in the streamlit session state (to be persistent between reruns)
                st.session_state.vs = vector_store
                st.success('File uploaded, chunked and embedded successfully!')
    with st.container():
        # User's question text input widget
        q = st.text_input('Please ask a question:')

        if q: # If the user entered a question and hit enter
            if 'vs' in st.session_state: # If there's the vector store (user uploaded, split and embedded a file)
                vector_store = st.session_state.vs
                #st.write(f'k: {k}')
                answer = ask_and_get_answer(vector_store, q, k)

                # Text area widget for the LLM answer
                #st.text_area('Chatbot answer: ', value=answer)
                st.markdown("### Pepper's answer: \n" + answer)

                st.divider()

                # If there's no chat history in the session state, create it
                # if 'history' not in st.session_state:
                #     st.session_state.history = ''

                # # The current question and answer
                # value = f'Q: {q} \nA: {answer}'

                # st.session_state.history = f'{value} \n {"-" * 100} \n {st.session_state.history}'
                # h = st.session_state.history

                # # Text area widget for the chat history
                # st.text_area(label='Chat History', value=h, key='history', height=400)
                st.markdown('### Chat History: ')
                # Initialize chat history
                if "messages" not in st.session_state:
                    st.session_state.messages = []
                with st.container(key='messages', height=400):
                    # Display chat messages from history on app rerun
                    for message in st.session_state.messages:
                        with st.chat_message(message["role"]):
                            st.markdown(message["content"])
                    st.chat_message("user").markdown(q)
                    st.chat_message("assistant").markdown(answer)
                    #st.chat_message("assistant", avatar="./avatar.svg").markdown(answer)
                    st.session_state.messages.append({"role": "user", "content": q})
                    st.session_state.messages.append({"role": "assistant", "content": answer})

                # with st.container(height=400, border=True):
                #     st.text_area(label='Chat History', value=h, key='history', height=400)
                    #st.write(h)



