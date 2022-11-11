<template>
  <div class="quiz">
    <div class="quiz__box">
      <div class="box" v-if="quiz.content[quiz.nowPage]">
        <div class="question">
          {{ quiz.nowPage + 1 }}. {{ quiz.content[quiz.nowPage].question }}
        </div>
        <div class="content">
          <img :src="quiz.content[quiz.nowPage].img" alt="quiz-image" />
          <div class="answers">
            <div
              class="answer1"
              @click="nextQuiz(quiz.content[quiz.nowPage].answer1)"
            >
              (1) {{ quiz.content[quiz.nowPage].answer1 }}
            </div>
            <div
              class="answer2"
              @click="nextQuiz(quiz.content[quiz.nowPage].answer2)"
            >
              (2) {{ quiz.content[quiz.nowPage].answer2 }}
            </div>
            <div
              class="answer3"
              @click="nextQuiz(quiz.content[quiz.nowPage].answer3)"
            >
              (3) {{ quiz.content[quiz.nowPage].answer3 }}
            </div>
            <div
              class="answer4"
              @click="nextQuiz(quiz.content[quiz.nowPage].answer4)"
            >
              (4) {{ quiz.content[quiz.nowPage].answer4 }}
            </div>
          </div>
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
    let quiz = ref({ content: [], nowPage: 0 })
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
      emit('quizClose')
    }

    function nextQuiz(answer) {
      if (answer === quiz.value.content[quiz.value.nowPage].right_answer) {
        alert('정답')
        quiz.value.nowPage += 1
        if (quiz.value.nowPage === quiz.value.content.length) {
          endQuiz()
        }
      } else {
        alert('더 공부하셈')
        emit('quizClose')
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
  border-radius: 8vw;
  padding: 5vw;
  width: 70%;
  height: 60%;
  background-color: rgb(231, 227, 186);
  display: flex;
  flex-direction: column;
}
.question {
  font-size: 1.5vw;
  width: 100%;
  height: 10%;
}
.content {
  width: 100%;
  height: 90%;
  display: flex;
}
.content > img {
  max-width: 50vw;
  max-height: 50vh;
}
.answers {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 2vw;
}
.answers > div {
  display: flex;
  align-items: center;
  margin: 1vw;
  padding: 0 1vw;
  width: 20vw;
  height: 6vh;
  border-radius: 3vh;
  background-color: rgb(242, 241, 235);
}
</style>
