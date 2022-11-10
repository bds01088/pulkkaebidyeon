<template>
  <div class="wholeCanvas">
    <NavBar @changeNavbar="changeNavbar" />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      @changeBattle="changeBattle"
      @talkStart="talkStart"
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

import BattleCanvas from '../../components/battle/BattleCanvas.vue'

export default {
  data() {
    return {
      nowPage: 0,
      nowNavbar: false,
      startSignal: 0
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas: HouseCanvas,
    NavBar: NavBar,
    BattleCanvas: BattleCanvas
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
    }
  }
}
</script>

<style>
* {
  outline: none;
  margin: 0;
}
canvas {
  position: relative;
  height: 600px;
  width: 600px;
}
</style>
