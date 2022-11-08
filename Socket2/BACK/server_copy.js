// import express from "express";
// import { Server } from "socket.io";
// import { createServer } from "http";

// const app = express();
// const http = createServer(app);

// const io = new Server(http, {
//   pingTimeout: 1000,
//   cors: {
//     origin: "",
//     methods: ["GET", "POST"],
//   },
// });
const express = require("express");
const http = require("http");
const cors = require("cors");

const app = express();
const server = http.createServer(app);

app.use(cors());

const io = require("socket.io")(server, {
  cors: {
    origin: "",
    methods: ["GET", "POST"],
  },
});

const players = {};

app.get("/", function (req, res) {
  res.send("Hello World");
  console.log("hello");
});

io.on("connection", (socket) => {
  console.log(`User ${socket.id} connected`);
  players[socket.id] = { id: socket.id, object: {} };

  socket.on("disconnect", (reason) => {
    console.log(`User ${socket.id} disconnected`);
    delete players[socket.id];
  });

  // Main script //
  socket.on("senddata", (data) => {
    players[socket.id].object = data;
    console.log(data);
  });
});

setInterval(() => {
  io.emit("playerdata", players);
}, 80);

server.listen(3000, () => {
  console.log("listening on *:3000");
});
