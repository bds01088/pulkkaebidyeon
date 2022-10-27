<template>
  <div class="background">
    <div class="loginpage">
      <!-- <img
        class="logo__img"
        src="https://yt3.ggpht.com/ytc/AMLnZu8SkLy7ITHxlvAZAMnH3KfJj9taeckkzgOIJmfH=s900-c-k-c0x00ffffff-no-rj"
        alt="logo"
      /> -->
      <div class="loginpage__right">
        <input v-model="username" placeholder="아이디를 입력하세요" />
        <input
          @keyup.enter="login()"
          v-model="password"
          type="password"
          placeholder="비밀번호를 입력하세요"
        />
        <div class="loginpage__btn">
          <button class="login__btn" @click="login()">로그인</button>
        </div>

        <div class="loginpage__btn">
          <img
            class="kakaologin__btn"
            @click="kakaoLogin()"
            src="@/assets/kakao_login_medium_wide.png"
            alt=""
          />
        </div>
        <div class="loginpage__btn">
          <div class="signfind">
            <button class="findpassword__btn" @click="findpassword()">
              비밀번호 찾기
            </button>
            <button class="findpassword__btn" @click="signUp()">
              회원가입
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { mapActions, mapGetters } from 'vuex'
import swal from 'sweetalert'

export default {
  name: 'StartView',
  data() {
    return {
      username: '',
      password: '',
      kakaoLoginURL: BASE_URL + '/oauth2/authorization/kakao'
    }
  },
  methods: {
    ...mapActions(['doRefreshToken', 'fetchUserInfo', 'fetchUserDeck']),
    ...mapGetters(['isAccessTokenExpired']),
    kakaoLogin() {
      window.location.href = this.kakaoLoginURL
    },
    findpassword() {
      this.$router.push({ name: 'findpassword' })
    },
    signUp() {
      this.$router.push({ name: 'signup' })
    },
    async login() {
      try {
        const result = await axios.post(
          BASE_URL + '/api/v1/user/auth/login',
          {
            username: this.username,
            password: this.password
          },
          {
            headers: {
              'Content-type': 'application/json'
            }
          }
        )
        if (result.status === 200) {
          localStorage.setItem('accessToken', result.data.accessToken)
          localStorage.setItem('refreshToken', result.data.refreshToken)
          const option = {
            headers: {
              AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
            }
          }
          await axios
            .get(BASE_URL + '/api/v1/user/myinfo', option)
            .then((res) => {
              this.fetchUserInfo(res.data)
            })
          await this.$router.replace({ name: 'main' })
        }
      } catch (err) {
        swal({
          title: '로그인에 실패하였습니다',
          text: '아이디나 비밀번호를 확인해주세요!',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      }
    }
  }
}
</script>
