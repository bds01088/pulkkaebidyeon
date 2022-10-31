<template>
  <div class="wholeCanvas">
    <NavBar />
    <WorldCanvas
      v-show="this.nowPage === 0"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
    />
    <HouseCanvas
      v-show="this.nowPage === 1"
      @changeCanvas="changeCanvas"
      :nowPage="this.nowPage"
    />
  </div>
</template>

<script>
import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
import HouseCanvas from '../../components/canvas/HouseCanvas.vue'
import NavBar from '../../components/main/NavBar.vue'

export default {
  data() {
    return {
      nowPage: 0
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas: HouseCanvas,
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
canvas {
  width: 100%;
  height: 100%;
}

.wholeCanvas {
  position: relative;
  width: 1800px;
  height: 800px;
}
</style>
