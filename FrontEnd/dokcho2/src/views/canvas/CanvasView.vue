<template>
  <div class="wholeCanvas">
    <div class="fullPage">
      <img
        class="fullPage__btn"
        src="@/assets/open.png"
        @click="fullPageChange"
        v-if="fullPage === false"
      />
      <img
        class="fullPage__btn"
        src="@/assets/close.png"
        @click="fullPageChange"
        v-if="fullPage === true"
      />
    </div>
    <NavBar @changeNavbar="changeNavbar" />
    <LoadingPage
      v-if="this.isGameStart === 0"
      @gameStart="gameStart"
      :isloading="this.isloading"
    />
    <WorldCanvas
      v-show="this.nowPage === 0 && this.isBattle === 0"
      @changeCanvas="changeCanvas"
      @changeBattle="changeBattle"
      @talkStart="talkStart"
      @loadingEnd="loadingEnd"
      :isGameStart="this.isGameStart"
      :nowPage="this.nowPage"
      :nowNavbar="this.nowNavbar"
    />
    <HouseCanvas
      v-show="this.nowPage === 1"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
      :nowNavbar="this.nowNavbar"
    />
    <BattleCanvas
      v-show="this.isBattle === 1"
      @changeBattle="changeBattle"
      @startBattle="startBattle"
      :nowPage="this.nowPage"
      :nowNavbar="this.nowNavbar"
      :startSignal="this.startSignal"
    />
  </div>
</template>

<script>
import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
import HouseCanvas from '../../components/canvas/HouseCanvas.vue'
import NavBar from '../../components/main/NavBar.vue'
import LoadingPage from '../../components/main/LoadingPage.vue'

import BattleCanvas from '../../components/battle/BattleCanvas.vue'

export default {
  data() {
    return {
      nowPage: 0,
      isBattle: 0,
      nowNavbar: false,
      startSignal: 0,
      isloading: 0,
      isGameStart: 0,
      audio: new Audio('audio/oursound.mp3'),
      fullPage: false
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas: HouseCanvas,
    NavBar: NavBar,
    BattleCanvas: BattleCanvas,
    LoadingPage: LoadingPage
  },
  mounted() {
    this.audio.muted = true
    this.audio.loop = true
    this.audio.volume = 0.9
    this.audio.play()
    this.audio.muted = false
  },
  beforeUnmount() {
    this.audio.pause()
  },
  methods: {
    // 전체화면 변경
    fullPageChange() {
      const documentElement = document.documentElement
      if (document.fullscreenElement === null) {
        //전체화면 아닌 상태
        documentElement.requestFullscreen()
        this.fullPage = true
      } else {
        //전체화면 상태
        document.exitFullscreen()
        this.fullPage = false
      }
    },

    changeCanvas() {
      if (this.nowPage === 0) {
        this.nowPage = 1
      } else {
        this.nowPage = 0
      }
      console.log(this.nowPage)
    },

    changeBattle() {
      if (this.nowPage === 0 && this.isBattle === 0) {
        this.isBattle = 1
        this.startBattle()
      } else {
        this.isBattle = 0
        this.audio.play()
      }
    },

    startBattle() {
      this.startSignal += 1
      this.audio.pause()
    },

    changeNavbar() {
      if (this.nowNavbar === true) {
        this.nowNavbar = false
      } else {
        this.nowNavbar = true
      }
    },

    loadingEnd() {
      setTimeout(() => {
        console.log('로딩끝?')
        this.isloading = 1
      }, 5000)
    },

    gameStart() {
      this.isGameStart = 1
    }
  }
}
</script>

<style>
* {
  outline: none;
  margin: 0;
}
.wholeCanvas {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.fullPage {
  position: fixed;
  display: inline;
  z-index: 20;
  bottom: 5%;
  left: 93%;
}

.fullPage__btn {
  cursor: url('@/assets/selector.cur'), pointer;
  transition: 0.5s;
}

.fullPage__btn:hover {
  scale: 1.2;
}
</style>
