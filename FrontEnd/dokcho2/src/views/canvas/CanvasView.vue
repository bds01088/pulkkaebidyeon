<template>
  <div class="wholeCanvas">
    <NavBar />
    <TalkComponent v-if="isTalk" />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      @changeBattle="changeBattle"
      @talkStart="talkStart"
      :nowPage="this.nowPage"
    />
    <HouseCanvas
      v-show="this.nowPage === 1"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
    />
    <BattleCanvas
      v-show="this.nowPage === 3"
      @changeBattle="changeBattle"
      :nowPage="this.nowPage"
    />
  </div>
</template>

<script>
import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
import HouseCanvas from '../../components/canvas/HouseCanvas.vue'
import NavBar from '../../components/main/NavBar.vue'
import TalkComponent from '../../components/script/TalkComponent.vue'

import BattleCanvas from '../../components/battle/BattleCanvas.vue'

export default {
  data() {
    return {
      nowPage: 0,
      isTalk: false
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas: HouseCanvas,
    NavBar: NavBar,
    BattleCanvas: BattleCanvas,
    TalkComponent: TalkComponent
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
      } else {
        this.nowPage = 0
      }
    },

    talkStart() {
      this.isTalk = true
    }
  },
  mounted() {
    console.log(this.nowPage)
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
