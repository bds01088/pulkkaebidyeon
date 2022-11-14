<template>
  <div class="introCard">
    <div class="introCard__top">
      <p class="TITLE">
        {{ this.userInfo.nickname }} 님과 여정을 함께 할 풀깨비가 찾아왔어요!
      </p>
    </div>

    <div class="introCard__body">
      <div class="introCard__middle">
        <div class="dockchoCard">
          <div class="imageBG">
            <img src="@/assets/starting/1.png" alt="" class="card__image" />
          </div>
          <p class="card__name">개나리몬</p>
        </div>
      </div>
      <div class="introCard__bottom">
        <button
          class="main__btn"
          :class="this.isChecked ? '' : 'none'"
          @click="goToMain()"
        >
          메인 페이지로
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem('userInfo'))
    }
  },
  methods: {
    goToMain() {
      this.$router.push({ path: '/main' })
    }
  }
}
</script>

<style scoped>
.introCard {
  background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
    url('@/assets/forest2.png');
  background-size: cover;
  width: 100vw;
  height: 100vh;
  text-align: center;
}

.introCard__body {
  display: inline-block;
  width: 30%;
  height: 70%;
  background-color: rgba(255, 255, 255, 0.8);
  border-radius: 40px;
}

.introCard__top {
  align-items: center;
  text-align: center;
  color: white;
}

.introCard__top p {
  padding: 10vh;
  font-size: 5vh;
  margin: 0;
}

.introCard__middle {
  display: flex;
  flex-direction: row;
  justify-content: center;
  margin-top: 7%;
}

.introCard__middle p {
  font-weight: bold;
  font-size: 3vh;
}

.dockchoCard {
  margin: auto;
  /* color: black;
  background-color: antiquewhite;
  border: 1px solid burlywood;
  border-radius: 20px; */
}

.card__image {
  width: 50%;

  /* margin-top: 3vh; */
}

.card__name {
  margin-bottom: 3vh;
}

.introCard__bottom {
  margin-top: 5%;
}

.main__btn {
  height: 4vh;
  border-radius: 50px;
  border: none;
  width: 12vw;
}
.main__btn:hover {
  cursor: pointer;
  color: green;
}
</style>
