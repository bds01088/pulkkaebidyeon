<template>
  <div>
    <nav class="navbar">
      <div>
        <ul>
          <li>
            <a @click="openModal1">
              <p class="TITLE">미 션</p>
              <font-awesome-icon icon="fa-solid fa-scroll" size="xl" />
            </a>
          </li>

          <li>
            <a @click="openModal2">
              <p class="TITLE">가 방</p>
              <font-awesome-icon icon="fa-solid fa-suitcase" size="xl" />
            </a>
          </li>
          <li>
            <a @click="openModal3">
              <p class="TITLE">지 도</p>
              <font-awesome-icon icon="map-location-dot" size="xl" />
            </a>
          </li>
          <li>
            <a @click="logout">
              <p class="TITLE">록 앗</p>
              <font-awesome-icon
                icon="fa-solid fa-right-from-bracket"
                size="xl"
              />
            </a>
          </li>
        </ul>
      </div>
    </nav>
    <MyModal1 @click="closeModal1" v-if="modal1">
      <p>미션창</p>
      <div><input v-model="message1" /></div>
    </MyModal1>
    <MyModal2 @click="closeModal2" v-if="modal2">
      <p>가방창</p>
      <div><input v-model="message2" /></div>
    </MyModal2>
    <MyModal3 @click="closeModal3" v-if="modal3">
      <p>지도창</p>
      <div><input v-model="message3" /></div>
    </MyModal3>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import MyModal1 from './MyMission.vue'
import MyModal2 from './MyItem.vue'
import MyModal3 from './MyMap.vue'
import swal from 'sweetalert'
import Swal from 'sweetalert2'
const swalWithBootstrapButtons = Swal.mixin({
  customClass: {
    title: 'custom-title-class',
    confirmButton: 'btn btn-success',
    cancelButton: 'btn btn-danger'
  }
})
export default {
  data() {
    return {
      modal1: false,
      modal2: false,
      modal3: false,
      message1: '',
      message2: '',
      message3: ''
    }
  },
  components: { MyModal1, MyModal2, MyModal3 },
  methods: {
    openModal1() {
      this.modal1 = true
    },
    closeModal1() {
      this.modal1 = false
    },
    openModal2() {
      this.modal2 = true
    },
    closeModal2() {
      this.modal2 = false
    },
    openModal3() {
      this.modal3 = true
    },
    closeModal3() {
      this.modal3 = false
    },
    logout() {
      swalWithBootstrapButtons
        .fire({
          title: '도감을 덮으시겠어요?',
          text: '풀깨비들이 도감에서 웅성거리고 있어요 😥',
          icon: 'question',
          showCancelButton: true,
          confirmButtonText: '예',
          cancelButtonText: '아니오',
          reverseButtons: true
        })
        .then((res) => {
          if (res.value) {
            this.fetchLogout()
          }
        })
    },
    fetchLogout() {
      axios
        .put(BASE_URL + '/api/v1/user/logout', null, {
          headers: {
            AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
          }
        })
        .then((res) => {
          console.log(res)
          swal({
            title: '로그아웃이 완료되었습니다!',
            text: ' 다시 도감을 펼치는 날을 기다릴게요 🌻 ',
            icon: 'success',
            buttons: false,
            timer: 1500
          })
          localStorage.clear()
          this.$router.push({
            path: '/'
          })
        })
        .catch((err) => {
          console.log(err)
        })
    }
  }
}
</script>

<style scoped>
.navbar {
  position: absolute;
  /* z-index: -9; */
  margin-left: 500px;
  margin-top: 20px;
}
</style>
>
