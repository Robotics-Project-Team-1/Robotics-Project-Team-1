import { ChatOllama } from "@langchain/ollama";
import { HumanMessage, SystemMessage } from "@langchain/core/messages";

//instantiate model
const llm = new ChatOllama({
  model: "llama3.2",
  temperature: 0,
  //maxRetries: 2,
  // other params...
});
console.log("model instantiate");

//--sample invocation
// const inputText = "Ollama is an AI company that ";

// const completion = await llm.invoke(inputText);
// completion;

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
//"Ollama" gives undefined response; "ChatOllama" responds "Je aime le programmation.""

// with chain
// import { ChatPromptTemplate } from "@langchain/core/prompts";

// const prompt = ChatPromptTemplate.fromMessages([
//   [
//     "system",
//     "You are a helpful assistant that translates {input_language} to {output_language}.",
//   ],
//   ["human", "{input}"],
// ]);

// const chain = prompt.pipe(llm);
// const aimsg = await chain.invoke({
//   input_language: "English",
//   output_language: "German",
//   input: "I love programming.",
// });
// console.log(aimsg);


//Message History


import { ChatPromptTemplate } from "@langchain/core/prompts";
