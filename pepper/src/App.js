import './App.css';
import './config/firebase.js';
import './config/genkit.js';
import * as React from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Home from './containers/Home';
import Chat from './containers/Chat';

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/chat" element={<Chat />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
