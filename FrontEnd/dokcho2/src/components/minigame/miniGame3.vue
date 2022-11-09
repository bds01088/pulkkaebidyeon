<template>
  <div class="miniGame__container">
    <div class="miniGame">
      <!-- 해당 게임에 대한 설명 -->
      <div v-if="!game.game" class="game__description">
        <img class="game__img" src="@/assets/minigame/3.png" alt="" />
        <div class="game__text">
          <p>
            설명 ~~~~ 설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~ 설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명
            ~~~~설명 ~~~~설명 ~~~~설명 ~~~~설명 ~~~~
          </p>
        </div>

        <div class="game__item">
          <h3 class="reward__header">✨보상✨</h3>
          <div class="game__reward">
            <p class="reward__text"><b>🌞 경험치</b> : 15 포인트</p>
            <p class="reward__text">
              <b>🎁 아이템</b> : 배틀 아이템 중 1개 랜덤
            </p>
          </div>
        </div>
        <button class="start__btn" @click="changeGame()">게 임 시 작</button>
      </div>

      <!-- 보상 받는 창 -->

      <div v-else-if="chosung.nowPage === 3">
        <div v-if="reward.item">
          <div>
            {{ reward.exp }}
          </div>
          <div>
            {{ reward.item }}
          </div>
          <div @click="$emit('miniGame3Close')">확인</div>
        </div>
      </div>

      <!-- 게임 내용 >.<  -->

      <div v-else class="game__play">
        <div>{{ chosung.time }}</div>
        <div>{{ chosung.quiz[chosung.nowPage][0] }}</div>
        <input type="text" v-model="chosung.input" />
        <div @click="submitInput()">제출</div>
      </div>

      <img
        v-if="!game.game || chosung.nowPage === 3"
        class="exit__btn"
        @click="$emit('miniGame3Close')"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import axios from 'axios'
import _ from 'lodash'

import { chosungs } from '../modules/Chosung'
import { BASE_URL } from '@/constant/BASE_URL'

export default {
  components: {},
  setup(props, { emit }) {
    const game = ref({ game: false })
    let chosung = ref({ quiz: [], nowPage: 0, time: 10, input: '' })
    let reward = ref({ exp: 15, item: 0 })

    // 퀴즈 데이터 받아와서 셔플하기
    const tmp_chosungs = _.shuffle(chosungs)
    // 퀴즈 3개 뽑아오기!
    chosung.value.quiz = tmp_chosungs.slice(0, 4)
    function changeGame() {
      startTimer()
      game.value.game = true
    }
    // 타이머
    function startTimer() {
      let gameTimer = setInterval(() => {
        chosung.value.time -= 1
        if (chosung.value.time === -1) {
          alert('끝')
          clearInterval(gameTimer)
          emit('miniGame3Close')
        }
        if (chosung.value.nowPage === 3) {
          clearInterval(gameTimer)
        }
      }, 1000)
    }

    function submitInput() {
      console.log(chosung.value.quiz)
      if (
        chosung.value.input === chosung.value.quiz[chosung.value.nowPage][1]
      ) {
        chosung.value.time = 10
        chosung.value.input = ''
        chosung.value.nowPage += 1
      } else {
        chosung.value.input = ''
      }
      if (chosung.value.nowPage === 3) {
        alert('굿')
        axios({
          url: BASE_URL + '/api/v1/mission/mini?rewardExp=' + reward.value.exp,
          method: 'PUT',
          headers: {
            AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
          }
        })
          .then((res) => {
            console.log(res.data)
            reward.value.item = res.data.itemId
          })
          .catch((err) => console.log(err))
      }
    }
    return {
      game,
      chosung,
      reward,
      changeGame,
      submitInput
    }
  }
}
</script>

<style scoped>
.miniGame__container {
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  /* background-color: rgb(212, 212, 212, 0.5); */
}

.miniGame {
  top: 25%;
  width: 60%;
  height: 80%;
  background-color: rgb(255, 244, 231);
  z-index: 40;
  border-radius: 30px;
}

.game__description {
  margin: 5vh;
  text-align: center;
}

.game__img {
  margin-top: 5vh;
  margin-bottom: 5vh;
  width: 50%;
}

.game__text {
}

.game__item {
  margin: 3vh;
  background-color: white;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  width: 80%;
  margin-left: 5.5vw;
}

.reward__header {
  margin-top: 3vh;
  margin-bottom: 3vh;
}

.game__reward {
  display: flex;
  flex-direction: row;
  justify-content: center;
  margin-bottom: 3vh;
}

.reward__text {
  margin-left: 2vh;
  margin-right: 2vh;
}

.start__btn {
  height: 6vh;
  border-radius: 50px;
  border: none;
  width: 10vw;
  cursor: pointer;
  font-size: 1.2rem;
  font-weight: bold;
}

.start__btn:hover {
  background-color: #6bfa8d;
}
.game__play {
  margin: 5vh;
}

.exit__btn {
  width: 4vw;
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 15vh;
  right: 25vw;
  cursor: pointer;
}
</style>
