<template>
  <div class="quizComponent">
    <div
      v-if="this.QuizRoomEntered.QuizRoomEntered === false"
      class="waitingRoom"
    >
      <div class="title">Quiz!</div>
      <div class="makeRoom">
        <p>방 만들기</p>
        <input
          type="text"
          v-model="inputRoomName.inputRoomName"
          placeholder="방 이름"
        />
        <input
          type="radio"
          v-model="inputGameType.inputGameType"
          value="saja"
        />
        <input
          type="radio"
          v-model="inputGameType.inputGameType"
          value="chosung"
        />
        <div>{{ inputGameType.inputGameType }}</div>
        <div>
          <button @click="createRoom()">방생성</button>
        </div>

        <!-- <p>유저닉네임목록{{ this.nowRoomUserNickname.nowRoomUserNickname }}</p> -->
      </div>
      <div class="roomList">
        <div
          @click="enterRoom(room.roomId)"
          v-for="room in this.rooms.rooms"
          v-bind:key="room"
          class="room"
        >
          <div class="roomNum">
            {{ room.roomId }}
          </div>
          <div class="roomName">
            {{ room.roomName }}
          </div>
          <div class="roomPerson">{{ room.currentUser.length }} / 4</div>
        </div>
      </div>
      <img
        class="exit__btn"
        @click="closeQuiz()"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>

    <div v-else>
      <div class="inGame">
        <div class="inGame__header">
          <div class="inGame__roomNum">
            <p>{{ this.nowRoomInfo.nowRoomInfo.roomId }}번 방</p>
          </div>
          <div class="inGame__roomName">
            <p>{{ this.nowRoomInfo.nowRoomInfo.roomName }}</p>
          </div>
          <div class="inGame__exit">
            <button @click="leaveRoom()">방나가기</button>
          </div>
        </div>
        <div class="inGame__quizBox">
          <div v-if="this.quizing.quizing === true && this.nextQuiz.nextQuiz">
            <div>문제 : {{ this.nextQuiz.nextQuiz.question }}</div>
            <div>
              힌트 :
              {{ this.nextQuiz.nextQuiz.description }}
            </div>
          </div>
          <div v-else>
            퀴즈를 시작하려면 독초는 퀴즈를 뿌려라 라고 입력하세요!
          </div>
        </div>
        <div class="inGame__body">
          <div class="chatting">
            <div class="chatBox">
              <div v-for="msg in this.allMsg.allMsg" :key="msg" class="texts">
                <div
                  class="myText"
                  v-if="this.userSocketId.userSocketId === msg.socketId"
                >
                  {{ msg.content }}
                </div>
                <div class="yourText" v-else>
                  {{ msg.nickname }} : {{ msg.content }}
                </div>
              </div>
            </div>
            <div class="inputBox">
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
          <div class="playersBox">
            <div class="correctPlayer">
              <div class="player">
                {{ this.correctUser.correctUser }}
              </div>
            </div>
            <div class="players">
              <div
                v-for="user in this.nowRoomUser.nowRoomUser"
                v-bind:key="user"
                class="player"
              >
                {{ user.nickname }} :
                {{ user.score }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- <li
        v-for="quiz in this.nowRoomInfo.nowRoomInfo.roomQuiz"
        v-bind:key="quiz"
      >
        {{ quiz.quiestion }}
        {{ quiz.description }}
        {{ quiz.right_answer }}
      </li> -->
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
  setup(props, { emit }) {
    let inputRoomName = ref({ inputRoomName: '' })
    let inputGameType = ref({ inputGameType: '' })
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
    let correctUser = ref({ correctUser: '정답자' })

    // const socket = io('https://k7e203.p.ssafy.io/')
    const socket = io('http://localhost:3001/')

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
      let payload = [roomName.value.roomName, inputGameType.value.inputGameType]
      socket.emit('createRoom', payload)
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
      correctUser.value.correctUser = '정답자'
      nextQuiz.value.nextQuiz = ''
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

    socket.on('startQuiz', (data) => {
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `퀴즈가 5초뒤에 시작된다.`
      })
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `5..`
      })

      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `4..`
        })
      }, 1000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `3..`
        })
      }, 2000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `2..`
        })
      }, 3000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `1..`
        })
      }, 4000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `퀴즈시작!`
        })
        quizing.value.quizing = true
        nextQuiz.value.nextQuiz = data
      }, 5000)
    })

    socket.on('nextQuiz', (data) => {
      nextQuiz.value.nextQuiz = data
    })

    socket.on('correct', (payload) => {
      nowRoomUser.value.nowRoomUser = payload[1]
      for (let user of nowRoomUser.value.nowRoomUser) {
        if (user.socketId == payload[0]) {
          correctUser.value.correctUser = user.nickname
          allMsg.value.allMsg.push({
            socketId: '',
            nickname: '김구현(교수)',
            content: `${user.nickname}가 정답을 맞히었구나!`
          })
        }
      }
    })

    socket.on('endQuiz', (data) => {
      quizing.value.quizing = false
      for (let winner of data) {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `${winner.nickname}가 이겼노라!`
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
        nickname: '김구현(교수)',
        content: `이 방은 5초뒤에 폭파된다.`
      })
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `5..`
      })

      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `4..`
        })
      }, 1000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `3..`
        })
      }, 2000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `2..`
        })
      }, 3000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `1..`
        })
      }, 4000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `폭발은 예술이다!`
        })
      }, 5000)
      setTimeout(() => {
        leaveRoom()
      }, 5500)
    })

    function closeQuiz() {
      disconnect()
      emit('closeQuiz')
    }

    return {
      inputRoomName,
      inputGameType,
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
      correctUser,
      disconnect,
      enterRoom,
      leaveRoom,
      createRoom,
      sendMsg,
      closeQuiz
    }
  }
}
</script>

<style scoped>
.quizComponent {
  position: fixed;
  width: 100vw;
  height: 100vh;
  background-color: white;
}

.waitingRoom {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.title {
  width: 100%;
  height: 10%;
  text-align: center;
  font-size: 60px;
}

.makeRoom {
  width: 100%;
  height: 10%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.makeRoom > p {
  margin: 0 5px 0 0;
}

input {
  margin: 0;
  height: 35px;
}

.roomList {
  width: 80vw;
  height: 60%;
  border-radius: 20px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  overflow-y: auto;
  overflow-x: hidden;
  background-color: antiquewhite;
  padding: 15px;
}

.room {
  display: inline-flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 20px;
  margin: 15px 10vw;
  width: 60vw;
  height: 15%;
  background-color: burlywood;
}

.room > div {
  font-size: 20px;
}

.roomNum {
  text-align: center;
  width: 15%;
}

.roomName {
  width: 60%;
}

.roomPerson {
  text-align: center;
  width: 15%;
}

.exit__btn {
  width: 4vw;
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 4vh;
  right: 4vw;
  cursor: url('@/assets/selector.cur'), pointer;
}

.inGame {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.inGame__header {
  width: 80%;
  height: 10%;
  margin: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.inGame__header > div {
  text-align: center;
}

.inGame__roomName {
  font-size: 35px;
}

.inGame__quizBox {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 20px;
  margin: 15px 0;
  width: 80%;
  height: 10%;
  background-color: burlywood;
}

.inGame__quizBox > div {
  font-size: 20px;
  text-align: center;
  margin: 7px 0;
}

.inGame__body {
  width: 100%;
  height: 80%;
}

.inGame__roomNum {
  width: 20%;
}

.inGame__roomName {
  width: 60%;
}

.inGame__exit {
  width: 20%;
}

.inGame__body {
  height: 75%;
  width: 80%;
  display: flex;
  justify-content: space-evenly;
  align-items: center;
}

.chatting {
  height: 100%;
  width: 60%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.chatBox {
  height: 75%;
  width: 100%;
  border-radius: 20px;
  padding: 30px;
  background-color: antiquewhite;
  overflow: auto;
}

.texts > div {
  margin: 5px 0;
  font-size: 20px;
}

.myText {
  text-align: end;
}
.yourText {
  text-align: start;
}

.inputBox {
  width: 100%;
  height: 10%;
  display: flex;
  justify-content: center;
}

.inputBox > input {
  width: 80%;
}

.playersBox {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.correctPlayer {
  height: 60%;
  width: 80%;
  border-radius: 20px;
  padding: 20px;
  margin-bottom: 20px;
  background-color: antiquewhite;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.players {
  height: 60%;
  width: 80%;
  border-radius: 20px;
  padding: 20px;
  background-color: antiquewhite;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.player {
  width: 100%;
  font-size: 25px;
  text-align: center;
  margin: 20px 0;
}
</style>
