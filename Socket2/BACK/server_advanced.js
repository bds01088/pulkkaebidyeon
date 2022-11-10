var app = require("express")();
var http = require("http").Server(app);
var io = require("socket.io")(http);

app.get("/", (req, res) => {
  res.sendFile(__dirname + `\\index_advanced.html`);
});

http.listen(3000, () => {
  console.log("listening on *:3000");
});

var roomList = ["room1", "room2"];
var userList = new Array(2);
for (let i = 0; i < userList.length; i++) {
  userList[i] = new Array();
}

io.on("connection", function (socket) {
  var nowRoom;
  var joinedUser = false;
  var nickname;

  socket.on("join", function (num, name) {
    if (joinedUser) {
      return false;
    }
    nowRoom = num;
    nickname = name;
    userList[num].push(nickname);

    socket.join(roomList[num]);
    io.to(roomList[num]).emit("join", {
      nickname: nickname,
      userList: userList[num],
    });

    socket.emit("welcome", {
      nickname: nickname,
      userList: userList[num],
    });
    joinedUser = true;
  });

  socket.on("msg", function (num, msg) {
    io.to(roomList[num]).emit("msg", {
      nickname: nickname,
      msg: msg,
    });
  });

  socket.on("disconnect", function () {
    if (!joinedUser) {
      console.log("not joinned user left");
      return false;
    }

    var i = userList[nowRoom].indexOf(nickname);
    userList[nowRoom].splice(i, 1);

    socket.leave(roomList[nowRoom]);
    io.to(roomList[nowRoom]).emit("left", {
      nickname: nickname,
      userList: userList[nowRoom],
    });
  });
});
