<template>
  <div>
    <div>방이름{{ roomName }} 방번호{{ nowRoom }}</div>
    <div>
      유저목록 {{ nowRoomUser }}
      <li v-for="user in nowRoomUser" v-bind:key="user">
        {{ user.nickname }}
      </li>
    </div>
  </div>
</template>

<script>
export default {
  name: 'QuizRoomCanvas',
  props: {
    nowRoom: Number,
    roomName: String,
    nowRoomUser: Array,
    QuizRoomEntered: Boolean
  },
  setup() {}
}
</script>

<style></style>
