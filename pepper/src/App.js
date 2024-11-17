import "./styles/App.css";
import "./firebase.js";
import * as React from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Home from "./components/Home.jsx";
import Chat from "./components/Chat.jsx";

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/chat" element={<Chat />} />

          <Route path="/file_upload"/>

        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
