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
  <button @click="roomjoin()">방참가</button>
  <button @click="leaveRoom()">방나가기</button>
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
    let nowRoom
    let roomName
    const socket = io('http://localhost:3000/')
    // console.log(socket)

    function disconnect() {
      socket.disconnect()
    }

    function emitNickname() {
      socket.emit('senddata', JSON.parse(localStorage.getItem('userInfo')))
    }
    emitNickname()

    function createRoom() {
      roomName = inputRoomName.value.inputRoomName
      socket.emit('createRoom', roomName)
      console.log('방생성 버튼 누름')
    }

    function roomjoin() {
      console.log(inputText.value.inputText)
      nowRoom = inputText.value.inputText
      console.log('방참가')
      socket.emit('enterRoom', nowRoom)
    }

    function leaveRoom() {
      socket.emit('leaveRoom', nowRoom)
      console.log('방에서 나갑니다')
    }

    socket.on('createRoomOK', (data) => {
      console.log(data)
      nowRoom = data.roomId
      console.log('방생성완료응답')
    })

    socket.on('joinRoomOK', (data) => {
      console.log(data)
      nowRoom = data.roomId
      console.log('방참가완료응답')
    })

    socket.on('entermsg', (data) => {
      console.log('방참가완료')
      console.log(data)
    })
    return {
      inputText,
      inputRoomName,
      disconnect,
      emitNickname,
      roomjoin,
      leaveRoom,
      createRoom
    }
  }
}
</script>

<style></style>
