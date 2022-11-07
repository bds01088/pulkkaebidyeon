<template>
  <div class="introCard">
    <div class="introCard__top">
      <p class="TITLE">
        {{ this.userInfo.nickname }} 님과 함께 할 풀깨비들이 찾아왔어요!
      </p>
    </div>

    <div class="introCard__body">
      <div class="introCard__middle">
        <div class="dockchoCard" v-for="(dockcho, i) in this.dockchos" :key="i">
          <div class="imageBG">
            <!-- <img
              :src="require('@/assets/intro-card/' + (i + 1) + '.png')"
              alt=""
              class="card__image"
              :class="this.isChecked ? '' : 'dark'"
            /> -->
            <img src="@/assets/intro-card/1.png" alt="" class="card__image" />
          </div>
          <p class="card__name" :class="this.isChecked ? '' : 'hidden'">
            {{ dockcho }}
          </p>
        </div>
      </div>
      <div class="introCard__bottom">
        <!-- <div
        class="checkBtn"
        :class="this.isChecked ? 'none' : ''"
        @click="onClickBtn()"
      >
        눌러서 확인하기
      </div> -->
        <div
          class="checkBtn"
          :class="this.isChecked ? '' : 'none'"
          @click="goToMain()"
        >
          <p class="main__btn">메인 페이지로</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dockchos: ['개나리몬', '마늘몬', '도꼬마리몬'],
      isChecked: false,
      userInfo: JSON.parse(localStorage.getItem('userInfo'))
    }
  },
  methods: {
    onClickBtn() {
      this.isChecked = !this.isChecked
    },
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
  width: 60%;
  height: 60%;
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
  color: black;
  background-color: antiquewhite;
  border: 1px solid burlywood;
  border-radius: 20px;
}

.card__image {
  width: 70%;
  margin-top: 3vh;
}

.card__name {
  margin-bottom: 3vh;
}

.introCard__bottom {
  margin-top: 5%;
}

.main__btn {
  font-size: 4vh;
}
.main__btn:hover {
  cursor: pointer;
  color: green;
}
</style>
