<template>
  <div class="myMission">
    <div>미션창</div>
    <div v-for="(mission, i) in this.missions" :key="i">
      {{ mission.characters }}
    </div>
    <div>{{ this.missions[0] }}</div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'

export default {
  data() {
    return {
      missions: []
    }
  },
  methods: {
    fetchMissions() {
      axios({
        url: BASE_URL + '/api/v1/mission/',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          this.missions = res.data
        })
        .catch((err) => {
          console.log(err)
        })
    }
  },
  created() {
    this.fetchMissions()
  }
}
</script>

<style scoped>
.myMission {
  display: flex;
  flex-direction: column;
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
