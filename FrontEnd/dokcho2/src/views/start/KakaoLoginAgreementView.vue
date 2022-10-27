<template>
  <div class="background">
    <div class="signuppage">
      <div class="signuppage__left">
        <div class="termsofservice">
          <div class="termsofservice__text">이용 약관</div>
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
import { BASE_URL } from '@/constant/BASE_URL'
import swal from 'sweetalert'

export default {
  name: 'KakaoLoginAgreementView',
  data() {
    return {
      termsAgreed: false,
      kakaoLoginURL: BASE_URL + '/oauth2/authorization/kakao'
    }
  },
  methods: {
    cancel() {
      this.$router.replace('/')
    },
    signup() {
      if (this.termsAgreed === false) {
        swal({
          title: '약관 동의를 먼저 진행해주세요🙏',
          text: '🐯',
          icon: 'warning',
          buttons: false,
          timer: 1500
        })
      } else {
        if (JSON.parse(localStorage.getItem('userInfo')).newbie) {
          this.$router.replace({ name: 'setnickname' })
        } else {
          this.$router.replace({ name: 'main' })
        }
      }
    }
  }
}
</script>
