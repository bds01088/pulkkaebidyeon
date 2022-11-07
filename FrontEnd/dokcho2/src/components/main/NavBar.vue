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
    <MyModal1 v-if="modal1.modal1" @closeModal1="closeModal1" />
    <MyModal2 v-if="modal2.modal2" @closeModal2="closeModal2" />
    <MyModal3 v-if="modal3.modal3" @closeModal3="closeModal3" />
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
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const swalWithBootstrapButtons = Swal.mixin({
  customClass: {
    title: 'custom-title-class',
    confirmButton: 'btn btn-success',
    cancelButton: 'btn btn-danger'
  }
})
export default {
  components: { MyModal1: MyModal1, MyModal2: MyModal2, MyModal3: MyModal3 },
  setup(props, { emit }) {
    const router = useRouter()

    const modal1 = ref({ modal1: false })
    const modal2 = ref({ modal2: false })
    const modal3 = ref({ modal3: false })
    const message1 = ref({ message1: '' })
    const message2 = ref({ message2: '' })
    const message3 = ref({ message3: '' })

    function openModal1() {
      modal1.value.modal1 = true
      emit('changeNavbar')
    }
    function closeModal1() {
      console.log('닫음')
      modal1.value.modal1 = false
      emit('changeNavbar')
    }
    function openModal2() {
      modal2.value.modal2 = true
      emit('changeNavbar')
    }
    function closeModal2() {
      modal2.value.modal2 = false
      emit('changeNavbar')
    }
    function openModal3() {
      modal3.value.modal3 = true
      emit('changeNavbar')
    }
    function closeModal3() {
      modal3.value.modal3 = false
      emit('changeNavbar')
    }
    function logout() {
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
            fetchLogout()
          }
        })
    }
    function fetchLogout() {
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
          router.push({
            path: '/'
          })
        })
        .catch((err) => {
          console.log(err)
        })
    }

    return {
      modal1,
      modal2,
      modal3,
      message1,
      message2,
      message3,
      openModal1,
      closeModal1,
      openModal2,
      closeModal2,
      openModal3,
      closeModal3,
      logout,
      fetchLogout
    }
  }
}
</script>

<style scoped>
.navbar {
  position: absolute;
  z-index: 10;
  width: 8vw;
  margin: 0;
  top: 5%;
  left: 90%;
}

img {
  width: 40%;
  margin-bottom: 1.5vh;
  cursor: pointer;
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
