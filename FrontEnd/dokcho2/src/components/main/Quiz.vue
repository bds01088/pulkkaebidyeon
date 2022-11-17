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
              <p>
                <b>{{ userInfo.nickname }}</b
                >님, &nbsp; 퀴즈왕을 향해 가볼까요?
              </p>
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
              <button class="makeRoomBtn" @click="createRoom()">방 생성</button>
            </div>
          </div>
        </div>
        <div class="waitingRoom__right">
          <div class="roomList">
            <!-- <div class="roomList__header">
              <p>방 리스트</p>
            </div> -->

            <div
              @click="enterRoom(room.roomId)"
              v-for="room in this.rooms.rooms"
              v-bind:key="room"
              class="room"
            >
              <div class="roomLeft">
                <div class="roomPic">
                  <img
                    v-if="room.gameType === 'saja'"
                    src="@/assets/quiz/saja.png"
                    alt=""
                  />
                  <img v-else src="@/assets/quiz/chosung.png" alt="" />
                </div>
              </div>
              <div class="roomRight">
                <div class="roomRight__top">
                  <div class="roomName">
                    <p>No.{{ room.roomId }}</p>
                    <p>
                      {{ room.roomName }}
                    </p>
                  </div>
                </div>
                <div class="roomRight__bottom">
                  <div class="roomPerson">
                    🙋‍♂️ &nbsp; {{ room.currentUser.length }} / 4
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
          <div class="inGame__roomName">
            <p>
              No.{{ this.nowRoomInfo.nowRoomInfo.roomId }} &nbsp;
              {{ this.nowRoomInfo.nowRoomInfo.roomName }}
            </p>
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
            퀴즈를 시작하려면 <b>"독초는 퀴즈를 뿌려라"</b> 라고 입력하세요!
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
                placeholder="여기에 입력하세요!"
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
            <!-- <p class="players__room">
              "{{ this.nowRoomInfo.nowRoomInfo.roomName }}"
            </p> -->
            <div class="players">
              <div
                v-for="(user, i) in this.nowRoomUser.nowRoomUser"
                v-bind:key="i"
                class="player"
              >
                <img
                  class="player__img"
                  :src="require('@/assets/quiz/' + i + '.png')"
                  alt=""
                />
                <p :class="isCorrectUser(user) ? 'correctUser' : ''">
                  {{ user.nickname }}
                </p>
                <p class="player__score">{{ user.score }}</p>
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
import _ from 'lodash'

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

    let imageNumber = _.random(1, 4)
    // const images =

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
      isCorrectUser,
      imageNumber
    }
  }
}
</script>

<style scoped>
.quizComponent {
  position: fixed;
  width: 100vw;
  height: 100vh;
  background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
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
  width: 32%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  align-items: center;
  border-radius: 20px;
  background-color: #efdcc3;
}

.myProfile {
  height: 40%;
  width: 75%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
  border-radius: 10px;
  opacity: 1;
  /* background-color: white; */
}

.myProfile > img {
  width: 35%;
  height: 60%;
}

.myName {
  height: 10%;
  display: flex;
  align-items: center;
  font-size: 1.1rem;
  /* font-weight: bold; */
  /* margin: 0; */
}

.myName p {
  margin: 0;
}

.makeRoom {
  height: 55%;
  width: 75%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  /* align-items: center; */
  background-color: #e4c49b;
  border-radius: 10px;
  /* border: 1px black solid; */
  margin-bottom: 3vh;
}

.makeRoomTitle {
  height: 25%;
  display: flex;
  /* justify-content: center; */
  align-items: center;
}

.makeRoomTitle > p {
  font-size: 1.3rem;
  margin-left: 1.5vw;
  /* margin: 0 5px 0 0; */
  /* margin: 0; */
  font-weight: bold;
  /* font-family: 'DungGeunMo'; */
}

.makeRoomDetail {
  height: 40%;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  /* align-items: center; */
}

.radio {
  margin-left: 1.5vw;
}

.radio input[type='radio'] {
  display: none;
}

.radio input[type='radio'] + label {
  display: inline-block;
  cursor: url(http://localhost:8080/da0004d92b7c37a7.cur), pointer;
  height: 24px;
  width: 45%;
  border: 1px solid #333;
  line-height: 24px;
  text-align: center;
  /* font-weight: bold; */
  font-size: 0.9rem;
  /* margin-left: 1.5vw; */
}

.radio input[type='radio'] + label {
  background-color: rgba(255, 255, 255, 0.6);
  color: #000000;
}

.radio input[type='radio']:hover + label {
  scale: 1.05;
  background-color: #deb887;
  transition: 0.2s linear;
}

.radio input[type='radio']:checked + label {
  scale: 1.05;
  background-color: #ce954b;
  color: #000000;
  font-weight: bold;
}

.makeRoomDetail input {
  margin: 0;
  margin-left: 1.3vw;
  height: 2.5vw;
  width: 85%;
  font-size: 1rem;
  border-color: #d9ac73;
  background-color: #efdcc3;
}

.makeRoomDetail input:focus {
  border-color: #d9ac73;
  box-shadow: 0 0 10px 0 #d9ac73;
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
  font-size: 1rem;
  transition: 0.2s linear;
}

.makeRoomBtn:hover {
  scale: 1.05;
  background-color: #a7c957;
  transition: 0.2s linear;
}

.waitingRoom__right {
  width: 62%;
  height: 100%;
  border-radius: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: antiquewhite;
}

.roomList {
  width: 80%;
  height: 85%;
  overflow-y: auto;
  overflow-x: hidden;
}

.roomList__header {
  /* position: fixed; */
  font-size: 1.4rem;
  font-weight: bold;
  margin-left: 0.5vw;
}

.room {
  display: inline-flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 10px;
  margin: 15px 10px;
  width: 85%;
  height: 30%;
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
  /* width: 100%;
  height: 100%;
  border: 1px black solid; */
  align-items: center;
  display: flex;
  justify-content: center;
}

.roomPic img {
  width: 55%;
  margin: auto;
}

.roomRight {
  margin-left: 2vw;
  width: 70%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.roomRight__top {
  width: 90%;
  height: 40%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.roomName {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 15px;
  background-color: antiquewhite;
  padding: 0 20px;
  padding-top: 10px;
  font-size: 1rem;
  font-weight: bold;
  height: 60%;
  width: 100%;
}

.roomRight__bottom {
  width: 90%;
  height: 40%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.roomPerson {
  text-align: center;
  width: 30%;
}

.roomStartBtn {
  transition: 0.2s linear;
  border-radius: 12px;
}

.roomStartBtn:hover {
  scale: 1.05;
  background-color: #a7c957;
  transition: 0.2s linear;
  font-weight: bold;
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
  margin-top: 5vh;
  display: flex;
  justify-content: space-between;
  /* align-items: center; */
}

/* .inGame__header > div {
  text-align: center;
} */

.inGame__roomName {
  font-size: 2.5rem;
  color: white;
  margin-left: 1.5vw;
}

.inGame__quizBox {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 20px;
  margin: 15px 0;
  width: 80%;
  height: 15%;
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

.inGame__exit button {
  width: 6vw;
  height: 2.5vw;
  margin-right: 1.5vw;
  border-radius: 20px;
}

.inGame__exit button:hover {
  scale: 1.05;
  background-color: #a7c957;
  transition: 0.2s linear;
  font-weight: bold;
}

.inGame__body {
  height: 75%;
  width: 80%;
  display: flex;
  justify-content: space-between;
}

.inGame__left {
  height: 100%;
  width: 73%;
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
  width: 90%;
  overflow-y: scroll;
}

.textBox {
  width: 90%;
  display: flex;
  margin: auto;
}

.yourTextBox {
  display: flex;
  align-items: center;
}

.myTexts {
  border-radius: 15px;
  background-color: #a7c957;
  width: fit-content;
  padding: 10px 15px;
  margin: 10px;
}

.gguTexts {
  border-radius: 15px;
  background-color: #ffa6a6;
  width: fit-content;
  padding: 10px 15px;
  margin: 10px;
}

.yourTexts {
  border-radius: 15px;
  background-color: #fff78c;
  width: fit-content;
  padding: 10px 15px;
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
  height: 100%;
  margin: 0;
  font-size: 1.2rem;
}

.inputBox input:focus {
  border-color: #839d46;
  box-shadow: 0 0 8px 0 #839d46;
}

.playersBox {
  height: 80%;
  width: 25%;
  border-radius: 20px;
  background-color: #efdcc3;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

.players {
  width: 80%;
  height: 80%;
  /* display: flex;
  flex-direction: column;
  justify-content: flex-start; */
  display: grid;
  grid-template-columns: repeat(2, 1fr);
}

.player {
  width: 90%;
  font-size: 1.2rem;
  font-weight: bold;
  text-align: center;
  /* margin: 25px 0; */
  margin-top: 2vh;
  margin: auto;
  background-color: white;
  border-radius: 20px;
}

.players__room {
  text-align: center;
  font-size: 1.3rem;
  font-weight: bold;
}
.player__img {
  width: 50%;
  margin-top: 1vh;
  margin-bottom: 1vh;
}

.player__score {
  font-size: 1rem;
  /* margin: 1vh; */
}

.correctUser {
  color: red;
}
</style>
