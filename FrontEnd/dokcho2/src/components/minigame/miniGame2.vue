<template>
  <div class="miniGame__container">
    <div class="miniGame">
      <!-- 해당 게임에 대한 설명 -->
      <div v-if="!game.game" class="game__description">
        <h1>게임 설명</h1>
        <p>첨성대에 방문하셨네요~</p>
        <p>9회 안에 세자리의 숫자를 맞춰야 합니다.</p>
        <p>각 숫자는 1~9까지로 이루어져 있으며, 중복되지 않습니다.</p>
        <hr />
        <p>숫자를 입력하면 다음과 같은 결과가 나타납니다.</p>
        <p>스트라이크 : 숫자와 위치가 전부 맞았을 때.</p>
        <p>볼 : 숫자는 맞지만 위치가 틀렸을 때.</p>
        <p>아웃 : 숫자와 위치가 전부 틀렸을 때.</p>
        <hr />
        <div class="game__item">
          <p>✨보상</p>
          <p>경험치 : 내맘대로</p>
          <p>아이템 : 랜덤</p>
        </div>
        <button @click="changeGame()">게 임 시 작</button>
      </div>

      <!-- 게임 내용 >.<  -->
      <div v-else class="game__play">
        <div class="input__answer">
          <input
            type="text"
            v-model="inputAnswer[0]"
            maxlength="1"
            class="number__box"
          />
          <input
            type="text"
            v-model="inputAnswer[1]"
            maxlength="1"
            class="number__box"
          />
          <input
            type="text"
            v-model="inputAnswer[2]"
            maxlength="1"
            class="number__box"
          />
          <button @click="showResult()" class="do__input">입력</button>
        </div>
        <br />
        <hr />

        <div class="show__result">
          <table>
            <tr>
              <th colspan="3"><h3>Score Board</h3></th>
            </tr>
            <tr>
              <td class="inning">1회</td>
              <td class="nums">{{ scoreBoard[0].input }}</td>
              <td class="score">{{ scoreBoard[0].result }}</td>
            </tr>
            <tr>
              <td>2회</td>
              <td>{{ scoreBoard[1].input }}</td>
              <td>{{ scoreBoard[1].result }}</td>
            </tr>
            <tr>
              <td>3회</td>
              <td>{{ scoreBoard[2].input }}</td>
              <td>{{ scoreBoard[2].result }}</td>
            </tr>
            <tr>
              <td>4회</td>
              <td>{{ scoreBoard[3].input }}</td>
              <td>{{ scoreBoard[3].result }}</td>
            </tr>
            <tr>
              <td>5회</td>
              <td>{{ scoreBoard[4].input }}</td>
              <td>{{ scoreBoard[4].result }}</td>
            </tr>
            <tr>
              <td>6회</td>
              <td>{{ scoreBoard[5].input }}</td>
              <td>{{ scoreBoard[5].result }}</td>
            </tr>
            <tr>
              <td>7회</td>
              <td>{{ scoreBoard[6].input }}</td>
              <td>{{ scoreBoard[6].result }}</td>
            </tr>
            <tr>
              <td>8회</td>
              <td>{{ scoreBoard[7].input }}</td>
              <td>{{ scoreBoard[7].result }}</td>
            </tr>
            <tr>
              <td>9회</td>
              <td>{{ scoreBoard[8].input }}</td>
              <td>{{ scoreBoard[8].result }}</td>
            </tr>
          </table>
        </div>
      </div>

      <img
        class="exit__btn"
        @click="$emit('miniGame2Close')"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'

export default {
  components: {},
  setup(props, { emit }) {
    const game = ref({ game: false })

    function changeGame() {
      game.value.game = true
    }

    const numbers = ref(['1', '2', '3', '4', '5', '6', '7', '8', '9'])
    const answer = ref([])

    function getAnswer() {
      while (answer.value.length < 3) {
        let num = Math.floor(Math.random() * numbers.value.length)

        if (answer.value.includes(numbers.value[num])) {
          continue
        } else {
          answer.value.push(numbers.value[num])
        }
      }
    }

    getAnswer()
    console.log(answer.value)

    const inputAnswer = ref(['', '', ''])
    const turn = ref(-1)

    const scoreBoard = ref([
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' },
      { input: '', result: '' }
    ])

    const strike = ref(0)
    const ball = ref(0)

    function showResult() {
      turn.value += 1

      strike.value = 0
      ball.value = 0

      for (let i = 0; i < 3; i++) {
        if (answer.value[i] == inputAnswer.value[i]) {
          strike.value += 1
        } else {
          if (answer.value.includes(inputAnswer.value[i])) {
            ball.value += 1
          }
        }
      }

      scoreBoard.value[turn.value].input =
        inputAnswer.value[0] +
        ', ' +
        inputAnswer.value[1] +
        ', ' +
        inputAnswer.value[2]

      // 정답!!!!!
      if (strike.value == 3) {
        scoreBoard.value[turn.value].result = '정답'
        // 정답보상

        emit('miniGame2Close')
      }
      // 스트라이크, 볼
      else if (strike.value > 0 && ball.value > 0) {
        scoreBoard.value[turn.value].result =
          strike.value.toString() +
          ' 스트라이크, ' +
          ball.value.toString() +
          ' 볼'
      }
      // 스트라이크
      else if (strike.value > 0) {
        scoreBoard.value[turn.value].result =
          strike.value.toString() + ' 스트라이크'
      }
      // 볼
      else if (ball.value > 0) {
        scoreBoard.value[turn.value].result = ball.value.toString() + ' 볼'
      }
      // 아웃
      else {
        scoreBoard.value[turn.value].result = '아웃'
      }

      inputAnswer.value = ['', '', '']

      // 실패!!!!
      if (turn.value >= 8 && strike.value != 3) {
        // 실패 메시지

        emit('miniGame2Close')
      }
    }

    return {
      game,
      changeGame,
      answer,
      inputAnswer,
      showResult,
      scoreBoard
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
  width: 80%;
  height: 80%;
  background-color: rgb(255, 244, 231);
  z-index: 40;
  border-radius: 30px;
}

.game__description {
  margin: 5vh;
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
  right: 15vw;
  cursor: pointer;
}

.number__box {
  width: 4vw;
  height: 4vw;

  margin-left: 10px;

  font-size: 30px;
  text-align: center;
}

.do__input {
  width: 4vw;
  height: 2vw;

  margin-left: 20px;
}

table,
th,
td {
  border: 1px solid #bcbcbc;
}

table {
  width: 50%;

  text-align: center;
  font-size: 18px;
}

.inning {
  width: 20%;
}

.nums {
  width: 30%;
}

.score {
  width: 50%;
}

tr {
  height: 32px;
}
</style>
