<template>
  <div class="myPage">
    <h1>{{ this.userInfo.nickname }}님!</h1>
    <br />
    <p>대표 독초몬 : {{ this.monsterDetail.name }}</p>
    <p>이메일 : {{ this.userInfo.email }}</p>
    <p>가입일 : {{ this.userInfo.createDate }}</p>
    <br />
    <div>
      <button @click="openPassword()">비밀번호변경</button>
      <button @click="deleteUser()">회원 탈퇴</button>
    </div>

    <changePassword v-if="password"></changePassword>
    <br />
    <button @click="$emit('mypageClose')">닫기</button>
  </div>
</template>

<script>
import swal from 'sweetalert'
import Swal from 'sweetalert2'

import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import changePassword from '../accounts/changePassword.vue'

const swalWithBootstrapButtons = Swal.mixin({
  customClass: {
    title: 'custom-title-class',
    confirmButton: 'btn btn-success',
    cancelButton: 'btn btn-danger'
  }
})

var passwordCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/

export default {
  components: { changePassword },
  data() {
    return {
      showMenu: false,
      isNone: false,
      userInfo: JSON.parse(localStorage.getItem('userInfo')),
      oldPassword: this.oldPassword,
      newPassword: this.newPassword,
      newPassword2: this.newPassword2,
      isPasswordChecked: false,
      today: '',
      cdate: '',
      password: false,
      monsterDetail: {}
    }
  },
  methods: {
    openPassword() {
      this.password = true
    },
    closePassword() {
      this.password = false
    },
    overflow(value) {
      this.showMenu = value
    },
    displayNone() {
      this.isNone = !this.isNone
    },
    checkPassword() {
      if (passwordCheck.test(this.newPassword)) {
        this.isPasswordChecked = true
      } else {
        this.isPasswordChecked = false
      }
    },
    changePassword() {
      if (!passwordCheck.test(this.newPassword)) {
        swal({
          title:
            '비밀번호는 영문자+숫자+특수문자 조합으로 8~25자리를 사용해야해요🙏',
          icon: 'error',
          text: '🤔',
          buttons: false,
          timer: 2000
        })
      } else if (this.newPassword === this.newPassword2) {
        axios
          .put(
            BASE_URL + '/api/v1/user/password/',
            {
              newPW: this.newPassword,
              nowPW: this.oldPassword
            },
            {
              headers: {
                'Content-type': 'application/json',
                AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
              }
            }
          )
          .then(() => {
            swal({
              title: '비밀번호가 변경되었습니다!😘',
              icon: 'success',
              text: '바뀐 비밀번호로 로그인 해주세요😉',
              buttons: false,
              timer: 1500
            })
          })
          .catch((err) => {
            console.log(err)
            swal({
              title: '현재 비밀번호를 확인해주세요😥',
              icon: 'warning',
              text: '입력해주신 비밀번호와 현재 비밀번호가 다른 것 같아요😅',
              buttons: false,
              timer: 1500
            })
          })
      } else {
        swal({
          title: '새 비밀번호를 한번 더 확인해 주세요😢',
          icon: 'error',
          text: '두 비밀번호가 다른 것 같아요..😅',
          buttons: false,
          timer: 1500
        })
      }
    },
    deleteUser() {
      swalWithBootstrapButtons
        .fire({
          title: '호랑이섬에서 떠나시겠어요?',
          text: `${this.userInfo.nickname}님이 없으면 우리의 역사가 위험해요 😥`,
          icon: 'question',
          showCancelButton: true,
          confirmButtonText: '예',
          cancelButtonText: '아니오',
          reverseButtons: true
        })
        .then((res) => {
          if (res.value) {
            this.fetchDeleteUser()
          }
        })
    },
    fetchDeleteUser() {
      axios
        .delete(BASE_URL + '/api/v1/user/', {
          headers: {
            'Content-type': 'application/json',
            AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
          }
        })
        .then(() => {
          swal({
            title: '탈퇴가 완료되었어요😭',
            icon: 'success',
            text: '악당 호랑이를 물리치러 언제든지 돌아오세요!',
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
    },
    fetchrepresentMonster() {
      const id = this.userInfo.representMonster
      axios({
        url: BASE_URL + '/api/v1/monster/' + id,
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          this.monsterDetail = res.data
        })
        .catch((err) => {
          console.log(err)
        })
    }
  },
  created() {
    this.fetchrepresentMonster()
    this.today = new Date()
    this.cdate = new Date(this.userInfo.createDate)
  }
}
</script>

<style scoped>
.myPage {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 25%;
  left: 25%;
  width: 50%;
  height: 70%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(4px);
}
</style>
