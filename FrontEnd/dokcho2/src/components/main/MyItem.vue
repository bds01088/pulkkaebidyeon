<template>
  <div class="myItem">
    <div>가방창</div>
    <p>{{ this.items }}</p>
    <button @click="this.$parent.closeModal2">닫기</button>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'

export default {
  data() {
    return {
      items: []
    }
  },
  methods: {
    fetchItems() {
      axios({
        url: BASE_URL + '/api/v1/item/',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          this.items = res.data
        })
        .catch((err) => {
          console.log(err)
        })
    }
  },
  created() {
    this.fetchItems()
  }
}
</script>

<style scoped>
.myItem {
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
