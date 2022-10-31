<template>
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
</template>

<script>
import WorldCanvas from '../../components/canvas/WorldCanvas.vue'
import HouseCanvas from '../../components/canvas/HouseCanvas.vue'

export default {
  data() {
    return {
      nowPage: 0
    }
  },
  components: {
    WorldCanvas: WorldCanvas,
    HouseCanvas: HouseCanvas
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
  height: 600px;
  width: 600px;
}
</style>
