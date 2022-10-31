<template>
  <div class="window">
    <div class="myMission">
      <div>미션창</div>
      <div
        v-for="(mission, i) in this.missions"
        :key="i"
        @click="openMissionDetail"
      >
        {{ mission.characters }}
      </div>
      <div>{{ this.missions[0] }}</div>
      <button @click="this.$parent.closeModal1">닫기</button>
    </div>
  </div>
  <MissionDetail @click="closeMissionDetail" v-if="missionDetail">
  </MissionDetail>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import MissionDetail from './MissionDetail.vue'

export default {
  data() {
    return {
      missions: [],
      missionDetail: false
    }
  },
  components: { MissionDetail },
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
    },
    openMissionDetail() {
      this.missionDetail = true
    },
    closeMissionDetail() {
      this.missionDetail = false
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
  background: rgba(255, 255, 255, 0.9);
}
</style>
