import React, { useState } from "react";
import pepperLogo from "../assets/images/avatar.svg";
import user from "../assets/images/user.svg";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faBars,
  faEdit,
  faPaperPlane,
} from "@fortawesome/free-solid-svg-icons";

const Chat = () => {
  const [threads, setThreads] = useState([]);
  const [currentThread, setCurrentThread] = useState(null);
  const [inputMessage, setInputMessage] = useState("");

  //create new thread
  const handleCreateNewThread = () => {
    const newThread = {
      id: threads.length + 1,
      title: "New Chat",
      messages: [
        {
          text: "Hi, I'm Pepper! I'm an AI assistant who can help answer any of your questions regarding the Georgia State University Computer Science Graduate Handbook. How can I assist you today?",
          sender: "Pepper",
        },
      ],
    };
    setThreads([...threads, newThread]);
    setCurrentThread(newThread);
  };

  //send message
  const handleSendMessage = (e) => {
    e.preventDefault();
    if (inputMessage.trim() !== "" && currentThread) {
      const updatedThread = {
        ...currentThread,
        messages: [
          ...currentThread.messages,
          { text: inputMessage, sender: "You" },
        ],
        title:
          currentThread.messages.length === 1
            ? inputMessage
            : currentThread.title,
      };
      setThreads(
        threads.map((thread) =>
          thread.id === currentThread.id ? updatedThread : thread
        )
      );
      setCurrentThread(updatedThread);
      setInputMessage("");
      handlePepperReply(updatedThread);
    }
  };
  //handle pepper reply
  const handlePepperReply = (updatedThread) => {
    setTimeout(() => {
      const replyMessage = {
        text: "Pepper's Response",
        sender: "Pepper",
      };
      const updatedThreadWithReply = {
        ...updatedThread,
        messages: [...updatedThread.messages, replyMessage],
      };
      setThreads(
        threads.map((thread) =>
          thread.id === updatedThread.id ? updatedThreadWithReply : thread
        )
      );
      setCurrentThread(updatedThreadWithReply);
    }, 1000); // Simulate delay in Pepper's response
  };

  //select thread
  const handleSelectThread = (thread) => {
    setCurrentThread(thread);
    document.getElementById("close-sidebar")?.click();
  };

  //map threads in reverse
  const reversedThreads = [...threads].reverse(); // Reverse without mutating the original state

  return (
    <>
      {/* mobile header */}

      <div className="container-fluid d-flex flex-column overflow-hidden chatbox bg-white shadow-lg">
        <div className="row h-100 w-100 ">
          {/* sidebar (mobile) */}
          

          {/* sidebar (desktop) */}
          <div
            className="col-md-3 d-none d-md-flex flex-column bg-white p-3"
            style={{ borderRight: "1px solid rgba(0,0,0,.15)" }}
          >
            <div className="d-flex align-items-center justify-content-between mb-4">
              <div className="d-flex align-items-center">
                <img
                  src={pepperLogo}
                  alt="Pepper Logo"
                  style={{ width: "40px", height: "40px" }}
                />
                <h3 className="mx-2 mt-2">Pepper</h3>
              </div>
              <FontAwesomeIcon
                className="hover point"
                size="xl"
                onClick={handleCreateNewThread}
                icon={faEdit}
              />
            </div>
            {/* threads */}
            <div className="flex-grow-1">
              <p className="fs-6 fw-semibold text-secondary">Chat History</p>
              <ul className="list-unstyled">
                {reversedThreads.map((thread) => (
                  <li key={thread.id} className="mb-3">
                    <button
                      className={`btn btn-transparent hover w-100 text-start rounded-4 py-3 text-truncate  ${
                        currentThread?.id === thread.id
                          ? "bg-primary text-white hover-btn-2 fw-semibold shadow-lg"
                          : "hover-btn"
                      }`}
                      onClick={() => handleSelectThread(thread)}
                      style={{ maxWidth: "100%" }}
                    >
                      {thread.messages.length > 0 && thread.messages[0].sender === "You"
                        ? thread.messages[0].text
                        : (thread.messages[1] && thread.messages[1].text ? thread.messages[1].text : "New Chat")}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          <div className="col-12 col-md-9 d-flex flex-column justify-content-between mt-md-4">
            {currentThread ? (
              <>
                <h2
                  className="text-secondary d-none d-md-block text-truncate"
                  style={{ maxWidth: "100%" }}
                >
                  {/* title (changes based on first query) */}
                  {currentThread.messages.length > 0
                    ? currentThread.title
                    : "New Chat"}
                </h2>
                <div
                  className="mt-3 flex-grow-1 overflow-auto hide-scroll"
                  style={{
                    wordBreak: "break-word",
                    maxHeight: "calc(100vh - 220px)",
                    overflowY: "auto",
                  }}
                >
                  {/* display chat bubbles for queries & responses */}
                  {currentThread.messages.map((msg, index) => (
                    <div
                      key={index}
                      className={`d-flex align-items-center ${
                        msg.sender === "You"
                          ? "justify-content-end"
                          : "justify-content-end flex-row-reverse"
                      } mb-3`}
                    >
                      <div
                        className="p-3 mx-1 rounded-4 hover shadow-lg"
                        style={{
                          backgroundColor:
                            msg.sender === "You" ? "#008BE8" : "#F0F0F0",
                          color: msg.sender === "You" ? "#fff" : "#000",
                          maxWidth: "75%",
                          wordBreak: "break-word",
                          whiteSpace: "pre-wrap",
                          overflowWrap: "break-word",
                          overflowY: "auto",
                        }}
                      >
                        <p className="mb-0" style={{ wordWrap: "break-word" }}>
                          {msg.text}
                        </p>
                      </div>
                      <img
                        src={msg.sender === "You" ? user : pepperLogo}
                        alt={msg.sender === "You" ? "User" : "Pepper Logo"}
                        style={{ width: "24px", height: "24px" }}
                      />
                    </div>
                  ))}
                </div>
                {/* txtinput */}
                <form
                  className="pb-3 sticky-bottom"
                  onSubmit={handleSendMessage}
                >
                  <div className="d-flex align-items-center">
                    <input
                      type="text"
                      className="form-control me-2 py-2 rounded-5 shadow-lg"
                      placeholder="Ask Pepper..."
                      value={inputMessage}
                      onChange={(e) => setInputMessage(e.target.value)}
                    />
                    <button
                      className="btn-primary rounded-5 px-3 d-flex flex-column justify-content-center align-items-center shadow-lg"
                      type="submit"
                      style={{ width: "2.5rem", height: "2.5rem" }}
                    >
                      <FontAwesomeIcon icon={faPaperPlane} />
                    </button>
                  </div>
                </form>
              </>
            ) : (
              <div className="d-flex justify-content-center align-items-center flex-grow-1">
                {/* handle no chats (default) */}
                <h4>Select or create a new thread to start chatting</h4>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default Chat;
