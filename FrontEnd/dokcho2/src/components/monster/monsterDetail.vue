<template>
  <div class="monsterDetail">
    <h3>{{ this.monsterDetail.name }} ({{ this.monsterDetail.level }}레벨)</h3>
    <p>경험치 {{ this.monsterDetail.exp }}</p>
    <p>
      hp : {{ this.monsterDetail.hp }} attack : {{ this.monsterDetail.attack }}
    </p>
    <p>스킬 : {{ this.monsterDetail.skill }}</p>
    <br />
    <div>
      <button @click="setrepresentMonster()">대표 풀깨비로 설정</button>
      <button @click="this.$parent.closeMonster">닫기</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import Swal from 'sweetalert2'

export default {
  props: {
    monsterDetail: Object
  },
  data() {
    return {}
  },
  methods: {
    setrepresentMonster() {
      const id = this.monsterDetail.monsterId
      // console.log(id)
      axios({
        url: BASE_URL + '/api/v1/user/represent',
        method: 'PUT',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        },
        body: { id }
      })
        .then(() => {
          Swal('대표 풀깨비로 설정되었습니다!')
        })
        .catch((err) => {
          console.log(err)
        })
    }
  }
}
</script>

<style scoped>
.monsterDetail {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 30%;
  left: 30%;
  width: 30%;
  height: 30%;
  background: rgba(255, 255, 255, 0.9);
}

.p {
  size: 1vh;
}
</style>
