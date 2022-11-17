<template>
  <div class="quizComponent">
    <div
      v-if="this.QuizRoomEntered.QuizRoomEntered === false"
      class="waitingRoom"
    >
      <div class="waitingRoom__body">
        <div class="waitingRoom__left">
          <div class="myProfile">
            <img
              :src="
                require('@/assets/starting/' +
                  userInfo.representMonster +
                  '.png')
              "
              alt=""
            />
            <div class="myName">
              {{ userInfo.nickname }}
            </div>
          </div>
          <div class="makeRoom">
            <div class="makeRoomTitle">
              <p>방 만들기</p>
            </div>
            <div class="makeRoomDetail">
              <div class="radio">
                <input
                  type="radio"
                  v-model="inputGameType.inputGameType"
                  value="saja"
                  id="saja"
                  checked="true"
                />
                <label for="saja">사자성어</label>
                <input
                  type="radio"
                  v-model="inputGameType.inputGameType"
                  value="chosung"
                  id="chosung"
                />
                <label for="chosung">초성퀴즈</label>
              </div>
              <input
                type="text"
                v-model="inputRoomName.inputRoomName"
                placeholder="방 이름"
              />
            </div>
            <div class="makeRoomBtnBox">
              <button class="makeRoomBtn" @click="createRoom()">방생성</button>
            </div>
          </div>
        </div>
        <div class="waitingRoom__right">
          <div class="roomList">
            <div
              @click="enterRoom(room.roomId)"
              v-for="room in this.rooms.rooms"
              v-bind:key="room"
              class="room"
            >
              <div class="roomLeft">
                <div class="roomPic"></div>
              </div>
              <div class="roomRight">
                <div class="roomRight__top">
                  <div class="roomName">
                    {{ room.roomName }}
                  </div>
                </div>
                <div class="roomRight__bottom">
                  <div class="roomPerson">
                    {{ room.currentUser.length }} / 4
                  </div>
                  <button class="roomStartBtn">참여</button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <img
          class="exit__btn"
          @click="closeQuiz()"
          src="@/assets/navbar/ExitButton.png"
          alt=""
        />
      </div>
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
          <div class="inGame__left">
            <div class="chatting">
              <div class="chatBox">
                <div
                  class="textBox"
                  :class="
                    this.userSocketId.userSocketId === msg.socketId
                      ? 'myText'
                      : 'yourText'
                  "
                  v-for="msg in this.allMsg.allMsg"
                  :key="msg"
                >
                  <div v-if="this.userSocketId.userSocketId === msg.socketId">
                    <div class="myTexts">
                      {{ msg.content }}
                    </div>
                  </div>
                  <div v-else-if="msg.socketId === ''" class="yourTextBox">
                    {{ msg.nickname }} :
                    <div class="gguTexts">
                      {{ msg.content }}
                    </div>
                  </div>
                  <div v-else class="yourTextBox">
                    {{ msg.nickname }} :
                    <div class="yourTexts">
                      {{ msg.content }}
                    </div>
                  </div>
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
            <div class="players">
              <div
                v-for="user in this.nowRoomUser.nowRoomUser"
                v-bind:key="user"
                class="player"
                :class="isCorrectUser(user) ? 'correctUser' : ''"
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
    let inputGameType = ref({ inputGameType: 'saja' })
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

    let userInfo = JSON.parse(localStorage.getItem('userInfo'))
    const socket = io('https://k7e203.p.ssafy.io/')
    // const socket = io('http://localhost:3001/')

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
      if (inputRoomName.value.inputRoomName) {
        roomName.value.roomName = inputRoomName.value.inputRoomName
        console.log('보냈다', inputGameType.value.inputGameType)
        let payload = [
          roomName.value.roomName,
          inputGameType.value.inputGameType
        ]
        socket.emit('createRoom', payload)
        QuizRoomEntered.value.QuizRoomEntered = true
        inputRoomName.value.inputRoomName = ''
        inputGameType.value.inputGameType = 'saja'
      } else {
        alert('방제목 입력해라 좋은말할때')
      }
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
      inputRoomName.value.inputRoomName = ''
      inputGameType.value.inputGameType = 'saja'
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

    function goToScrollBottom() {
      const chattingBox = document.getElementsByClassName('chatBox')
      setTimeout(() => {
        if (chattingBox) {
          chattingBox[0].scrollTop =
            chattingBox[0].scrollHeight - chattingBox[0].clientHeight
        }
      }, 100)
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
      goToScrollBottom()
      // console.log(allMsg.value.allMsg)
    })

    socket.on('startQuiz', (data) => {
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `퀴즈가 5초뒤에 시작된다.`
      })
      goToScrollBottom()
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `5..`
      })
      goToScrollBottom()
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `4..`
        })
        goToScrollBottom()
      }, 1000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `3..`
        })
        goToScrollBottom()
      }, 2000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `2..`
        })
        goToScrollBottom()
      }, 3000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `1..`
        })
        goToScrollBottom()
      }, 4000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `퀴즈시작!`
        })
        goToScrollBottom()
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
            content: `${user.nickname}(이)가 정답을 맞히었구나!`
          })
          goToScrollBottom()
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
        goToScrollBottom()
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
      goToScrollBottom()
      allMsg.value.allMsg.push({
        socketId: '',
        nickname: '김구현(교수)',
        content: `5..`
      })
      goToScrollBottom()
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `4..`
        })
        goToScrollBottom()
      }, 1000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `3..`
        })
        goToScrollBottom()
      }, 2000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `2..`
        })
        goToScrollBottom()
      }, 3000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `1..`
        })
        goToScrollBottom()
      }, 4000)
      setTimeout(() => {
        allMsg.value.allMsg.push({
          socketId: '',
          nickname: '김구현(교수)',
          content: `폭발은 예술이다!`
        })
        goToScrollBottom()
      }, 5000)
      setTimeout(() => {
        leaveRoom()
      }, 5500)
    })

    function closeQuiz() {
      disconnect()
      emit('closeQuiz')
    }

    function isCorrectUser(user) {
      if (correctUser.value.correctUser === user.nickname) return true
      setTimeout(() => {
        correctUser.value.correctUser = ''
      }, 2000)
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
      userInfo,
      disconnect,
      enterRoom,
      leaveRoom,
      createRoom,
      sendMsg,
      closeQuiz,
      isCorrectUser
    }
  }
}
</script>

<style scoped>
.quizComponent {
  position: fixed;
  width: 100vw;
  height: 100vh;
  background-image: linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2)),
    url('../../assets/seodang.png');
  background-size: cover;
  background-repeat: no-repeat;
}

.waitingRoom {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.waitingRoom__body {
  margin-top: 10vh;
  width: 80vw;
  height: 75vh;
  display: flex;
  justify-content: space-around;
}

.waitingRoom__left {
  width: 35%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  align-items: center;
  border-radius: 20px;
  background-color: rgba(206, 212, 218, 0.9);
}

.myProfile {
  height: 40%;
  width: 80%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
  border-radius: 15px;
  opacity: 1;
  background-color: white;
}

.myProfile > img {
  width: 50%;
  height: 60%;
}

.myName {
  height: 20%;
  display: flex;
  align-items: center;
  font-size: 25px;
  font-weight: bold;
}

.makeRoom {
  height: 40%;
  width: 80%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border: 1px black solid;
}

.makeRoomTitle {
  height: 30%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.makeRoomTitle > p {
  font-size: 25px;
  margin: 0 5px 0 0;
  font-weight: bold;
}

.makeRoomDetail {
  height: 40%;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
}

.radio input[type='radio'] {
  display: none;
}

.radio input[type='radio'] + label {
  display: inline-block;
  cursor: url(http://localhost:8080/da0004d92b7c37a7.cur), pointer;
  height: 24px;
  width: 90px;
  border: 1px solid #333;
  line-height: 24px;
  text-align: center;
  font-weight: bold;
  font-size: 13px;
}

.radio input[type='radio'] + label {
  background-color: #fff;
  color: #333;
}

.radio input[type='radio']:hover + label {
  scale: 1.05;
  background-color: rgb(167, 167, 167);
  transition: 0.2s linear;
}

.radio input[type='radio']:checked + label {
  scale: 1.05;
  background-color: #333;
  color: #fff;
}

input {
  margin: 0;
  height: 35px;
  width: 80%;
}

.makeRoomBtnBox {
  height: 30%;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.makeRoomBtn {
  width: 60%;
  height: 50%;
  font-size: 18px;
  transition: 0.2s linear;
}

.makeRoomBtn:hover {
  scale: 1.05;
  background-color: #a7c957;
  transition: 0.2s linear;
}

.waitingRoom__right {
  width: 55%;
  height: 100%;
  border-radius: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: antiquewhite;
}

.roomList {
  width: 70%;
  height: 90%;
  overflow-y: auto;
  overflow-x: hidden;
}

.room {
  display: inline-flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 20px;
  margin: 15px 10px;
  width: 95%;
  height: 25%;
  background-color: burlywood;
}

.roomLeft {
  width: 35%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.roomPic {
  width: 70%;
  height: 70%;
  border: 1px black solid;
}

.roomRight {
  width: 65%;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.roomRight__top {
  width: 80%;
  height: 60%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.roomName {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  border-radius: 15px;
  background-color: gainsboro;
  padding: 0 15px;
  font-size: 20px;
  font-weight: bold;
  height: 50%;
  width: 100%;
}

.roomRight__bottom {
  width: 80%;
  height: 40%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.roomPerson {
  text-align: center;
  width: 15%;
}

.roomStartBtn {
  transition: 0.2s linear;
}

.roomStartBtn:hover {
  scale: 1.05;
  background-color: #a7c957;
  transition: 0.2s linear;
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
  font-size: 50px;
  color: white;
}

.inGame__quizBox {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 20px;
  margin: 15px 0;
  width: 80%;
  height: 20%;
  background-color: burlywood;
}

.inGame__quizBox > div {
  letter-spacing: 0.3px;
  font-size: 20px;
  text-align: center;
  margin: 7px 0;
}

.inGame__body {
  width: 80%;
  height: 70%;
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
  justify-content: space-between;
}

.inGame__left {
  height: 100%;
  width: 72%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.chatting {
  height: 80%;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 20px;
  background-color: antiquewhite;
}

.chatBox {
  height: 45vh;
  width: 80%;
  overflow-y: scroll;
}

.textBox {
  width: 100%;
  display: flex;
}

.yourTextBox {
  display: flex;
  align-items: center;
}

.myTexts {
  border-radius: 5px;
  background-color: #a7c957;
  width: fit-content;
  padding: 5px 15px;
  margin: 10px;
}

.gguTexts {
  border-radius: 5px;
  background-color: #ffa6a6;
  width: fit-content;
  padding: 5px 10px;
  margin: 10px;
}

.yourTexts {
  border-radius: 5px;
  background-color: #fff78c;
  width: fit-content;
  padding: 5px 10px;
  margin: 10px;
}

/* .texts > div {
  font-size: 20px;
  letter-spacing: 0.3px;
  width: fit-content;
} */

.myText {
  justify-content: flex-end;
}
.yourText {
  justify-content: flex-start;
}

.inputBox {
  width: 100%;
  height: 10%;
  margin: 15px;
  display: flex;
  justify-content: center;
}

.inputBox > input {
  width: 80%;
}

.playersBox {
  height: 80%;
  width: 25%;
  border-radius: 20px;
  background-color: antiquewhite;
  display: flex;
  justify-content: center;
  align-items: center;
}

.players {
  width: 80%;
  height: 80%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.player {
  width: 100%;
  font-size: 25px;
  text-align: center;
  margin: 25px 0;
}

.correctUser {
  color: red;
}
</style>
