//llm key
//LLAMA_API_KEY=

//make instance of model
//import { modelinstname } from lang community llama
//const model = new modelinstname({
//    model: "specify llama model"
//    temperature: 0 //affects hallucination
//});

import { Ollama } from "@langchain/ollama";

const llm = new Ollama({
  model: "llama3.2",
  temperature: 0,
  maxRetries: 2,
  // other params...
});
//ollama invocation
const inputText = "Ollama is an AI company that ";

const completion = await llm.invoke(inputText);
completion;

//ollama prompt template chain
import { PromptTemplate } from "@langchain/core/prompts";

const prompt = PromptTemplate.fromTemplate(
  "How to say {input} in {output_language}:\n"
);

const chain = prompt.pipe(llm);
await chain.invoke({
  output_language: "German",
  input: "I love programming.",
});

//end ollama samples


//All messages have role, content, response_metadata; optional property name for speakers with same role
//HumanMessage = user role; AIMessage = assistant role, has response_metadata and tool_calls (chat model response); SystemMessage = instructs model behavior;ToolMessage = tool usage result
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
await llm.invoke([{ role: "user", content: "Whats my name" }]);
//demonstrates lack of state
await llm.invoke([
  { role: "user", content: "Hi! I'm Bob" },
  { role: "assistant", content: "Hello Bob! How can I assist you today?" },
  { role: "user", content: "What's my name?" },
]);
//pass convo history to model, cna now "recall" name

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

//different thread
const config2 = { configurable: { thread_id: uuidv4() } };
const input3 = [
  {
    role: "user",
    content: "What's my name?",
  },
];
const output3 = await app.invoke({ messages: input3 }, config2);
console.log(output3.messages[output3.messages.length - 1]);

//return to og convo thread
const output4 = await app.invoke({ messages: input2 }, config);
console.log(output4.messages[output4.messages.length - 1]);


//working w prompt template- take user format and convert to format for llm
import {
  ChatPromptTemplate,
  MessagesPlaceholder,
} from "@langchain/core/prompts";

const prompt = ChatPromptTemplate.fromMessages([
  [
    "system",
    "You talk like a pirate. Answer all questions to the best of your ability.",
  ],
  new MessagesPlaceholder("messages"),
]);
//update app to incorporate prompt template
import {
  START,
  END,
  MessagesAnnotation,
  StateGraph,
  MemorySaver,
} from "@langchain/langgraph";

// Define the function that calls the model
const callModel2 = async (state: typeof MessagesAnnotation.State) => {
  const chain = prompt.pipe(llm);
  const response = await chain.invoke(state);
  // Update message history with response:
  return { messages: [response] };
};

// Define a new graph
const workflow2 = new StateGraph(MessagesAnnotation)
  // Define the (single) node in the graph
  .addNode("model", callModel2)
  .addEdge(START, "model")
  .addEdge("model", END);

// Add memory
const app2 = workflow2.compile({ checkpointer: new MemorySaver() });

const config3 = { configurable: { thread_id: uuidv4() } };
const input4 = [
  {
    role: "user",
    content: "Hi! I'm Jim.",
  },
];
const output5 = await app2.invoke({ messages: input4 }, config3);
console.log(output5.messages[output5.messages.length - 1]);

const input5 = [
  {
    role: "user",
    content: "What is my name?",
  },
];
const output6 = await app2.invoke({ messages: input5 }, config3);
console.log(output6.messages[output6.messages.length - 1]);

//add lang param; app now takes lang and msg
const prompt2 = ChatPromptTemplate.fromMessages([
  [
    "system",
    "You are a helpful assistant. Answer all questions to the best of your ability in {language}.",
  ],
  new MessagesPlaceholder("messages"),
]);

//update app state for lang
import {
  START,
  END,
  StateGraph,
  MemorySaver,
  MessagesAnnotation,
  Annotation,
} from "@langchain/langgraph";

// Define the State
const GraphAnnotation = Annotation.Root({
  ...MessagesAnnotation.spec,
  language: Annotation<string>(),
});

// Define the function that calls the model
const callModel3 = async (state: typeof GraphAnnotation.State) => {
  const chain = prompt2.pipe(llm);
  const response = await chain.invoke(state);
  return { messages: [response] };
};

const workflow3 = new StateGraph(GraphAnnotation)
  .addNode("model", callModel3)
  .addEdge(START, "model")
  .addEdge("model", END);

const app3 = workflow3.compile({ checkpointer: new MemorySaver() });
const config4 = { configurable: { thread_id: uuidv4() } };
const input6 = {
  messages: [
    {
      role: "user",
      content: "Hi im bob",
    },
  ],
  language: "Spanish",
};
const output7 = await app3.invoke(input6, config4);
console.log(output7.messages[output7.messages.length - 1]);
//omit lang param and convo stays in lang
const input7 = {
  messages: [
    {
      role: "user",
      content: "What is my name?",
    },
  ],
};
const output8 = await app3.invoke(input7, config4);
console.log(output8.messages[output8.messages.length - 1]);

//msg trimmer to manage convo history; run before msgs are passed to prompt
const trimmer = trimMessages({
  maxTokens: 10,
  strategy: "last",
  tokenCounter: (msgs) => msgs.length,
  includeSystem: true,
  allowPartial: false,
  startOn: "human",
});
const callModel4 = async (state: typeof GraphAnnotation.State) => {
  const chain = prompt2.pipe(llm);
  const trimmedMessage = await trimmer.invoke(state.messages);
  const response = await chain.invoke({
    messages: trimmedMessage,
    language: state.language,
  });
  return { messages: [response] };
};

const workflow4 = new StateGraph(GraphAnnotation)
  .addNode("model", callModel4)
  .addEdge(START, "model")
  .addEdge("model", END);

const app4 = workflow4.compile({ checkpointer: new MemorySaver() });
//trims older lines, so can forget names/important info

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