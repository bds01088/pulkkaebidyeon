<template>
  <div>
    <nav class="navbar">
      <div>
        <ul>
          <li>
            <div class="navbar__item">
              <p>미션</p>
              <img @click="openModal1" src="@/assets/navbar/004.png" alt="" />
            </div>
          </li>

          <li>
            <div class="navbar__item">
              <p>아이템</p>
              <img @click="openModal2" src="@/assets/navbar/005.png" alt="" />
            </div>
          </li>
          <li>
            <div class="navbar__item">
              <p>지도</p>
              <img @click="openModal3" src="@/assets/navbar/006.png" alt="" />
            </div>
          </li>
          <li>
            <div class="navbar__item">
              <p>로그아웃</p>
              <img @click="logout" src="@/assets/navbar/007.png" alt="" />
            </div>
          </li>
        </ul>
      </div>
    </nav>
    <MyModal1 v-if="modal1"> </MyModal1>
    <MyModal2 v-if="modal2"> </MyModal2>
    <MyModal3 v-if="modal3"> </MyModal3>
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
  z-index: 9999;
  width: 8vw;
  margin: 0;
  top: 5%;
  left: 90%;
}

img {
  width: 40%;
  margin-bottom: 1.5vh;
}

p {
  font-size: 0.8rem;
  margin-bottom: 0.5vh;
}

ul {
  list-style: none;
  padding-left: 0px;
}

.navbar__item {
  text-align: center;
}
</style>
