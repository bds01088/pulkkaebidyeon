<template>
  <div class="miniGame__container">
    <div class="miniGame">
      <!-- 해당 게임에 대한 설명 -->
      <div v-if="!game.game" class="game__description">
        <h1>게임 설명</h1>
        <p>첨성대에 방문하셨네요~ 게임설명</p>
        <div class="game__item">
          <p>✨보상</p>
          <p>경험치 : 내맘대로</p>
          <p>아이템 : 랜덤</p>
        </div>
        <button @click="changeGame()">게 임 시 작</button>
      </div>
      <!-- 게임 내용 >.<  -->

      <div v-else class="game__play">
        <CardMatch />
      </div>

      <img
        class="exit__btn"
        @click="$emit('miniGame1Close')"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import CardMatch from './CardMatch.vue'

export default {
  components: { CardMatch: CardMatch },
  setup() {
    const game = ref({ game: false })

    function changeGame() {
      game.value.game = true
      // console.log('바꿈')
    }

    return {
      game,
      changeGame
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
</style>
