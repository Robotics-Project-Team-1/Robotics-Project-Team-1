# Robotics Project Team 1 Project - Salt with Pepper

## Overview

Welcome to our Robotics Project Team 1 Project - Salt with Pepper! This project creates an AI chatbot that helps GSU CS grad students quickly find answers from the graduation handbook using natural language processing and GPT technology.

## Team Members:

- **Boluwatife Owolabi**
- **Meghana Coca**
- **Bang Pham**
- **Sophie Nguyen**

## Running Application

To run the Salt with Pepper locally on your machine, follow these steps:

### Prerequisites

1. **Python 3.10.0**  
   Ensure Python 3.10.0 is installed on your system. This specific version is required for compatibility reasons.  
   If you do not have it, download and install it from the [official Python website](https://www.python.org/downloads/).

2. **Code Editor**  
   Use any code editor you’re comfortable with. We recommend [Visual Studio Code](https://code.visualstudio.com/) for its robust features and seamless development experience.

3. **OpenAI GPT API Key**  
   Obtain an API key from [OpenAI's API page](https://platform.openai.com/signup/). This paid key is essential to access OpenAI's GPT services.

### Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/Robotics-Project-Team-1/Robotics-Project-Team-1.git

   ```

2. **Navigate to the Project Directory**:

   ```bash
   cd Robotics-Project-Team-1

   ```

3. **Open the Project in Your Code Editor**

4. **Set Up the `.env` File**:
   Navigate to the `src` folder and create a file named `.env`. Add your OpenAI API key in the following format:

   ```bash
   OPENAI_API_KEY="your_openai_api_key_here"

   ```

   Replace `your_openai_api_key_here` with the actual API key obtained from OpenAI.

5. **Install Required Libraries**:
   In the `src` folder, run the following command:

   ```bash
   cd src
   pip3 install -r ./requirements.txt

   ```

6. **Run the Application**:

   ```bash
   streamlit run ./pepper.py

   ```

## Problem Statement and Goal

### Problem Statement:

Graduate students in Georgia State University's Computer Science program often struggle to find specific information within long, complex graduation handbooks. Manually searching through these documents is time-consuming and inefficient.

### Goal:

Inspired by the capabilities of the Pepper robot, the goal of this project is to develop an AI chatbot capable of answering students' questions based on the content of the CS graduate handbook PDF file. The chatbot will leverage natural language processing to provide accurate and efficient responses.

## Key Features

- **Document-based Q&A:** Supports uploading PDF, DOCX, and TXT files, creating vector embeddings, and using OpenAI's GPT-3.5-Turbo to answer questions about uploaded documents.
- **Configurable Search Parameters:** Users can adjust chunk size and retrieval parameters and customize document processing for more precise information retrieval.
- **Specialized Handbook Assistant:** Specifically designed to help users navigate and understand the GSU Computer Science Graduate Handbook through an interactive, AI-powered chatbot interface.

## Tech Stack:

- **Front End:** Streamlit, HTML & CSS
- **Back End:** Python
- **LLM Integration:** LangChain
- **PDF Parsing:** pypdf
- **LLM Models:** OpenAI GPT API integrated via `LangChain`
- **Storage:** chromadb
- **Version Control:** Git & GitHub
- [GSU CS graduate handbook PDF file](https://drive.google.com/file/d/1KvNLtqjVvo0lc-GnyTFjyADFKE4Jiglb/view?usp=drive_link) for chatbot data.

## Contributing

We welcome contributions from the community! If you'd like to contribute to the Project Team 1 Project, please follow this [CONTRIBUTING](https://github.com/Robotics-Project-Team-1/Robotics-Project-Team-1/blob/main/CONTRIBUTING.md).

## License

This project is licensed under the [LICENSE](https://github.com/Robotics-Project-Team-1/Robotics-Project-Team-1/blob/main/LICENSE).

## Contact

For any inquiries or suggestions regarding the Robotics Project Team 1 Project, please contact:

- Boluwatife Owolabi: [bolu.owolabi12@gmail.com](mailto:bolu.owolabi12@gmail.com)
- M. Coca: [mcoca1@student.gsu.edu](mailto:mcoca1@student.gsu.edu)
- Bang Pham: [bangapham16@gmail.com](mailto:bangapham16@gmail.com)
- Sophie Nguyen: [sophienguyen113@gmail.com](mailto:sophienguyen113@gmail.com)

Thank you for your interest in our project! We look forward to your contributions and feedback. Happy coding! 🚀
