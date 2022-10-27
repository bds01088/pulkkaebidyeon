<template>
  <div class="background">
    <div class="signuppage">
      <div class="signuppage__left">
        <div class="termsofservice">
          <div class="termsofservice__text">이용약관</div>
        </div>
        <div class="agreement">
          <div class="checkbox__label">
            <label for="checkbox">약관에 동의하기</label>
          </div>
          <input
            id="checkbox"
            class="checkbox"
            type="checkbox"
            v-model="termsAgreed"
          />
        </div>
        <div class="checkbox__text">
          <span class="allowedtext" v-if="termsAgreed"
            >회원가입을 계속해서 진행해주세요😎</span
          >
          <span class="warningtext" v-else>약관에 동의해주세요🙏</span>
        </div>
      </div>
      <div class="signuppage__right">
        <div class="logo">
          <!-- <img class="logo__img" src="@/assets/dokcho_logo.png" alt="" /> -->
        </div>

        <div>
          <div class="oktext">
            <span>영문자나 숫자의 조합으로 5~20자리</span>
          </div>
          <input
            @keyup="checkUsername()"
            v-model="username"
            placeholder="아이디"
          />
          <div class="oktext">
            <span
              class="allowedtext"
              v-if="this.isUsernameChecked && !this.usernameDuplicate"
              >이 아이디는 사용하셔도 좋아요 👌</span
            >
            <span
              class="warningtext"
              v-else-if="this.isUsernameChecked && this.usernameDuplicate"
              >아이디가 중복인지 확인해주세요 🙏</span
            >
            <span class="warningtext" v-else
              >아이디 생성 조건을 확인해주세요 🙏</span
            >
          </div>
          <button
            class="duplicate__button"
            type="submit"
            @click="isUsernameDuplicate()"
          >
            아이디중복확인
          </button>
        </div>
        <div>
          <input @keyup="checkEmail()" v-model="email" placeholder="이메일" />
          <div class="oktext">
            <span
              class="allowedtext"
              v-if="this.isEmailChecked && !this.emailDuplicate"
              >이 이메일은 사용하셔도 좋아요 👌</span
            >
            <span
              class="warningtext"
              v-else-if="this.isEmailChecked && this.emailDuplicate"
              >이메일이 중복인지 확인해주세요 🙏</span
            >
            <span class="warningtext" v-else
              >이메일 입력 조건을 확인해주세요 🙏</span
            >
          </div>
          <button
            class="duplicate__button"
            type="submit"
            @click="isEmailDuplicate()"
          >
            이메일중복확인
          </button>
        </div>
        <div>
          <div class="oktext">
            <span>영문자+숫자+특수문자 조합으로 8~25자리</span>
          </div>
          <input
            @keyup="checkPassword()"
            v-model="password"
            type="password"
            placeholder="비밀번호"
          />
          <div class="oktext">
            <span class="allowedtext" v-if="this.isPasswordChecked"
              >이 비밀번호는 사용하셔도 좋아요 👌</span
            >
            <span class="warningtext" v-else
              >비밀번호 생성 조건을 확인해주세요 🙏</span
            >
          </div>
        </div>
        <div>
          <input
            @keyup.enter="signup()"
            v-model="password2"
            type="password"
            placeholder="비밀번호 확인"
          />
          <div class="oktext">
            <span class="warningtext" v-if="this.password !== this.password2"
              >비밀번호를 확인해주세요 🙏</span
            >
            <span class="warningtext" v-else-if="this.password == null"
              >비밀번호를 확인해주세요 🙏</span
            >
            <span class="allowedtext" v-else
              >비밀번호 확인이 완료되었습니다 👌</span
            >
          </div>
        </div>
        <div class="signup">
          <button class="cancel__btn" type="submit" @click="cancel()">
            취소
          </button>
          <button class="signup__btn" type="submit" @click="signup()">
            회원가입
          </button>
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

var usernameCheck = /^[a-zA-Z0-9]{5,20}$/
var passwordCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/
var emailCheck =
  /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/

export default {
  name: 'SignUpView',
  data() {
    return {
      email: this.email,
      password: this.password,
      password2: this.password2,
      username: this.username,
      emailDuplicate: true,
      usernameDuplicate: true,
      isEmailChecked: false,
      isUsernameChecked: false,
      isPasswordChecked: false,
      termsAgreed: false
    }
  },
  methods: {
    ...mapActions(['doRefreshToken', 'fetchUserInfo']),
    ...mapGetters(['isAccessTokenExpired']),
    checkUsername() {
      if (usernameCheck.test(this.username)) {
        this.isUsernameChecked = true
      } else {
        this.isUsernameChecked = false
      }
    },
    checkPassword() {
      if (passwordCheck.test(this.password)) {
        this.isPasswordChecked = true
      } else {
        this.isPasswordChecked = false
      }
    },
    checkEmail() {
      if (emailCheck.test(this.email)) {
        this.isEmailChecked = true
      } else {
        this.isEmailChecked = false
      }
    },
    isUsernameDuplicate() {
      axios
        .get(BASE_URL + '/api/v1/user/auth/check/username/' + this.username)
        .then((res) => {
          if (res.data === false) {
            this.usernameDuplicate = false
            swal({
              title: '사용 가능한 아이디입니다',
              text: '',
              icon: 'success',
              buttons: false,
              timer: 1500
            })
          } else {
            this.usernameDuplicate = true
            swal({
              title: '이미 존재하는 아이디입니다😥',
              text: '',
              icon: 'warning',
              buttons: false,
              timer: 1500
            })
          }
        })
        .catch((err) => {
          console.log(err)
        })
    },
    isEmailDuplicate() {
      if (!emailCheck.test(this.email)) {
        swal({
          title: '정확한 이메일 주소인지 확인해주세요!',
          text: '',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else {
        axios
          .get(BASE_URL + '/api/v1/user/auth/check/email/' + this.email, {
            email: this.email
          })
          .then((res) => {
            if (res.data === false) {
              this.emailDuplicate = false
              swal({
                title: '사용 가능한 이메일입니다',
                text: '',
                icon: 'success',
                buttons: false,
                timer: 1500
              })
            } else {
              this.emailDuplicate = true
              swal({
                title: '이미 존재하는 이메일입니다😥',
                text: '',
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
    login() {
      axios
        .post(
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
        .then((result) => {
          localStorage.setItem('accessToken', result.data.accessToken)
          localStorage.setItem('refreshToken', result.data.refreshToken)
          const option = {
            headers: {
              AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
            }
          }
          axios.get(BASE_URL + '/api/v1/user/myinfo', option).then((res) => {
            this.fetchUserInfo(res.data)
            if (res.data.nickname === '') {
              this.$router.replace({ name: 'setnickname' })
            } else {
              this.$router.replace({ name: 'main' })
            }
          })
        })
    },
    cancel() {
      this.$router.replace('/')
    },
    signup() {
      if (this.termsAgreed === false) {
        swal({
          title: '약관 동의가 필요합니다',
          text: '약관을 읽고 동의해 주세요',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (this.usernameDuplicate === true) {
        swal({
          title: '아이디 중복검사가 필요합니다',
          text: '아이디 중복검사를 진행해주세요',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (this.emailDuplicate === true) {
        swal({
          title: '이메일중복검사가 필요합니다',
          text: '이메일 중복검사를 진행해주세요',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (!passwordCheck.test(this.password)) {
        swal({
          title:
            '비밀번호는 영문자+숫자+특수문자 조합으로 8~25자리를 사용해야 해요',
          text: '',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (!usernameCheck.test(this.username)) {
        swal({
          title: '아이디는 영문자나 숫자의 조합으로 5~20자리를 사용해야 해요',
          text: '',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (!emailCheck.test(this.email)) {
        swal({
          title: '이메일이 일치하지않습니다정확한 이메일 주소인지 확인해주세요',
          text: '정확한 이메일 주소인지 확인해주세요',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else if (this.password === this.password2) {
        axios
          .post(BASE_URL + '/api/v1/user/auth/signup', {
            email: this.email,
            nickname: this.nickname,
            password: this.password,
            region: this.region,
            username: this.username
          })
          .then((res) => {
            swal({
              title: '회원가입을 축하드립니다!',
              text: `${res}`,
              icon: 'success',
              buttons: false,
              timer: 1500
            })
            this.login()
          })
          .catch((err) => {
            console.log(err)
          })
      } else {
        return swal({
          title: '비밀번호가 일치하지 않아요😥',
          text: '',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      }
    }
  }
  // watch: {
  //   username(newUsername) {
  //     this.usernameDuplicate = true
  //   },
  //   email(newEmail) {
  //     this.emailDuplicate = true
  //   }
  // }
}
</script>
