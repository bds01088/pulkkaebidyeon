<template>
  <div class="wholeCanvas">
    <SocketCanvas v-show="this.nowPage === 0" :nowPage="this.nowPage" />
    <!-- <NavBar />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      @changeBattle="changeBattle"
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
    /> -->
  </div>
</template>

<script>
// import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
// import HouseCanvas from '../../components/canvas/HouseCanvas.vue'
// import NavBar from '../../components/main/NavBar.vue'

// import BattleCanvas from '../../components/battle/BattleCanvas.vue'
import SocketCanvas from '../../components/canvas/SocketCanvas.vue'

export default {
  data() {
    return {
      nowPage: 0
    }
  },
  components: {
    SocketCanvas: SocketCanvas
    // WorldCanvas: WorldCanvas,
    // HouseCanvas: HouseCanvas,
    // NavBar: NavBar,
    // BattleCanvas: BattleCanvas
  },
  methods: {
    changeCanvas() {
      if (this.nowPage === 0) {
        this.nowPage = 1
      } else {
        this.nowPage = 0
      }
    },

    changeBattle() {
      if (this.nowPage === 0) {
        this.nowPage = 3
      } else {
        this.nowPage = 0
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
