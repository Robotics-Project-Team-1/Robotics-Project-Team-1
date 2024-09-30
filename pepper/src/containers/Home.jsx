import React from 'react';
import { Link } from 'react-router-dom';

const Home = () => {
  return (
    <div className="home-container">
      <h1>Hello, I'm Pepper</h1>
      <p>I’m here to answer any questions you have about the GSU Computer Science Graduate Handbook</p>
      <Link to="/chat" className="chat-button">
     <button>
     Ask me a question
     </button>
      </Link>
    </div>
  );
};

export default Home;
