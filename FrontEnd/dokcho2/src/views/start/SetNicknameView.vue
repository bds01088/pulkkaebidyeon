<template>
  <div class="background">
    <div class="setnicknamepage">
      <!-- <img class="setnicknamepage__img" src="@/assets/dokcho_logo.png" alt="" /> -->
      <div class="setnicknamepage__text">
        풀깨비뎐에 새겨질 당신의 이름을 알려주세요 🐯
      </div>

      <div>한글이나 영문자, 숫자의 조합으로 1~4자리</div>
      <input v-model="nickname" placeholder="닉네임" />

      <div class="setnicknamepage__button">
        <button
          class="setnickname__button"
          type="submit"
          @click="isNicknameDuplicate()"
        >
          중복확인
        </button>

        <button class="login__button" type="submit" @click="setnickname()">
          완료
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { mapActions } from 'vuex'
import swal from 'sweetalert'

var nicknameCheck = /^[가-힣a-zA-Z0-9]{1,4}$/

export default {
  name: 'SetNicknameView',
  data() {
    return {
      nickname: this.nickname,
      nicknameDuplicate: true
    }
  },
  methods: {
    ...mapActions(['fetchnowUserInfo']),
    isNicknameDuplicate() {
      if (!nicknameCheck.test(this.nickname)) {
        swal({
          title:
            '닉네임은 한글이나 영문자, 숫자의 조합으로 1~4자리를 사용해야 해요🙏',
          text: '🐯',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else {
        axios
          .get(BASE_URL + '/api/v1/user/auth/check/nickname/' + this.nickname, {
            nickname: this.nickname
          })
          .then((res) => {
            if (res.data === false) {
              this.nicknameDuplicate = false

              swal({
                title: '이 닉네임은 사용하셔도 좋아용😎',
                text: '🐯',
                icon: 'success',
                buttons: false,
                timer: 1500
              })
            } else {
              this.nicknameDuplicate = true
              swal({
                title: '이미 존재하는 닉네임입니다😥',
                text: '🐯',
                icon: 'warning',
                buttons: false,
                timer: 1500
              })
            }
          })
          .catch((err) => {
            console.log(err)
          })
      }
    },
    setnickname() {
      if (this.nicknameDuplicate === true) {
        swal({
          title: '잠깐! 🚨',
          text: '닉네임 중복 검사를 먼저 진행해주세요.',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (!nicknameCheck.test(this.nickname)) {
        swal({
          title:
            '닉네임은 한글이나 영문자, 숫자의 조합으로 1~4자리를 사용해야 해요🙏',
          text: '🐯',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else {
        const option = {
          headers: {
            AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
          }
        }
        axios
          .put(
            BASE_URL + '/api/v1/user/set/nickname?nickname=' + this.nickname,
            null,
            option
          )
          .then(() => {
            this.fetchnowUserInfo()
            swal({
              title: this.nickname + '님, 환영합니다!🥰',
              text: '풀깨비와 함께 섬을 탐험해보세요!',
              icon: 'success',
              buttons: false,
              timer: 1500
            })
            this.$router.push({ name: 'startingcard' })
          })
      }
    }
  }
}
</script>
