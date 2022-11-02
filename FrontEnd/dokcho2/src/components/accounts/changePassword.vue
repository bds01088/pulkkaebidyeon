<template>
  <div>
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
        >이 비밀번호는 사용하셔도 좋아요👌</span
      >
      <span class="warningtext" v-else
        >비밀번호 생성 조건을 확인해주세요🙏</span
      >
      <br />
      <input
        v-model="newPassword2"
        type="password"
        placeholder="새 비밀번호 확인"
      />
      <span class="warningtext" v-if="this.newPassword !== this.newPassword2"
        >비밀번호를 확인해주세요🙏</span
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
export default {}
</script>

<style></style>
