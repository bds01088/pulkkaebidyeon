<template>
  <div class="loadingPage">
    <div class="loading__false" v-if="this.isloading !== 1">
      <!-- <div class="story">
        옛날 옛날 어느 마을에 허준이라는 의원이 살고 있었어요. <br />
        허준은 백성들을 위해 온갖 병과 치료법을 밤낮으로 연구한 끝에 동의보감을
        편찬했어요. <br />
        “이 동의보감이 있으면 더 이상 백성들이 병으로 고통 받지 않을게야” <br />
        하지만 이 모습을 지켜보던 악랄한 호랑이와 동물들이 완성된 동의보감을
        훔쳐 달아나 버렸어요. <br />
        허준의 제자인 여러분은 허준이 기르던 풀깨비들과 함께 동의보감을 찾기
        위해 모험을 떠나기로 했어요. <br />
        호랑이의 흔적을 찾아 동의보감을 되찾아주세요!
      </div> -->
      <!-- <img class="loading__img" src="@/assets/loading/loading.png" /> -->
      <div class="loading__box">
        <div class="loading">
          <img class="img1" src="@/assets/loading/1.png" alt="1" />
          <img class="img2" src="@/assets/loading/2.png" alt="2" />
          <img class="img3" src="@/assets/loading/3.png" alt="3" />
          <img class="img4" src="@/assets/loading/4.png" alt="4" />
        </div>
      </div>
      <p class="entering" v-if="this.isloading !== 1">
        호랑이의 흔적을 찾아 동의보감을 되찾아주세요!
      </p>
    </div>

    <div v-else class="loading__true">
      <button class="start__btn" @click="gameStart()">입장하기</button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isloading: Number
  },
  methods: {
    gameStart() {
      this.$emit('gameStart')
    }
  }
}
</script>

<style scoped>
.loadingPage {
  position: fixed;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  /* background-color: white; */
}

.loading__img {
  margin-top: 5vh;
  width: 40%;
  border-radius: 30px;
}

.loading__false {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
    url('../../assets/forest2.png');
  background-size: cover;
}

.loading__true {
  width: 100%;
  height: 100%;
  /* background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
    url('../../assets/startimg.png');
  background-size: cover; */
  background-color: rgba(0, 0, 0, 0.785);
  text-align: center;
}

.story {
  text-align: center;
  /* margin: 10px; */
  margin: 5vw 5vw 5vw 5vw;
  font-size: 18px;
  color: white;
  line-height: 2rem;
}

.start__btn {
  min-width: 15vw;
  min-height: 10vh;
  font-size: 20px;
  transition: 0.5s;
  background-color: #6bfa8d;
  margin-top: 20%;
}

.start__btn:hover {
  scale: 1.05;
  background-color: #6bfa8d;
}

.loading__box {
  width: 50vw;
  height: 25vh;
  display: flex;
  /* position: fixed; */
  bottom: 5vh;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.loading {
  width: 50vw;
  /* height: 10vh; */
  display: flex;
  justify-content: center;
  align-items: center;
}

.entering {
  color: white;
  font-size: 1.5rem;
  font-weight: bold;
}

@keyframes jump {
  0% {
    transform: translate3d(0, 0, 0);
  }
  40% {
    transform: translate3d(0, 30%, 0);
  }
  100% {
    transform: translate3d(0, 100%, 0);
  }
}

.loading > img {
  width: 5vw;
  height: 5vw;
  margin: 1vw;
}

.img1 {
  transform-origin: 0% 0%;
  animation: jump 0.5s linear alternate infinite;
}
.img2 {
  transform-origin: 50% 50%;
  animation: jump 0.5s linear alternate infinite;
  animation-delay: 0.1s;
}
.img3 {
  transform-origin: 100% 100%;
  animation: jump 0.5s linear alternate infinite;
  animation-delay: 0.2s;
}
.img4 {
  transform-origin: 50% 50%;
  animation: jump 0.5s linear alternate infinite;
  animation-delay: 0.3s;
}
</style>
