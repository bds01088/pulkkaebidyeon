<template>
  <div>
    <div>방이름{{ roomName }} 방번호{{ nowRoom }}</div>
    <div>
      유저목록 {{ nowRoomUser }}
      <li v-for="user in nowRoomUser" v-bind:key="user">
        {{ user.nickname }}
      </li>
    </div>
    <button @click="leaveRoom()">방나가기</button>
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
  setup(props, { emit }) {
    function leaveRoom() {
      emit('leaveRoom')
    }
    return {
      leaveRoom
    }
  }
}
</script>

<style></style>
