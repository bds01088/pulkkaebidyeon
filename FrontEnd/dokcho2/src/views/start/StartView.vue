<template>
  <div class="startpage">
          <img
        class="logo__img"
        src="../../assets/logo.png"
        alt="logo"
      />
    <div class="loginpage">
      <div class="login__form">
         <input v-model="username" placeholder="아이디를 입력하세요" />
        <input
          @keyup.enter="login()"
          v-model="password"
          type="password"
          placeholder="비밀번호를 입력하세요"
        />
        <a class="findpassword__a" href="#" @click="findpassword()">비밀번호를 잊으셨나요?</a>
      </div>
      <div class="login__button">
          <button class="login__btn" @click="login()">로그인</button>
                    <img
            class="kakaologin__btn"
            @click="kakaoLogin()"
            src="@/assets/kakao_login_medium_wide.png"
            alt=""
          />
        </div>
        
      </div>
                <div class="other__btn">
            <img class="howto__btn" @click="howtoGame()" src="../../assets/game.png" alt="" />
            <img class="signup__btn" @click="signUp()" src="../../assets/join.png" alt="" />
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
    howtoGame(){

    },
    async login() {
      console.log(this.username)

      try {
        const result = await axios.post(
          BASE_URL + '/api/v1/user/auth/login',
          {
            username: this.username,
            password: this.password
          },
          {
            headers: {
              'Content-Type': 'application/json'
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

<style scoped>

.startpage {
  background-image: linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5) ),url("../../assets/startimg.png");
  background-size: cover;
  width: 100%;
  height: 100%;
  
}
input {
  display: block;
  width: 20vw;
  height: 7vh;
  margin: 8px 0 8px 0;
  padding: 10px 15px 10px 25px;
  font-size: 16px;
  border: #ececec solid 2px;
  border-radius: 20px;
}

input::placeholder {
  color: #467302;
}

input:focus {
  outline: none;
  border: #467302 solid 2px;
}
.loginpage{
  display: flex;
  flex-direction: row;
  margin: auto;
  height: 10vh;
  justify-content: center;
}

.login__form{
  display: flex;
  flex-direction: column;
}
.logo__img{
  display: block;
  margin: auto;
  padding-top: 10vh;
  width: 70vw;
}

.login__button{
margin: 1vw;
  display: flex;
  flex-direction : column
}

.other__btn{
display: flex;
flex-direction: row;
justify-content: center;
margin-top : 10vmin
}

.howto__btn, .signup__btn{
  width: 15%;
  margin-top: 8%;
  margin-left: 2%;
  margin-bottom: 8%;
}

.howto__btn:hover, .signup__btn:hover {
  cursor: pointer;
}

.findpassword__a{
  color: white;
  text-decoration: none;
  font-size: 1.5vh;
}

.login__btn{
  height: 5vmin;
  border-radius: 50px;
  border: none;
  width: 40%;
  margin-bottom: 1vmin;
}

</style>
