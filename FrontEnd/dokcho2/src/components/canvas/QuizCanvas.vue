<template>
  <div>
    <div v-if="this.QuizRoomEntered.QuizRoomEntered === false">
      <button @click="disconnect()">디스커넥트</button>
      <button @click="createRoom()">방생성</button>
      <input
        type="text"
        v-model="inputRoomName.inputRoomName"
        placeholder="방 이름"
      />
      <div>
        <li
          @click="enterRoom(room.roomId)"
          v-for="room in this.rooms.rooms"
          v-bind:key="room"
        >
          {{ room.roomName }}
        </li>
      </div>

      <!-- <p>유저닉네임목록{{ this.nowRoomUserNickname.nowRoomUserNickname }}</p> -->
    </div>
    <div v-else>
      <button @click="leaveRoom()">방나가기</button>
      <p>{{ this.nowRoomInfo.nowRoomInfo.roomId }}번 방</p>
      <p>방제 : {{ this.nowRoomInfo.nowRoomInfo.roomName }}</p>
      <li v-for="user in this.nowRoomUser.nowRoomUser" v-bind:key="user">
        {{ user.nickname }}
      </li>
      <li v-for="msg in this.allMsg.allMsg" v-bind:key="msg">
        <p v-if="this.userSocketId.userSocketId === msg.socketId">
          내가 한 말 : {{ msg.content }}
        </p>

        <p v-else>
          {{ msg.nickname }}{{ msg.socketId }}가 한 말 : {{ msg.content }}
        </p>
      </li>
      <input
        type="text"
        v-model="inputMsg.inputMsg"
        placeholder="메세지"
        @keyup.enter="
          sendMsg(
            this.nowRoomInfo.nowRoomInfo.roomId,
            this.userSocketId.userSocketId,
            this.userNickName.userNickName,
            this.inputMsg.inputMsg
          )
        "
      />
    </div>
  </div>
</template>

<script>
import { io } from 'socket.io-client'
import { ref } from 'vue'
// import QuizRoomCanvas from './QuizRoomCanvas.vue'

export default {
  name: 'QuizCanvas',
  props: {
    nowPage: Number
  },
  setup() {
    let inputRoomName = ref({ inputRoomName: '' })
    let nowRoomInfo = ref({ nowRoomInfo: [] })
    let roomName = ref({ roomName: '' })
    let nowRoomUser = ref({ nowRoomUser: '' })
    let QuizRoomEntered = ref({ QuizRoomEntered: false })
    let rooms = ref({ rooms: '' })
    let userNickName = ref({ userNickName: '' })
    let inputMsg = ref({ inputMsg: '' })
    let msgNickname = ref({ msgNickname: '' })
    let msgContent = ref({ msgContent: '' })
    let allMsg = ref({ allMsg: [] })
    let userSocketId = ref({ userSocketId: '' })
    let msgSocketId = ref({ msgSocketId: '' })

    const socket = io('http://localhost:3000/')

    function disconnect() {
      socket.disconnect()
    }

    socket.emit('sendNickname', JSON.parse(localStorage.getItem('userInfo')))

    userNickName.value.userNickName = JSON.parse(
      localStorage.getItem('userInfo')
    ).nickname

    socket.on('sendSocketId', (data) => {
      userSocketId.value.userSocketId = data
    })

    socket.on('sendRooms', (data) => {
      rooms.value.rooms = data
    })

    function createRoom() {
      roomName.value.roomName = inputRoomName.value.inputRoomName
      socket.emit('createRoom', roomName.value.roomName)
      QuizRoomEntered.value.QuizRoomEntered = true
    }

    socket.on('createRoomOK', (payload) => {
      nowRoomInfo.value.nowRoomInfo = payload[0]
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
    })

    function enterRoom(data) {
      nowRoomInfo.value.nowRoomInfo.roomId = data
      socket.emit('enterRoom', nowRoomInfo.value.nowRoomInfo.roomId)
      QuizRoomEntered.value.QuizRoomEntered = true
    }

    socket.on('enterRoomOK', (payload) => {
      nowRoomInfo.value.nowRoomInfo = payload[0]
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
    })

    function leaveRoom() {
      socket.emit('leaveRoom', nowRoomInfo.value.nowRoomInfo.roomId)
      QuizRoomEntered.value.QuizRoomEntered = false
    }

    socket.on('leaveRoomOK', (payload) => {
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
    })

    function sendMsg(roomId, socketId, nickname, msg) {
      let payload = [roomId, socketId, nickname, msg]
      socket.emit('msg', payload)
    }

    socket.on('msg', (msgpayload) => {
      console.log('메세지 왔당')
      // msgSocketId.value.msgSocketId = msgpayload[1]
      msgNickname.value.msgNickname = msgpayload[2]
      msgContent.value.msgContent = msgpayload[3]
      allMsg.value.allMsg.push({
        socketId: msgpayload[1],
        nickname: msgNickname.value.msgNickname,
        content: msgContent.value.msgContent
      })
      // console.log(allMsg.value.allMsg)
    })

    return {
      inputRoomName,
      roomName,
      nowRoomInfo,
      nowRoomUser,
      QuizRoomEntered,
      rooms,
      inputMsg,
      userNickName,
      msgNickname,
      msgContent,
      allMsg,
      userSocketId,
      msgSocketId,
      disconnect,
      enterRoom,
      leaveRoom,
      createRoom,
      sendMsg
    }
  }
}
</script>

<style></style>
