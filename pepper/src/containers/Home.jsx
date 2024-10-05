import React from "react";
import { Link } from "react-router-dom";
import pepperImg from "../assets/images/pepper.svg";

const Home = () => {
  return (
    <div
      className="container-fluid  d-flex flex-column justify-content-center align-items-center overflow-y-hidden"
      style={{ height: "100vh" }}
    >
      <div
        className="container-fluid bg-white rounded-5 p-lg-5 shadow-lg "
        style={{ width: "95vw", height: "90vh" }}
      >
        <div className="row">
          <div className="col-lg-5 order-lg-1 order-2 d-flex  justify-content-center">
            <img
              className="hover"
              src={pepperImg}
              alt="pepperImage"
              style={{ maxHeight: "100vh" }}
            />
          </div>
          <div className="col-lg-7 order-lg-2 order-1 py-5 pb-0  d-flex flex-column align-items-center align-items-lg-start">
            <h1 className="fw-bold home-title mb-3 hover ">
              Hello, <br />
              I'm{" "}
              <span
                className="text-primary "
                style={{ textShadow: "0 16px 30px rgba(0, 139, 232, 0.25)" }}
              >
                Pepper
              </span>
            </h1>
            <p className="fs-5 text-secondary mb-4 text-center text-lg-start mx-1 mx-sm-5 mx-lg-0 hover">
              I’m here to answer any questions you have about the GSU Computer
              Science Graduate Handbook
            </p>
            <Link to="/chat">
              <button className="btn btn-primary">Ask me a question</button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
