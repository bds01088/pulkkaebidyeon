<template>
  <div>소켓임 해위</div>
  <button @click="disconnect()">디스커넥트</button>
  <button @click="createRoom()">방생성</button>
  <input
    type="text"
    v-model="inputText.inputText"
    placeholder="방 번호 나중에는선택하게할거임"
  />
  <input
    type="text"
    v-model="inputRoomName.inputRoomName"
    placeholder="방 이름"
  />
  <button @click="enterRoom()">방참가</button>
  <button @click="leaveRoom()">방나가기</button>
  <p>{{ this.nowRoom.nowRoom }}번 방</p>
  <p>유저목록{{ this.nowRoomUser.nowRoomUser }}</p>
  <li v-for="user in this.nowRoomUser.nowRoomUser" v-bind:key="user">
    {{ user.nickname }}
  </li>
  <!-- <p>유저닉네임목록{{ this.nowRoomUserNickname.nowRoomUserNickname }}</p> -->
</template>

<script>
import { io } from 'socket.io-client'
import { ref } from 'vue'
export default {
  name: 'QuizCanvas',
  props: {
    nowPage: Number
  },
  setup() {
    let inputText = ref({ inputText: '' })
    let inputRoomName = ref({ inputRoomName: '' })
    let nowRoom = ref({ nowRoom: '' })
    let roomName
    let nowRoomUser = ref({ nowwRoomUser: '' })
    // let nowRoomUserNickname = ref({ nowRoomUserNickname: '' })

    // nowRoomUser.value.nowwRoomUser.forEach(function (value) {
    //   nowRoomUserNickname.value.nowRoomUserNickname.push(value.nickname)
    // })

    const socket = io('http://localhost:3000/')
    // console.log(socket)

    function disconnect() {
      socket.disconnect()
    }

    function emitNickname() {
      socket.emit('sendNickname', JSON.parse(localStorage.getItem('userInfo')))
    }
    emitNickname()

    function createRoom() {
      roomName = inputRoomName.value.inputRoomName
      socket.emit('createRoom', roomName)
      // console.log('방생성 버튼 누름')
    }

    socket.on('createRoomOK', (payload) => {
      console.log(payload)
      nowRoom.value.nowRoom = payload[0].roomId
      console.log(
        `방생성완료, 방 번호 : ${nowRoom.value.nowRoom}, 방 이름 : ${payload[0].roomName}`
      )
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
    })

    function enterRoom() {
      // console.log(inputText.value.inputText)
      nowRoom.value.nowRoom = inputText.value.inputText
      console.log(`${nowRoom.value.nowRoom}번 방에 참가합니다`)
      socket.emit('enterRoom', nowRoom.value.nowRoom)
    }

    socket.on('enterRoomOK', (payload) => {
      console.log(payload)
      nowRoom.value.nowRoom = payload[0].roomId
      // let enteredUser =
      // payload[0].currentUser[payload[0].currentUser.length - 1]
      // payload[1].nickname
      console.log(
        `${payload[1].nickname}가 ${nowRoom.value.nowRoom}번 방에 참가했습니다`
      )
      nowRoomUser.value.nowRoomUser = payload[0].currentUser

      console.log(nowRoomUser)
    })

    function leaveRoom() {
      socket.emit('leaveRoom', nowRoom.value.nowRoom)
      console.log(`${nowRoom.value.nowRoom}번 방에서 나갑니다`)
    }

    socket.on('leaveRoomOK', (payload) => {
      console.log(payload)
      console.log(`${payload[1].nickname}가 나갔습니다`)
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
      console.log(nowRoomUser)
    })

    return {
      inputText,
      inputRoomName,
      nowRoom,
      nowRoomUser,
      // nowRoomUserNickname,
      disconnect,
      emitNickname,
      enterRoom,
      leaveRoom,
      createRoom
    }
  }
}
</script>

<style></style>
