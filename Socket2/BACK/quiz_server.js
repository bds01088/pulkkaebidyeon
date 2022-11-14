const express = require("express");
const http = require("http");
const cors = require("cors");
const axios = require("axios");
const _ = require("lodash");

const app = express();
const server = http.createServer(app);
const BASE_URL = "https://k7e203.p.ssafy.io";

app.use(cors());

const io = require("socket.io")(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

server.listen(3000, () => {
  console.log("Listening at port 3000...");
});

let quizs = [];
let players = {};
let roomNum = 0;
let rooms = [];

axios({
  url: BASE_URL + "/api/v1/game/words/auth/10",
  method: "GET",
})
  .then((res) => {
    quizs = res.data;
  })
  .catch((err) => {
    console.log(err);
  });

io.on("connection", (socket) => {
  console.log(`User ${socket.id} connected`);
  players[socket.id] = { id: socket.id, object: {} };

  socket.on("disconnect", (reason) => {
    console.log(`User ${socket.id} disconnected`);
    delete players[socket.id];
  });

  socket.on("sendNickname", (userInfo) => {
    players[socket.id].object = userInfo;
    console.log(
      `${socket.id}, ${
        players[socket.id].object.nickname
      }님이 퀴즈에 입장했습니다`
    );
    socket.emit("sendSocketId", socket.id);
  });

  setInterval(() => {
    socket.emit("sendRooms", rooms);
    // console.log(rooms);
  }, 3000);

  socket.on("createRoom", (data) => {
    socket.join(`${roomNum}`);
    rooms.push({
      roomId: roomNum,
      roomName: data,
      currentUser: [],
      roomQuiz: [],
      nowQuizNumber: 0,
    });
    let roomInfo = rooms.find((room) => room.roomId == roomNum);
    roomInfo.currentUser.push({
      socketId: socket.id,
      nickname: players[socket.id].object.nickname,
    });
    roomInfo.roomQuiz = _.sampleSize(quizs, 5);
    // console.log(roomInfo.roomQuiz);
    let payload = [roomInfo, players[socket.id].object];
    io.to(`${roomNum}`).emit("createRoomOK", payload);
    roomNum += 1;
  });

  socket.on("enterRoom", (data) => {
    socket.join(`${data}`);
    let roomInfo = rooms.find((room) => room.roomId == data);
    roomInfo.currentUser.push({
      socketId: socket.id,
      nickname: players[socket.id].object.nickname,
    });
    let payload = [roomInfo, players[socket.id].object];
    io.to(`${data}`).emit("enterRoomOK", payload);
    for (user of roomInfo.currentUser) {
      io.to(`${user.socketId}`).emit("enterRoomOK", payload);
    }
  });

  socket.on("leaveRoom", (nowRoom) => {
    socket.leave(`${nowRoom}`);
    let roomInfo = rooms.find((room) => room.roomId == nowRoom);
    roomInfo.currentUser = roomInfo.currentUser.filter(
      (user) => user.socketId !== socket.id
    );
    let payload = [roomInfo, players[socket.id].object];

    if (roomInfo.currentUser.length > 0) {
      for (user of roomInfo.currentUser) {
        io.to(`${user.socketId}`).emit("leaveRoomOK", payload);
      }
    } else {
      rooms = rooms.filter((room) => room.roomId !== roomInfo.roomId);
    }
  });

  socket.on("msg", (data) => {
    console.log(data);
    let roomInfo = rooms.find((room) => room.roomId == data[0]);
    for (user of roomInfo.currentUser) {
      io.to(`${user.socketId}`).emit("msg", data);
    }
    console.log(`정답 전달 됨`);
    console.log(roomInfo.roomQuiz[roomInfo.nowQuizNumber]);
    if (data[3] === roomInfo.roomQuiz[roomInfo.nowQuizNumber].right_answer) {
      console.log("정답 검사함");
      io.to(`${roomInfo.roomId}`).emit("correct", socket.id);
      rooms.find((room) => room.roomId == data[0]).nowQuizNumber += 1;
      console.log(roomInfo.roomQuiz[roomInfo.nowQuizNumber]);
    }
  });
});
