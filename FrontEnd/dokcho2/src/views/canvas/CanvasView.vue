<template>
  <div class="wholeCanvas">
    <NavBar @changeNavbar="changeNavbar" />
    <LoadingPage
      v-if="this.isGameStart === 0"
      @gameStart="gameStart"
      :isloading="this.isloading"
    />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      @changeBattle="changeBattle"
      @talkStart="talkStart"
      @loadingEnd="loadingEnd"
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
      v-show="this.nowPage === 3"
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
      nowNavbar: false,
      startSignal: 0,
      isloading: 0,
      isGameStart: 0,
      audio: new Audio('audio/oursound.mp3')
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
    this.audio.loop = true
    this.audio.volume = 0.9
    this.audio.play()
  },
  beforeUnmount() {
    this.audio.pause()
  },
  methods: {
    changeCanvas() {
      if (this.nowPage === 0) {
        this.nowPage = 1
      } else {
        this.nowPage = 0
      }
      console.log(this.nowPage)
    },

    changeBattle() {
      if (this.nowPage === 0) {
        this.nowPage = 3
        this.startBattle()
      } else {
        this.nowPage = 0
      }
    },

    startBattle() {
      this.startSignal += 1
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
</style>
