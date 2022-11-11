const express = require("express");
const http = require("http");
const cors = require("cors");
const axios = require("axios");

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

let quizs = [];

server.listen(3000, () => {
  console.log("Listening at port 3000...");
});

axios({
  url: BASE_URL + "/api/v1/game/words/auth/10",
  method: "GET",
})
  .then((res) => {
    quizs = res.data;
    // console.log(res.data);
    // console.log(quizs);
  })
  .catch((err) => {
    console.log(err);
  });

let players = {};
let roomNum = 0;
let rooms = [];

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
  });

  socket.on("createRoom", (data) => {
    // console.log("서버 방생성 요청");
    socket.join(`${roomNum}`);
    rooms.push({ roomId: roomNum, roomName: data, currentUser: [] });
    let roomInfo = rooms.find((room) => room.roomId == roomNum);
    roomInfo.currentUser.push({
      socketID: socket.id,
      nickname: players[socket.id].object.nickname,
    });
    let payload = [roomInfo, players[socket.id].object];
    socket.emit("createRoomOK", payload);
    // console.log(roomInfo);

    roomNum += 1;
  });

  socket.on("enterRoom", (data) => {
    socket.join(data);
    console.log(data);
    let roomInfo = rooms.find((room) => room.roomId == data);
    roomInfo.currentUser.push({
      socketID: socket.id,
      nickname: players[socket.id].object.nickname,
    });
    let payload = [roomInfo, players[socket.id].object];
    io.to(`${data}`).emit("enterRoomOK", payload);
    console.log(payload);
  });

  socket.on("leaveRoom", (nowRoom) => {
    socket.leave(`${nowRoom}`);

    let roomInfo = rooms.find((room) => room.roomId == nowRoom);
    // let i = roomInfo.currentUser.indexOf(socket.id);
    // roomInfo.currentUser.splice(i, 1);
    currentUser = currentUser.filter(
      (user) => user.socketID !== players[socket.id]
    );
    let payload = [roomInfo, players[socket.id].object];

    if (roomInfo.currentUser.length > 0) {
      console.log(`${nowRoom}에 사람있어요`);
      io.to(`${nowRoom}`).emit("leaveRoomOK", payload);
    } else {
      //   let i = rooms.indexOf(
      //     rooms.find((room) => {
      //       room.roomId == data;
      //     })
      //   );
      //   rooms.splice(i, 1);

      rooms = rooms.filter((room) => room.roomId !== roomInfo.roomId);
    }

    console.log(`${nowRoom}에서 나갔지롱`);
    console.log(roomInfo);
    console.log(rooms);
  });
});
