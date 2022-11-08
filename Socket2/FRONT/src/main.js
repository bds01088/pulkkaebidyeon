import { createApp } from "vue";
import App from "./App.vue";

// import "./plugins/socketPlugin";

// import Vue from "vue";

// import io from "socket.io-client";
// const socket = io("http://localhost:3000");
// Vue.prototype.$socket = socket;

// Vue.prototype.$connection = ($payload) => {
//   socket.emit("connection", $payload);
// };

// Vue.prototype.$disconnect = ($payload) => {
//   socket.emit("disconnect", $payload);
// };

createApp(App).mount("#app");
