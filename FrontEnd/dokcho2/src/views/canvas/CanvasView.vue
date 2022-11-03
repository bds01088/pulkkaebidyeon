<template>
  <div class="wholeCanvas">
    <NavBar />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
    />
    <HouseCanvas2
      v-show="this.nowPage === 1"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
    />
  </div>
</template>

<script>
import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
import HouseCanvas2 from '../../components/canvas/HouseCanvas2.vue'
import NavBar from '../../components/main/NavBar.vue'

export default {
  data() {
    return {
      nowPage: 0
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas2: HouseCanvas2,
    NavBar: NavBar
  },
  methods: {
    changeCanvas() {
      if (this.nowPage === 0) {
        this.nowPage = 1
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
