//llm key
//LLAMA_API_KEY=

//make instance of model
//import { modelinstname } from lang community llama
//const model = new modelinstname({
//    model: "specify llama model"
//    temperature: 0 //affects hallucination
//});
import { HumanMessage, SystemMessage } from "@langchain/core/messages";

const messages = [
  new SystemMessage("Translate the following from English into Italian"),
  new HumanMessage("hi!"),
];
await model.invoke(messages);   //returns AIMessage obj
import { StringOutputParser } from "@langchain/core/output_parsers";

const parser = new StringOutputParser();

const result = await model.invoke(messages);    //save response
await parser.invoke(result);    //output response

const chain = model.pipe(parser);   //links model output with output parser
await chain.invoke(messages);

import { ChatPromptTemplate } from "@langchain/core/prompts";
const systemTemplate = "Translate the following into {language}:";
const promptTemplate = ChatPromptTemplate.fromMessages([
    ["system", systemTemplate],
    ["user", "{text}"],
]);
const promptValue = await promptTemplate.invoke({
    language: "italian",
    text: "hi",
});

promptValue;    //returns ChatPromptValue obj
promptValue.toChatMessages(); 

const llmChain = promptTemplate.pipe(model).pipe(parser);
await llmChain.invoke({ language: "italian", text: "hi" }); //three component chain

//--chatbot tut
await llm.invoke([{ role: "user", content: "Hi im bob" }]);

//langgraph msg persistence
import {
  START,
  END,
  MessagesAnnotation,
  StateGraph,
  MemorySaver,
} from "@langchain/langgraph";

// Define the function that calls the model
const callModel = async (state: typeof MessagesAnnotation.State) => {
  const response = await llm.invoke(state.messages);
  return { messages: response };
};

// Define a new graph
const workflow = new StateGraph(MessagesAnnotation)
  // Define the node and edge
  .addNode("model", callModel)
  .addEdge(START, "model")
  .addEdge("model", END);

// Add memory
const memory = new MemorySaver();
const app = workflow.compile({ checkpointer: memory });

import { v4 as uuidv4 } from "uuid";

const config = { configurable: { thread_id: uuidv4() } }; //enables mult convo threads in single app
const input = [
  {
    role: "user",
    content: "Hi! I'm Bob.",
  },
];
const output = await app.invoke({ messages: input }, config);
// The output contains all messages in the state.
// This will log the last message in the conversation.
console.log(output.messages[output.messages.length - 1]);
const input2 = [
  {
    role: "user",
    content: "What's my name?",
  },
];
const output2 = await app.invoke({ messages: input2 }, config);
console.log(output2.messages[output2.messages.length - 1]);

// ---from RAG tutorial---

// import "cheerio";
// import { CheerioWebBaseLoader } from "@langchain/community/document_loaders/web/cheerio";
// import { RecursiveCharacterTextSplitter } from "langchain/text_splitter";
// import { MemoryVectorStore } from "langchain/vectorstores/memory";
// import { OpenAIEmbeddings, ChatOpenAI } from "@langchain/openai";
// import { pull } from "langchain/hub";
// import { ChatPromptTemplate } from "@langchain/core/prompts";
// import { StringOutputParser } from "@langchain/core/output_parsers";
// import { createStuffDocumentsChain } from "langchain/chains/combine_documents";

// const loader = new CheerioWebBaseLoader(
//   "https://lilianweng.github.io/posts/2023-06-23-agent/"
// );

// const docs = await loader.load();

// const textSplitter = new RecursiveCharacterTextSplitter({
//   chunkSize: 1000,
//   chunkOverlap: 200,
// });
// const splits = await textSplitter.splitDocuments(docs);
// const vectorStore = await MemoryVectorStore.fromDocuments(
//   splits,
//   new OpenAIEmbeddings()
// );

// // Retrieve and generate using the relevant snippets of the blog.
// const retriever = vectorStore.asRetriever();
// const prompt = await pull<ChatPromptTemplate>("rlm/rag-prompt");
// const llm = new ChatOpenAI({ model: "gpt-3.5-turbo", temperature: 0 });

// const ragChain = await createStuffDocumentsChain({
//   llm,
//   prompt,
//   outputParser: new StringOutputParser(),
// });

// const retrievedDocs = await retriever.invoke("what is task decomposition");

// await ragChain.invoke({
//     question: "What is task decomposition?",
//     context: retrievedDocs,
// });