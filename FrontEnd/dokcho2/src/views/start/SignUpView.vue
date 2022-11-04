<template>
  <div class="background">
    <div class="signuppage">
      <div class="signuppage__left">
        <div class="termsofservice">
          <div class="termsofservice__text">
            제 1 장 총 칙<br />제 1 조 (목적)<br />이 약관은 {독초도감}(이하
            "사이트"라 합니다)에서 제공하는 인터넷서비스(이하 "서비스"라
            합니다)의 이용 조건 및 절차에 관한 기본적인 사항을 규정함을 목적으로
            합니다.<br />제 2조 (약관의 효력 및 변경)<br />① 이 약관은 서비스
            화면이나 기타의 방법으로 이용고객에게 공지함으로써 효력을
            발생합니다.<br />② 사이트는 이 약관의 내용을 변경할 수 있으며,
            변경된 약관은 제1항과 같은 방법으로 공지 또는 통지함으로써 효력을
            발생합니다.<br />제 3 조 (용어의 정의) 이 약관에서 사용하는 용어의
            정의는 다음과 같습니다.<br />① 회원 : 사이트와 서비스 이용계약을
            체결하거나 이용자 아이디(ID)를 부여받은 개인 또는 단체를
            말합니다.<br />
          </div>
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
          <!-- <span class="allowedtext" v-if="termsAgreed"
            >회원가입을 계속해서 진행해주세요😎</span
          > -->
          <span class="warningtext" v-if="!termsAgreed"
            >약관 동의가 필요합니다.</span
          >
        </div>
      </div>
      <div class="signuppage__right">
        <div class="logo">
          <!-- <img class="logo__img" src="@/assets/dokcho_logo.png" alt="" /> -->
        </div>
        <div class="oktext">
          <span>아이디 : 영문자나 숫자의 조합으로 5~20자리</span>
        </div>
        <div class="username__input">
          <div class="usr__ipt">
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
                >아이디가 중복인지 확인해주세요!</span
              >
              <span
                class="warningtext"
                v-else-if="!this.isUsernameChecked && !this.usernameDuplicate"
                >아이디 생성 조건을 확인해주세요 🙏</span
              >
              <span
                class="warningtext"
                v-else-if="this.username !== undefined && this.username !== ''"
                >아이디 생성 조건을 확인해주세요</span
              >
            </div>
          </div>

          <div class="btn">
            <button
              class="duplicate__button"
              type="submit"
              @click="isUsernameDuplicate()"
            >
              아이디중복확인
            </button>
          </div>
        </div>
        <div class="email__input">
          <div class="email__ipt">
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
                >이메일 중복확인을 해주세요!
              </span>
              <span
                class="warningtext"
                v-else-if="!this.isEmailChecked && !this.emailDuplicate"
                >이메일 양식에 맞게 작성해주세요!</span
              >
              <span
                class="warningtext"
                v-else-if="this.email !== undefined && this.email !== ''"
                >이메일 양식에 맞게 작성해주세요!</span
              >
            </div>
          </div>

          <div class="btn">
            <button
              class="duplicate__button"
              type="submit"
              @click="isEmailDuplicate()"
            >
              이메일중복확인
            </button>
          </div>
        </div>
        <br />
        <div>
          <div class="oktext">
            <span>비밀번호 : 영문자+숫자+특수문자 조합으로 8~25자리</span>
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
            <span
              class="warningtext"
              v-else-if="
                !this.isPasswordChecked &&
                this.password !== undefined &&
                this.password !== ''
              "
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
            <span
              class="warningtext"
              v-if="
                this.password !== this.password2 &&
                this.password2 !== undefined &&
                this.password2 !== ''
              "
              >비밀번호를 확인해주세요 🙏</span
            >
            <span
              class="allowedtext"
              v-else-if="this.password === this.password2"
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
          .then(() => {
            swal({
              title: '회원가입을 축하드립니다!',
              text: '   ',
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

<style scoped>
button {
  height: 4vh;
  border-radius: 50px;
  border: none;
  width: 10vw;
  margin: 10px;
  transition: 0.3s;
}
.duplicate__button:hover {
  background-color: #467302;
  color: white;
}
.background {
  height: 100vh;
  overflow: hidden;
  margin: 0;
  /* background-image: url('@/assets/game_background.png'); */
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.signuppage {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-color: white;
}
.signuppage__left {
  margin-left: 20px;
  margin-right: 30px;
}
.signuppage__right {
  margin-right: 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.logo {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.logo__img {
  width: 15vw;
}
.signup {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.signup__btn {
  background-color: #a7c957;
  transition: 0.3s;
  height: 5vh;
}
.signup__btn:hover {
  background-color: #467302;
  color: white;
}
.cancel__btn {
  background-color: #bfbfbf;
  transition: 0.3s;
  height: 5vh;
}
.cancel__btn:hover {
  background-color: #ff4444;
  color: white;
}

.username__input,
.email__input {
  display: flex;
  flex-direction: row;
}

.usr__ipt {
  display: flex;
  flex-direction: column;
}

.email__ipt {
  display: flex;
  flex-direction: column;
}
.btn {
  display: flex;
  align-items: center;
}
.duplicate__button {
  /* display: table-cell; */
  height: 5vh;
  text-align: center;
  vertical-align: middle;
}
.username__input input {
  width: 20vw;
}

.email__input input {
  width: 20vw;
}

input {
  display: block;
  width: 30vw;
  height: 7vh;
  margin: 8px 0 8px 0;
  padding: 10px 15px 10px 25px;
  font-size: 16px;
  border: #ececec solid 2px;
  border-radius: 20px;
}
.termsofservice {
  width: 50vw;
  height: 30vw;
  margin: 20px;
  overflow: auto;
  background-image: url('@/assets/hanji.jpeg');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
  border-radius: 50px;
}
.termsofservice__text {
  margin: 4vh;
  height: 40vh;
  flex-direction: column;
  justify-content: center;
}

.checkbox {
  width: 2vw;
  margin: 0;
  margin-left: 0.5vw;
  height: 3vh;
}
.checkbox__label {
  display: flex;
  flex-direction: row;
  justify-content: right;
  text-align: center;
  align-items: center;
}

.agreement {
  display: flex;
  flex-direction: row;
  justify-content: right;
  text-align: center;
  margin-right: 3vw;
}
.checkbox__text {
  display: flex;
  flex-direction: row;
  justify-content: right;
  text-align: center;
  margin-top: 1vh;
  margin-right: 3vw;
}
.allowedtext {
  color: #29cd2e;
}
.warningtext {
  color: #be0000;
}

@media screen and (max-width: 850px) {
  .background {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .signuppage {
    overflow: auto;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 90vw;
    height: 95%;
    background-color: white;
    border-radius: 40px;
  }
  .signuppage__left {
    margin-left: 5vw;
    margin-right: 5vw;
    margin-top: 35vh;
  }
  .termsofservice {
    width: 75vw;
    height: 30vh;
    margin: 5vw;
    margin-top: 10vh;
    margin-bottom: 0;
    /* background-image: url('@/assets/hanji.jpeg'); */
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    border-radius: 50px;
  }
  .termsofservice__text {
    overflow: auto;
    height: 35vh;
    margin: 5vw;
    flex-direction: column;
    justify-content: center;
    text-align: center;
  }
  .checkbox {
    width: 6vw;
    margin: 0;
    margin-left: 0.5vw;
    height: 3vh;
  }
  .checkbox__label {
    display: flex;
    flex-direction: row;
    justify-content: right;
    text-align: center;
    align-items: center;
    margin-right: 2vw;
  }

  .agreement {
    display: flex;
    flex-direction: row;
    justify-content: right;
    text-align: center;
    margin-top: 1vh;
    margin-right: 5vw;
  }
  .checkbox__text {
    display: flex;
    flex-direction: row;
    justify-content: right;
    text-align: center;
    margin-top: 1vh;
    margin-right: 5vw;
  }

  .signuppage__right {
    margin-left: 5vw;
    margin-right: 5vw;
    width: 80vw;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .logo__img {
    width: 60vw;
  }
  input {
    width: 80vw;
    height: 7vh;
    font-size: 1.5vh;
    background-size: 3vw 3vw;
    padding-left: 4vw;
  }
  .oktext {
    margin-left: 3vw;
  }
  button {
    height: 5vh;
    border-radius: 50px;
    border: none;
    width: 35vw;
    margin-left: 0;
    margin-right: 0;
    margin-top: 1vh;
    margin-bottom: 1vh;
  }
  .signup__btn {
    background-color: #a7c957;
    transition: 0.3s;
    height: 6vh;
    margin-left: 2vw;
  }
  .cancel__btn {
    background-color: #bfbfbf;
    transition: 0.3s;
    height: 6vh;
    margin-right: 2vw;
  }
}
</style>
