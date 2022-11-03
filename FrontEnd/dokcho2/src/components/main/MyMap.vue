<template>
  <div class="myMap">
    <div>지도창</div>
    <button @click="this.$parent.closeModal3">닫기</button>
  </div>
</template>

<script>
// import axios from 'axios'
// import { BASE_URL } from '@/constant/BASE_URL'

export default {
  data() {
    return {}
  },
  methods: {}
}
</script>

<style scoped>
.myMap {
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
}
</style>
