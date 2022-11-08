// import { createApp } from "vue";
import Vue from "vue";
// import App from "./App.vue";

import io from "socket.io-client";
const socket = io("http://localhost:3000");
Vue.prototype.$socket = socket;

Vue.prototype.$connection = ($payload) => {
  socket.emit("connection", $payload);
};

Vue.prototype.$disconnect = ($payload) => {
  socket.emit("disconnect", $payload);
};

// const SocketPlugin = {
//   install(vue) {
//     vue.mixin({});

//     vue.prototype.$connection = ($payload) => {
//       socket.emit("connection", $payload);
//     };

//     vue.prototype.$disconnect = ($payload) => {
//       socket.emit("disconnect", $payload);
//     };

//     // vue.prototype.$sendMessage = ($payload) => {
//     //   socket.emit("chat", {
//     //     msg: $payload.msg,
//     //     name: $payload.name,
//     //     avatar: $payload.avatar,
//     //   });
//     // };

//     vue.prototype.$socket = socket;
//   },
// };

// const app = createApp(); // Vue 초기화를 위한 새로운 메서드
// app.use(SocketPlugin);
