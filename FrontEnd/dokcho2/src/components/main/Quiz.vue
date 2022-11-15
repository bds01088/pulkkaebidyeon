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
      <div v-if="this.quizing.quizing === true && this.nextQuiz.nextQuiz">
        퀴즈
        <div>
          문제 : {{ this.nextQuiz.nextQuiz.question }} 힌트 :
          {{ this.nextQuiz.nextQuiz.description }}
        </div>
      </div>
      <div v-else>퀴즈 안 진행중</div>

      <li v-for="msg in this.allMsg.allMsg" v-bind:key="msg">
        <p v-if="this.userSocketId.userSocketId === msg.socketId">
          내가 한 말 : {{ msg.content }}
        </p>

        <p v-else>{{ msg.nickname }}가 한 말 : {{ msg.content }}</p>
      </li>
      <!-- <li
        v-for="quiz in this.nowRoomInfo.nowRoomInfo.roomQuiz"
        v-bind:key="quiz"
      >
        {{ quiz.quiestion }}
        {{ quiz.description }}
        {{ quiz.right_answer }}
      </li> -->
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
import axios from 'axios'
import swal from 'sweetalert'
import Swal from 'sweetalert2'
import { BASE_URL } from '@/constant/BASE_URL'
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
    let quizing = ref({ quizing: false })
    let nextQuiz = ref({ nextQuiz: '' })
    const item = ref({ item: {} })

    const socket = io('http://k7e203.p.ssafy.io:3001/')

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
      // console.log(nowRoomInfo.value.nowRoomInfo)
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
      // console.log(nowRoomInfo.value.nowRoomInfo.roomQuiz)
      // nowQuizAnswer.value.nowQuizAnswer =
      //   nowRoomInfo.value.nowRoomInfo.roomQuiz[0].right_answer
      // console.log(nowQuizAnswer.value.nowQuizAnswer)
    })

    function enterRoom(data) {
      nowRoomInfo.value.nowRoomInfo.roomId = data
      socket.emit('enterRoom', nowRoomInfo.value.nowRoomInfo.roomId)
    }

    socket.on('goaway', () => {
      console.log('꺼져랑')
      swal({
        title: '풀방이네요~',
        text: ' 꺼져',
        icon: 'warning',
        buttons: false,
        timer: 1500
      })
    })

    socket.on('enterRoomOK', (payload) => {
      nowRoomInfo.value.nowRoomInfo = payload[0]
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
      QuizRoomEntered.value.QuizRoomEntered = true
    })

    function leaveRoom() {
      socket.emit('leaveRoom', nowRoomInfo.value.nowRoomInfo.roomId)
      QuizRoomEntered.value.QuizRoomEntered = false
    }

    socket.on('leaveRoomOK', (payload) => {
      nowRoomUser.value.nowRoomUser = payload[0].currentUser
    })

    socket.on('deleteMsg', () => {
      allMsg.value.allMsg = []
    })

    function sendMsg(roomId, socketId, nickname, msg) {
      let payload = [roomId, socketId, nickname, msg]
      socket.emit('msg', payload)
      inputMsg.value.inputMsg = null
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

    socket.on('nextQuiz', (data) => {
      nextQuiz.value.nextQuiz = data
      quizing.value.quizing = true
    })

    socket.on('correct', (data) => {
      for (let user of nowRoomUser.value.nowRoomUser) {
        if (user.socketId == data) {
          console.log(`${user.nickname} 가 정답을 맞췄넹`)
          allMsg.value.allMsg.push({
            socketId: '',
            nickname: 'server',
            content: `${user.nickname}가 정답을 맞췄습니다!`
          })
        }
      }
    })

    socket.on('endQuiz', (data) => {
      quizing.value.quizing = false
      for (let winner of data) {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `${winner.nickname}님이 이겼습니다!`
        })
      }
    })

    socket.on('winnerwinnerchickendinner', () => {
      axios({
        url: BASE_URL + '/api/v1/mission/mini?rewardExp=0',
        method: 'PUT',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          // console.log(res.data)
          item.value.item = res.data.itemDto
          const content = item.value.item
          console.log(item.value.item)
          Swal.fire({
            title: `🎊축하합니다🎊`,
            html: `<div style="display:flex; flex-direction: column; justify-content:center">

                  <p>퀴즈 우승 보상으로 아이템을 드립니다</p>

                  <div style="margin: 1vw">
                  <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/item/' +
                    content.itemId +
                    '.png')}"/>
                    <p style="font-size:0.9rem;">${content.itemName}</p>
                  </div>
                    
              </div>`,
            // showConfirmButton: false,
            // timer: 2500,
            background: 'rgba(255, 255, 255)'
          })
        })
        .catch((err) => console.log(err))
    })

    socket.on('fuckoff', () => {
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: 'server',
        content: `이 방은 5초뒤에 폭파됩니다.`
      })
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: 'server',
        content: `5..`
      })

      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `4..`
        })
      }, 1000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `3..`
        })
      }, 2000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `2..`
        })
      }, 3000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `1..`
        })
      }, 4000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: 'server',
          content: `폭발은 예술이다!`
        })
      }, 5000)
      setTimeout(() => {
        leaveRoom()
      }, 5500)
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
      quizing,
      nextQuiz,
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
