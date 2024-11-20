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
    embeddings = OpenAIEmbeddings()
    vector_store = Chroma.from_documents(chunks, embeddings)
    vector_store.persist()
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
        /* Main container */
        .stApp {
            background-color: white;
        }
        
        /* Sidebar */
        section[data-testid="stSidebar"] {
            background-color: #0039A6 !important;
            padding: 1rem;
        }
        
        section[data-testid="stSidebar"] > div {
            background-color: #0039A6 !important;
        }
        /* Sidebar buttons */
        section[data-testid="stSidebar"] .stButton button {
            width: 100%;
            background-color: rgba(255, 255, 255, 1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #0039A6 !important;
            margin: 0.5rem 0;
        }

        /* Chat bubbles */
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
        
        /* Sidebar labels */
        section[data-testid="stSidebar"] label,
        section[data-testid="stSidebar"] .stMarkdown,
        section[data-testid="stSidebar"] .stText,
        section[data-testid="stSidebar"] h3 {
            color: white !important;
        }
        
        /* Sidebar file uploader */
        section[data-testid="stSidebar"] .stFileUploader label,
        section[data-testid="stSidebar"] .stFileUploader span {
            color: white !important;
        }
        
        /* Sidebar number input */
        section[data-testid="stSidebar"] .stNumberInput label {
            color: white !important;
        }
        
        /* Homepage */
        .homepage-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #0039A6;
            padding: 2rem;
            margin-bottom: 2rem;
            border-radius: 15px;
            position: relative;  /* Added for positioning the tail */
        }
        
        /* Chat bubble tail */
        .homepage-content:after {
            content: '';
            position: absolute;
            right: -20px;
            bottom: 30px;
            border-left: 20px solid #0039A6;
            border-top: 20px solid transparent;
            border-bottom: 20px solid transparent;
        }
        
        /* Homepage title */
        .homepage-title {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 1.5rem;
            line-height: 1;
            color: white;
        }
        
        /* Pepper name */
        .pepper-name {
            font-size: 5rem;
            color: white;
            text-shadow: 0 16px 30px rgba(0, 57, 166, 0.25);
        }
        
        /* Homepage subtitle */
        .homepage-subtitle {
            font-size: 1.25rem;
            color: rgba(255, 255, 255, 0.75);
            line-height: 1.5;
        }
      
        
        
        /* Hide sidebar on homepage */
        .hide-sidebar [data-testid="stSidebar"] {
            display: none;
        }
        
        /* Center content vertically */
        [data-testid="column"] {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        </style>
    """, unsafe_allow_html=True)

# init chat history
def initialize_chat_history():
    if 'chat_threads' not in st.session_state:
        st.session_state.chat_threads = []
    if 'current_thread_id' not in st.session_state:
        st.session_state.current_thread_id = None

# create new chat
def create_new_chat():
    thread_id = len(st.session_state.chat_threads)
    new_thread = {
        'id': thread_id,
        'title': 'New Chat',
        'messages': []
    }
    st.session_state.chat_threads.append(new_thread)
    st.session_state.current_thread_id = thread_id

# display chat messages
def display_chat_messages():
    if st.session_state.current_thread_id is not None:
        thread = st.session_state.chat_threads[st.session_state.current_thread_id]
        for msg in thread['messages']:
            if msg['sender'] == 'You':
                st.markdown(f"""
                    <div class="user-bubble">
                        {msg['text']}
                    </div>
                """, unsafe_allow_html=True)
            else:
                st.markdown(f"""
                    <div class="bot-bubble">
                        {msg['text']}
                    </div>
                """, unsafe_allow_html=True)

#show logos
def display_logos():
    
    col1, col2 = st.sidebar.columns(2)
    with col1:
        st.image("./gsu.svg", width=100)
    with col2:
        st.image("./avatar.svg", width=75)
    st.markdown("### Pepper Chatbot")
    
#show splash screen
def show_splash_screen():
    st.info("Upload the GSU Handbook, then create a new chat to begin")

#show homepage
def show_homepage():
    col1, col2 = st.columns([3, 2])
    
    with col1:
        st.markdown("""
            <div class="homepage-content">
                <h1 class="homepage-title">
                    Hello, I'm <span class="pepper-name">Pepper</span>
                </h1>
                <p class="homepage-subtitle">
                    I'm here to answer any questions you have about the GSU Computer Science Graduate Handbook
                </p>
            </div>
        """, unsafe_allow_html=True)
        
        #naviggate to chat page
        if st.button('Ask me a question', use_container_width=True, type='primary' ):
            st.session_state.show_homepage = False
            st.rerun()
    
    with col2:
        st.image("./pepper.svg", width=500)

# ui
if __name__ == "__main__":
    load_dotenv(find_dotenv(), override=True)
    set_custom_style()
    initialize_chat_history()
    
    #show homepage
    if 'show_homepage' not in st.session_state:
        st.session_state.show_homepage = True
    
    #show homepage or chat
    if st.session_state.show_homepage:
        st.markdown('<div class="hide-sidebar">', unsafe_allow_html=True)
        show_homepage()
        st.markdown('</div>', unsafe_allow_html=True)
    else:
        st.markdown('<div class="show-sidebar">', unsafe_allow_html=True)
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
            # new chat button
            if st.button('New Chat', key='new_chat'):
                create_new_chat()
            # chat history displayed in reverse order
            st.markdown("### Chat History")
            for thread in reversed(st.session_state.chat_threads):
                title = thread['title']
                is_active = st.session_state.current_thread_id == thread['id']
                if st.button(
                    title, 
                    key=f"thread_{thread['id']}", 
                    use_container_width=True,
                    type='primary' if is_active else 'secondary'
                ):
                    st.session_state.current_thread_id = thread['id']
            
            st.divider()

        # Main chat area
        if st.session_state.current_thread_id is not None:
            display_chat_messages()
            
            # Chat input
            with st.form(key='chat_form', clear_on_submit=True):
                user_input = st.text_input('Message Pepper...', key='user_input')
                submit_button = st.form_submit_button('Send')
                
                if submit_button and user_input:
                    thread = st.session_state.chat_threads[st.session_state.current_thread_id]
                    
                    # Update thread title if first message
                    if len(thread['messages']) == 0:
                        thread['title'] = user_input[:30] + '...' if len(user_input) > 30 else user_input
                    
                    # Add user message
                    thread['messages'].append({
                        'text': user_input,
                        'sender': 'You'
                    })
                    
                    # Get and add bot response
                    if 'vs' in st.session_state:
                        answer = ask_and_get_answer(st.session_state.vs, user_input, st.session_state.get('k', 3))
                        thread['messages'].append({
                            'text': answer,
                            'sender': 'Pepper'
                        })
                    st.rerun()
        else:
            #show splash screen
            show_splash_screen()

        st.markdown('</div>', unsafe_allow_html=True)



