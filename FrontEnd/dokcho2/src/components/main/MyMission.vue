<template>
  <div class="myMission">
    <div class="mission__header">
      <p class="mission__user">{{ userInfo.nickname }}의 사건 수첩</p>

      <p>지금 해결 중인 사건 :</p>
    </div>

    <div
      v-for="(mission, i) in missions.missions"
      :key="i"
      class="mission__body"
    >
      <!-- CSS 하고 주석 풀 예정 -->
      <!-- <div v-if="mission.status !== 'NOT_YET'" class="mission__box">
        <p>{{ mission.missionId }}번째 사건. 해결 완료!</p>
        <p>{{ mission.characters }}의 고민을 해결하라!</p>
      </div>
      <div v-else class="mission__box">
        <p>{{ mission.missionId }}번째 사건.</p>
        <p>미해결</p>
      </div> -->

      <div
        class="mission__box"
        @click="openMissionDetail"
        :class="{
          mission__now: mission.status === 'STARTED',
          mission__notyet: mission.status === 'NOT_YET',
          mission__finished: mission.status === 'FINISHED'
        }"
      >
        <p>{{ mission.missionId }}번째 사건</p>
        <p>{{ mission.characters }}의 고민을 해결하라!</p>
      </div>
    </div>
    <!-- <div>{{ missions.missions[0] }}</div> -->
    <button @click="$emit('closeModal1')">닫기</button>
  </div>

  <MissionDetail @click="closeMissionDetail" v-if="missionDetail.missionDetail">
  </MissionDetail>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import MissionDetail from './MissionDetail.vue'
import { ref, onMounted } from 'vue'

export default {
  components: { MissionDetail },
  setup() {
    const missions = ref({ missions: [] })
    const missionDetail = ref({ missionDetail: false })
    const userInfo = JSON.parse(localStorage.getItem('userInfo'))

    function fetchMissions() {
      axios({
        url: BASE_URL + '/api/v1/mission/',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          missions.value.missions = res.data
        })
        .catch((err) => {
          console.log(err)
        })
    }

    function openMissionDetail() {
      missionDetail.value.missionDetail = true
    }

    function closeMissionDetail() {
      missionDetail.value.missionDetail = false
    }

    onMounted(() => {
      fetchMissions()
    })

    return {
      missions,
      missionDetail,
      userInfo,
      fetchMissions,
      openMissionDetail,
      closeMissionDetail
    }
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
  top: 10%;
  left: 25%;
  width: 50%;
  height: 80%;
  background: rgba(255, 255, 255, 0.9);
  /* background-image: url('@/assets/Paper.png'); */
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  backdrop-filter: blur(4px);
  border-radius: 20px;
  overflow: visible;
}

.mission__user {
  font-weight: bolder;
  font-size: 2rem;
}

.mission__header p {
  margin-bottom: 2vh;
}

.mission__body {
  margin-bottom: 2vh;
  border: 1px solid white;
  background-color: #ffffff;
  width: 50%;
  padding: 1vh;
  border-radius: 10px;
  box-shadow: 1px 1px 5px 1px gray;
  /* display: flex;
  flex-direction: row; */
}

.mission__body:hover {
  cursor: pointer;
}

.mission__box {
  display: flex;
  flex-direction: row;
}

.mission__box p {
  margin: auto;
}
</style>
