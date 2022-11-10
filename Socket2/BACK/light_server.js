const express = require("express");
const http = require("http");
const cors = require("cors");

const app = express();
const server = http.createServer(app);

app.use(cors());

const io = require("socket.io")(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

let position = {
  x: 200,
  y: 200,
};

const players = {};

io.on("connection", (socket) => {
  console.log(`User ${socket.id} connected`);
  players[socket.id] = { id: socket.id, object: {} };

  socket.on("disconnect", (reason) => {
    console.log(`User ${socket.id} disconnected`);
    delete players[socket.id];
  });

  //   socket.emit("position", position);
  //   socket.on("move", (direction) => {
  //     switch (direction) {
  //       case "left":
  //         position.x -= 5;
  //         io.emit("position", position);
  //         break;
  //       case "right":
  //         position.x += 5;
  //         io.emit("position", position);
  //         break;
  //       case "up":
  //         position.y -= 5;
  //         io.emit("position", position);
  //         break;
  //       case "down":
  //         position.y += 5;
  //         io.emit("position", position);
  //         break;
  //     }
  //   });
  socket.on("senddata", (data) => {
    players[socket.id].object = data;
    console.log(socket.id, data);
  });
});

setInterval(() => {
  io.emit("playerdata", players);
}, 80);

server.listen(3000, () => {
  console.log("Listening at port 3000...");
});
