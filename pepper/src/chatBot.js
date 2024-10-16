import { ChatOllama } from "@langchain/ollama";
import { HumanMessage, SystemMessage } from "@langchain/core/messages";

//instantiate model
const llm = new ChatOllama({
  model: "llama3.2",
  temperature: 0,
  //maxRetries: 2,
  // other params...
});
console.log("model instantiated");

//--sample invocation

// const aiMsg = await llm.invoke([
//     [
//       "system",
//       "You are a helpful assistant that translates English to French. Translate the user sentence.",
//     ],
//     ["human", "I love programming."],
// ]);
// console.log("msg invocation");
// aiMsg;
// console.log(aiMsg.content);
//"Ollama" gives undefined response; "ChatOllama" responds "Je aime le programmation."

// with chain
// import { ChatPromptTemplate, MessagesPlaceholder } from "@langchain/core/prompts";
// const prompt = ChatPromptTemplate.fromMessages([
//   [
//     "system",
//     "You are a helpful assistant that answers the user's questions.",
//   ],
//   ["human", "{input}"],
// ]);

// const chain = prompt.pipe(llm);
// const aimsg = await chain.invoke({
//   input: "I love programming.",
//   chat_history: 
// });
// console.log(aimsg);


//Message History

// import {
//   START,
//   END,
//   MessagesAnnotation,
//   StateGraph,
//   MemorySaver,
// } from "@langchain/langgraph";
import { ChatPromptTemplate, MessagesPlaceholder } from "@langchain/core/prompts";
const chatHistory = [];

//sample history
// const chatHistory = [
//  new HumanMessage("My name is Bob"),
// ];

const prompt = ChatPromptTemplate.fromMessages([
  [
    "system",
    "You are a helpful assistant that answers the user's questions.",
  ],
  new MessagesPlaceholder("chat_history"),  //converts arr of msg to strings
  ["human", "{input}"],
]);

const chain = prompt.pipe(llm);
const aimsg = await chain.invoke({
  input: "What is my name?",
  chat_history: chatHistory,
});
console.log(aimsg);
//when response is received, append human msg + ai msg to chat history