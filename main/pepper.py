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
from flask import Flask, request, jsonify
from flask_cors import CORS

#REST API
app = Flask(__name__)

#ex call
@app.route('/hello')  
def hello():  
    return 'Hello, World!'

# accept file upload in debug menu
@app.route('/file_upload', methods=['POST'])
def upload_file():
    if file not in request.files:
        return jsonify({'error': 'no file part'})
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error':'no file selected'})
    if file:
        load_document(file)
#TODO: receive user input, send ai message (as stream?)
@app.route('/sendmsg', methods=['GET','POST'])  #GET- display ai response, POST-get user response and feed to model
@app.route('/sendresponse') #combine into one?


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
    embeddings = OpenAIEmbeddings()
    vector_store = Chroma.from_documents(chunks, embeddings)
    return vector_store


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


if __name__ == "__main__":
    app.run()
    # Loading the OpenAI api key from .env
    load_dotenv(find_dotenv(), override=True)
    st.subheader('Welcome to our Pepper Chatbot!')

    with st.sidebar:
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

    # User's question text input widget
    q = st.text_input('Please ask a question:')

    if q: # If the user entered a question and hit enter
        if 'vs' in st.session_state: # If there's the vector store (user uploaded, split and embedded a file)
            vector_store = st.session_state.vs
            st.write(f'k: {k}')
            answer = ask_and_get_answer(vector_store, q, k)

            # Text area widget for the LLM answer
            st.text_area('Chatbot answer: ', value=answer)

            st.divider()

            # If there's no chat history in the session state, create it
            if 'history' not in st.session_state:
                st.session_state.history = ''

            # The current question and answer
            value = f'Q: {q} \nA: {answer}'

            st.session_state.history = f'{value} \n {"-" * 100} \n {st.session_state.history}'
            h = st.session_state.history

            # Text area widget for the chat history
            st.text_area(label='Chat History', value=h, key='history', height=400)



