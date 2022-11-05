<template>
  <div class="quiz">
    <div class="quiz__box">
      <div class="box" v-if="quiz.content[quiz.nowPage]">
        <div class="question">{{ quiz.content[quiz.nowPage].question }}</div>
        <img :src="quiz.content[quiz.nowPage].img" alt="quiz-image" />
        <div
          class="answer1"
          @click="nextQuiz(quiz.content[quiz.nowPage].answer1)"
        >
          {{ quiz.content[quiz.nowPage].answer1 }}
        </div>
        <div
          class="answer2"
          @click="nextQuiz(quiz.content[quiz.nowPage].answer2)"
        >
          {{ quiz.content[quiz.nowPage].answer2 }}
        </div>
        <div
          class="answer3"
          @click="nextQuiz(quiz.content[quiz.nowPage].answer3)"
        >
          {{ quiz.content[quiz.nowPage].answer3 }}
        </div>
        <div
          class="answer4"
          @click="nextQuiz(quiz.content[quiz.nowPage].answer4)"
        >
          {{ quiz.content[quiz.nowPage].answer4 }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { onMounted } from '@vue/runtime-core'
import { ref } from 'vue'

export default {
  setup(props, { emit }) {
    let quiz = ref({ content: [], nowPage: 0, rightAnswer: [] })
    const userInfo = JSON.parse(localStorage.getItem('userInfo'))

    function getQuiz() {
      axios({
        url: BASE_URL + '/api/v1/mission/quiz/' + userInfo.nowMissionId,
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          console.log(res.data)
          quiz.value.content = res.data
        })
        .catch((err) => console.log(err))
    }

    function endQuiz() {
      let pass = true
      quiz.value.rightAnswer.forEach((e) => {
        if (e === false) {
          pass = false
        }
      })
      if (pass === true) {
        alert('다맞춤')
        axios({
          url:
            BASE_URL +
            '/api/v1/mission/' +
            userInfo.nowMissionId +
            '?nowStatus=STARTED',
          method: 'PUT',
          headers: {
            AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
          }
        })
      } else {
        alert('더 공부하셈')
      }
      emit('quizClose')
    }

    function nextQuiz(answer) {
      if (answer === quiz.value.content[quiz.value.nowPage].right_answer) {
        quiz.value.rightAnswer.push(true)
        alert('정답')
      } else {
        quiz.value.rightAnswer.push(false)
        alert('오답')
      }
      quiz.value.nowPage += 1
      if (quiz.value.nowPage === quiz.value.content.length) {
        endQuiz()
      }
    }

    onMounted(() => getQuiz())

    return {
      quiz,
      nextQuiz,
      endQuiz
    }
  }
}
</script>

<style scoped>
.quiz {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.quiz__box {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}
.box {
  width: 80%;
  height: 70%;
  background-color: rgb(167, 105, 105);
}
</style>
