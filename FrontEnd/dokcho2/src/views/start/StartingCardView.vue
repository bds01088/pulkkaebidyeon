<template>
  <div class="introCard">
    <div class="introCard__top">
      <!-- <p class="TITLE">허준의 제자,</p> -->
      <p class="TITLE">
        {{ this.nickname }} 님과 함께 할 풀깨비들이 찾아왔어요!
      </p>
    </div>
    <div class="introCard__middle">
      <div class="dockchoCard" v-for="(dockcho, i) in this.dockchos" :key="i">
        <div class="imageBG">
          <!-- <img
            :src="require('@/assets/intro-card/' + (i + 1) + '.png')"
            alt=""
            class="card__image"
            :class="this.isChecked ? '' : 'dark'"
          /> -->
        </div>
        <p class="TITLE" :class="this.isChecked ? '' : 'hidden'">
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
        메인 페이지로
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
      nickname: JSON.parse(localStorage.getItem('userInfo')).nickname
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
