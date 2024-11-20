# Install all libraries: pip3 install -r ./requirements.txt
# Run the app: streamlit run ./pepper.py


import streamlit as st
import os
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI
from dotenv import load_dotenv, find_dotenv
from langchain.document_loaders import PyPDFLoader, Docx2txtLoader, TextLoader


# Loading PDF, DOCX, and TXT files as LangChain documents
def load_document(file):
    name, extension = os.path.splitext(file)

    if extension == '.pdf':
        st.write(f'Loading {file}')
        loader = PyPDFLoader(file)
    elif extension == '.docx':
        st.write(f'Loading {file}')
        loader = Docx2txtLoader(file)
    elif extension == '.txt':
        st.write(f'Loading {file}')
        loader = TextLoader(file)
    else:
        st.error('Document format is not supported!')
        return None

    data = loader.load()
    return data


# Splitting data into chunks
def chunk_data(data, chunk_size=256, chunk_overlap=20):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    chunks = text_splitter.split_documents(data)
    return chunks


# Create embeddings using OpenAIEmbeddings() and save them in a Chroma vector store
def create_embeddings(chunks):
    embeddings = OpenAIEmbeddings(model='text-embedding-ada-002')
    vector_store = Chroma.from_documents(chunks, embeddings, persist_directory="./chroma_store")
    vector_store.persist()  # Save the vector store to disk
    return vector_store


# Ask a question and get an answer using the vector store
def ask_and_get_answer(vector_store, q, k=3):
    llm = ChatOpenAI(model='gpt-3.5-turbo', temperature=1)
    retriever = vector_store.as_retriever(search_type='similarity', search_kwargs={'k': k})
    chain = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever)
    answer = chain.invoke(q)
    return answer['result']


# Clear the chat history and vector store from Streamlit session state
def clear_history():
    if 'history' in st.session_state:
        del st.session_state['history']
    if 'vs' in st.session_state:
        del st.session_state['vs']


if __name__ == "__main__":
    # Load the OpenAI API key from .env
    load_dotenv(find_dotenv(), override=True)
    st.subheader('Welcome to our Pepper Chatbot!')

    # Sidebar for user inputs
    with st.sidebar:
        # File uploader widget
        uploaded_file = st.file_uploader('Please upload a file:', type=['pdf', 'docx', 'txt'])

        # Chunk size number widget
        chunk_size = st.number_input('Chunk size:', min_value=100, max_value=2048, value=512, on_change=clear_history)

        # k number input widget
        k = st.number_input('k number:', min_value=1, max_value=20, value=3, on_change=clear_history)

        # Add data button widget
        add_data = st.button('Add Data', on_click=clear_history)

        # If the user uploads a file and clicks 'Add Data'
        if uploaded_file and add_data:
            with st.spinner('Reading, chunking, and embedding file ...'):
                # Write the uploaded file to disk
                bytes_data = uploaded_file.read()
                file_name = os.path.join('./', uploaded_file.name)
                with open(file_name, 'wb') as f:
                    f.write(bytes_data)

                # Process the file
                data = load_document(file_name)
                if data:
                    chunks = chunk_data(data, chunk_size=chunk_size)
                    st.write(f'Chunk size: {chunk_size}, Chunks: {len(chunks)}')

                    # Create embeddings and save the vector store
                    vector_store = create_embeddings(chunks)
                    st.session_state.vs = vector_store
                    st.success('File uploaded, chunked, and embedded successfully!')

    # Reload Chroma vector store if not already in session state
    if 'vs' not in st.session_state:
        try:
            st.session_state.vs = Chroma(persist_directory="./chroma_store", embedding_function=OpenAIEmbeddings())
        except ValueError:
            st.warning("No previous vector store found. Please upload a document and add data.")

    # Question input widget
    q = st.text_input('Please ask a question:')

    # Process the user's question
    if q:
        if 'vs' in st.session_state:  # Ensure the vector store is available
            vector_store = st.session_state.vs
            st.write(f'k: {k}')
            answer = ask_and_get_answer(vector_store, q, k)

            # Display the answer
            st.text_area('Chatbot answer:', value=answer, height=100)

            # Divider for better UI
            st.divider()

            # Maintain chat history
            if 'history' not in st.session_state:
                st.session_state.history = ''

            # Update history with current question and answer
            value = f'Q: {q}\nA: {answer}'
            st.session_state.history = f'{value}\n{"-" * 100}\n{st.session_state.history}'
            h = st.session_state.history

            # Display chat history
            st.text_area('Chat History', value=h, key='history', height=400)
        else:
            st.error("Please upload a document and add data first.")
