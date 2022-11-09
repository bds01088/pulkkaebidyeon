<template>
  <div class="game__container">
    <div class="on__game">
      <div class="game__header" v-if="!lastStage.lastStage">
        <!-- 힌트 / 횟수 -->
        <p>⭐스테이지 {{ stage.stage + 1 }}</p>
        <div class="game__hint" v-if="quizs.quizs.length > 0">
          <p @click="useHintChance()">👁‍🗨힌트 {{ hint.hint }}회</p>
          <p v-if="useHint.useHint">
            {{ quizs.quizs[stage.stage].description }}
          </p>
        </div>
        <div class="game__point">
          <p>현재까지 획득한 포인트 : {{ point.point }}</p>
        </div>
      </div>
      <div
        class="game__body"
        v-if="quizs.quizs.length > 0 && !lastStage.lastStage"
      >
        <!-- 퀴즈 -->
        <div class="question">
          <p>{{ quizs.quizs[stage.stage].question }}</p>
        </div>
        <div class="answer">
          <p @click="selectAnswer(quizs.quizs[stage.stage].answer1)">
            1. {{ quizs.quizs[stage.stage].answer1 }}
          </p>
          <p @click="selectAnswer(quizs.quizs[stage.stage].answer2)">
            2. {{ quizs.quizs[stage.stage].answer2 }}
          </p>
          <p @click="selectAnswer(quizs.quizs[stage.stage].answer3)">
            3. {{ quizs.quizs[stage.stage].answer3 }}
          </p>
          <p @click="selectAnswer(quizs.quizs[stage.stage].answer4)">
            4. {{ quizs.quizs[stage.stage].answer4 }}
          </p>
        </div>
      </div>
      <div v-if="lastStage.lastStage && point.point > 0">
        <p>총 {{ point.point }}점 획득!</p>
        <p>{{ item.item.itemName }}</p>
        <button>닫기</button>
      </div>
      <div v-if="lastStage.lastStage && point.point <= 0">
        <p>총 점수가 0점 이하라 아무것도.. 얻지 못했어요</p>
        <button>닫기</button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import swal from 'sweetalert'
import { BASE_URL } from '@/constant/BASE_URL'

// 스테이지수 (5개)
// 힌트수 (1회 /2회)
// 얻은 점수 (게임 끝났을 때 그만큼 넣어준다) : 문제 맞추면 + 3 힌트 사용했으면 + 2, 틀리면 - 1

export default {
  setup() {
    const stage = ref({ stage: 0 })
    const hint = ref({ hint: 2 })
    const quizs = ref({ quizs: [] })
    const useHint = ref({ useHint: false })
    const selectedAnswer = ref({ selectedAnswer: '' })
    const point = ref({ point: 0 })
    const lastStage = ref({ lastStage: false })
    const item = ref({ item: {} })

    // 정답 선택
    function selectAnswer(ans) {
      selectedAnswer.value.selectedAnswer = ans
      checkStage()
    }

    // 퀴즈 가져오기
    function fetchQuiz() {
      axios({
        url: BASE_URL + '/api/v1/game/words/5',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          // console.log(res.data)
          // console.log('index 쓸 수 있나 확인', res.data[1])
          quizs.value.quizs = res.data
        })
        .catch((err) => console.log(err))
    }

    // 힌트사용
    function useHintChance() {
      if (hint.value.hint > 0) {
        hint.value.hint -= 1
        useHint.value.useHint = true
      }
    }

    // 정답체크 : 체크해서 일치 -> 포인트 넣어주고 -> swal 띄운 후 -> 다음 단계
    // 마지막 스테이지면 총 획득 점수 알려주고 -> 경험치 넣어주고 -> 종료

    // 정답체크해서 포인트 넣어주기
    function checkAnswer() {
      if (
        selectedAnswer.value.selectedAnswer ===
          quizs.value.quizs[stage.value.stage].right_answer &&
        !useHint.value.useHint
      ) {
        point.value.point += 3
        swal({
          className: 'swal-wide',
          title: '정답입니다!',
          icon: 'success',
          text: `+3점 :D 
          ${quizs.value.quizs[stage.value.stage].question}${
            quizs.value.quizs[stage.value.stage].right_answer
          } : ${quizs.value.quizs[stage.value.stage].description}`,
          buttons: false,
          timer: 1800
        })
      } else if (
        selectedAnswer.value.selectedAnswer ===
          quizs.value.quizs[stage.value.stage].right_answer &&
        useHint.value.useHint
      ) {
        point.value.point += 2
        swal({
          title: '정답입니다!',
          icon: 'success',
          text: `힌트 사용! +2점 :)
          ${quizs.value.quizs[stage.value.stage].question}${
            quizs.value.quizs[stage.value.stage].right_answer
          } : ${quizs.value.quizs[stage.value.stage].description}`,
          buttons: false,
          timer: 1800
        })
      } else {
        point.value.point -= 1
        swal({
          title: '아쉽게도 오답이에요..!',
          icon: 'error',
          text: `-1점 :(
          ${quizs.value.quizs[stage.value.stage].question}${
            quizs.value.quizs[stage.value.stage].right_answer
          } : ${quizs.value.quizs[stage.value.stage].description}`,
          buttons: { cancel: '->' }
          // timer: 2000
        })
      }
    }

    // 스테이지 확인해서 정답 체크 (포인트 넣기)

    function checkStage() {
      const now = stage.value.stage
      if (now !== 4) {
        checkAnswer()
        useHint.value.useHint = false
        stage.value.stage += 1
      } else if (now === 4) {
        checkAnswer()
        // 포인트 보내고 아이템 받기
        if (point.value.point > 0) {
          sendPoint()
        }

        lastStage.value.lastStage = true
      }
    }

    // 포인트 보내기 ..........
    function sendPoint() {
      axios({
        url: BASE_URL + '/api/v1/mission/mini?rewardExp=' + point.value.point,
        method: 'PUT',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          // console.log(res.data)
          item.value.item = res.data
        })
        .catch((err) => console.log(err))
    }

    onMounted(() => fetchQuiz())
    return {
      stage,
      hint,
      quizs,
      useHint,
      selectedAnswer,
      point,
      lastStage,
      selectAnswer,
      useHintChance,
      item,
      sendPoint
    }
  }
}
</script>

<style scoped>
.game__container {
  z-index: 40;
  width: 100%;
  height: 100%;
  /* background-color: rgb(212, 212, 212, 0.5); */
}
</style>
