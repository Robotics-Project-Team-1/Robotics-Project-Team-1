import React, { useState } from "react";

const Chat = () => {
  const [messages, setMessages] = useState([]);
  const [inputMessage, setInputMessage] = useState("");

  const handleSendMessage = (e) => {
    e.preventDefault();
    if (inputMessage.trim() !== "") {
      setMessages([...messages, { text: inputMessage, sender: "You" }]);
      setInputMessage("");
    }
  };

  return (
    <div className="chat-container">
      <h1>Question Title</h1>
      <div className="message-list">
        {messages.map((message, index) => (
          <div key={index} className="message">
            <strong>{message.sender}: </strong>
            {message.text}
          </div>
        ))}
      </div>
      <form onSubmit={handleSendMessage}>
        <input
          type="text"
          value={inputMessage}
          onChange={(e) => setInputMessage(e.target.value)}
          placeholder="Ask Pepper a question about the GSU CS Graduate Handbook..."
        />
        <button type="submit">Send</button>
      </form>
    </div>
  );
};

export default Chat;
