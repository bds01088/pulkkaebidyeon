<template>
  <div class="mission__container">
    <div class="myMission">
      <div class="mission__header">
        <p class="mission__user">{{ userInfo.nickname }}의 사건 수첩</p>

        <!-- <p>지금 해결 중인 사건 :</p> -->
      </div>

      <div
        v-for="(mission, i) in missions.missions"
        :key="i"
        class="mission__body"
        :class="{
          mission__finished: mission.status == 'FINISHED',
          mission__now: mission.status == 'STARTED',
          mission__notyet: mission.status == 'NOT_YET'
        }"
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

        <div v-if="mission.status === 'NOT_YET'" class="mission__box">
          <div class="mission__text">
            <p class="mission__id">🔑 {{ mission.missionId }}번째 미션</p>
            <p>🔒 {{ mission.missionId - 1 }}번째 미션을 먼저 해결해주세요</p>
          </div>
        </div>

        <div v-else-if="mission.status === 'FINISHED'" class="mission__box">
          <div class="mission__text">
            <p class="mission__id">🔑 {{ mission.missionId }}번째 미션</p>
            <p>🔓 {{ mission.characters }}의 문제 해결 완료!</p>
          </div>
        </div>

        <div v-else class="mission__box tooltip">
          <div class="mission__text">
            <span class="tooltiptext">
              <br />✨설명 <br />{{ mission.next }}</span
            >
            <p class="mission__id">🔑 {{ mission.missionId }}번째 미션</p>
            <p class="mission__name" v-if="mission.characters === '단군'">
              <b>{{ mission.characters }}</b> : 고조선의 보물을 찾아라!
            </p>
            <p class="mission__name" v-if="mission.characters === '장수왕'">
              <b>{{ mission.characters }}</b> : 광개토대왕릉비가 도난당했다
            </p>
            <p class="mission__name" v-if="mission.characters === '선덕여왕'">
              <b>{{ mission.characters }}</b> : 금관을 잃어버린 여왕님
            </p>
            <p class="mission__name" v-if="mission.characters === '공민왕'">
              <b>{{ mission.characters }}</b> : 팔만대장경을 훔친 범인
            </p>
            <p class="mission__name" v-if="mission.characters === '세종대왕'">
              <b>{{ mission.characters }}</b> : 강아지도 말하고 싶어
            </p>
            <p class="mission__name" v-if="mission.characters === '이순신'">
              <b>{{ mission.characters }}</b> : 거북선이 없으면 조선이 위험해!
            </p>
            <p class="mission__name" v-if="mission.characters === '유관순'">
              <b>{{ mission.characters }}</b> : 태극기를 찾아서 천안으로
            </p>
            <p class="mission__name" v-if="mission.characters === '호랑이'">
              <b>{{ mission.characters }}</b
              >와 싸워 동의보감을 되찾아주세요!!
            </p>
          </div>
          <div class="mission__item">
            <p>✨보상 &nbsp; &nbsp;</p>
            <img
              :src="require('@/assets/item/' + mission.item + '.png')"
              alt=""
              class="item__image"
            />
          </div>
        </div>
      </div>
      <img
        class="exit__btn"
        @click="closeModal1()"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>
  </div>

  <!-- <MissionDetail
    @click="closeMissionDetail"
    v-if="missionDetail.missionDetail"
  /> -->
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
// import MissionDetail from './MissionDetail.vue'
import { ref, onMounted } from 'vue'

export default {
  // components: { MissionDetail },
  setup(props, { emit }) {
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

    function closeModal1() {
      emit('closeModal1')
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
      closeMissionDetail,
      closeModal1
    }
  }
}
</script>

<style scoped>
.mission__container {
  width: 100%;
  height: 100%;
  /* backdrop-filter: blur(4px); */
  z-index: 30;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
}

.myMission {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 40;
  top: 5%;
  left: 25%;
  width: 50%;
  height: 90%;
  background: rgba(169, 170, 150, 0.714);
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
  margin-bottom: 0.5vh;
  /* border: 1px solid white; */
  background-color: #ffffff;
  width: 65%;
  height: 7%;
  padding: 1vh;
  border-radius: 20px;
  box-shadow: 1px 1px 5px 1px rgb(195, 194, 194);
  /* display: flex;
  flex-direction: row; */
}

/* .mission__body:hover {
  cursor: pointer;
} */

.mission__box {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin: 0;
}

.mission__text {
  display: flex;
  flex-direction: column;
}

.mission__item {
  max-width: 30%;
  max-height: 7%;
  /* margin-bottom: 2vh; */
  margin-right: 5%;
  display: flex;
  flex-direction: row;
  align-items: center;
}
.mission__id {
  font-size: 0.8rem;
}

.item__image {
  width: 3vw;
}
.mission__box p {
  /* margin: auto; */
  padding-left: 2vw;
  margin-bottom: 0.5vw;
}

.exit__btn {
  width: 4vw;
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 4vh;
  right: 4vw;
  cursor: pointer;
}

.mission__now {
  background-color: yellow;
}

.mission__finished {
  filter: brightness(80%);
  background-color: rgb(171, 171, 171);
}

.mission__notyet {
  background-color: rgba(255, 255, 187, 0.881);
}

.tooltip {
  position: relative;
  cursor: pointer;
  /* display: inline-block; */
}

.tooltip .tooltiptext {
  visibility: hidden;
  width: 150px;
  height: 150px;
  background-color: rgba(255, 255, 255, 0.808);
  color: black;
  text-align: center;
  border-radius: 30px;
  padding: 7px 0;
  font-size: 0.8rem;

  /* Position the tooltip */
  position: absolute;
  z-index: 1;
  /* top: -200%; */
  bottom: -100%;
  left: -20%;
  margin-left: -5vw;
  transition: opacity 1s;
  line-height: 1.5rem;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}

.tooltip .tooltiptext::after {
  content: ' ';
  position: absolute;

  top: 50%;
  left: 100%;
  /* margin-left: -10px; */
  border-width: 10px;
  border-style: solid;
  border-color: transparent transparent transparent rgba(255, 255, 255, 0.808);
}
</style>
