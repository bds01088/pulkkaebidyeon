<template>
  <WorldView
    v-show="this.nowPage === 0"
    @changeCanvas="changeCanvas"
    :nowPage="this.nowPage"
  />
  <HouseView
    v-show="this.nowPage === 1"
    @changeCanvas="changeCanvas"
    :nowPage="this.nowPage"
  />
</template>

<script>
import WorldView from '../components/canvas/WorldView.vue'
import HouseView from '../components/canvas/HouseView.vue'

export default {
  data() {
    return {
      nowPage: 0
    }
  },
  components: {
    WorldView: WorldView,
    HouseView: HouseView
  },
  methods: {
    changeCanvas() {
      if (this.nowPage === 0) {
        this.nowPage = 1
      } else {
        this.nowPage = 0
      }
      console.log(this.nowPage)
    }
  }
}
</script>

<style>
canvas {
  height: 100%;
  width: 100%;
}
</style>
