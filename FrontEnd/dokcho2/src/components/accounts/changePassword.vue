<template>
  <div class="changePw_container">
    <div class="changePw__inputs">
      <input
        v-model="oldPassword"
        type="password"
        placeholder="현재 비밀번호"
      />
      <br />
      <span>비밀번호 : 영문자+숫자+특수문자 조합으로 8~25자리</span>
      <br />
      <input
        @keyup="checkPassword()"
        v-model="newPassword"
        type="password"
        placeholder="새 비밀번호"
      />
      <span class="allowedtext" v-if="this.isPasswordChecked"
        >이 비밀번호는 사용하셔도 좋아요</span
      >
      <span
        class="warningtext"
        v-else-if="!this.isPasswordChecked && this.newPassword !== undefined"
        >비밀번호 생성 조건을 확인해주세요</span
      >
      <br />
      <input
        v-model="newPassword2"
        type="password"
        placeholder="새 비밀번호 확인"
      />
      <span
        class="warningtext"
        v-if="
          this.newPassword !== this.newPassword2 &&
          this.newPassword2 !== undefined
        "
        >비밀번호를 확인해주세요</span
      >
    </div>
    <div class="changePw__btn">
      <button @click="this.$parent.closePassword" class="cancel__btn">
        취소
      </button>
      <button @click="this.changePassword()" class="complete__btn">
        수정 완료
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import swal from 'sweetalert'

var passwordCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/

export default {
  data() {
    return {
      oldPassword: this.oldPassword,
      newPassword: this.newPassword,
      newPassword2: this.newPassword2,
      isPasswordChecked: false,
      today: '',
      cdate: '',
      password: false
    }
  },
  methods: {
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
            '비밀번호는 영문자+숫자+특수문자 조합으로 8~25자리를 사용해야해요',
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
                'Content-Type': 'application/json',
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
            this.$parent.closePassword()
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
    }
  }
}
</script>

<style>
.changePw_container{
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
</style>
