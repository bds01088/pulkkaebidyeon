<template>
  <div class="talk">
    <div class="talk__box">
      <div class="box" v-if="talk.content.line">
        <div class="name">{{ this.name }}</div>
        <div class="content">
          {{ talk.content.line[talk.nowPage] }}
        </div>
        <button
          @click="nextTalk()"
          v-if="talk.content.line.length !== talk.nowPage + 1"
        >
          다음
        </button>
        <button @click="endTalk()" v-else>나가기</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { onMounted } from '@vue/runtime-core'
import { ref } from 'vue'

export default {
  props: {
    name: String
  },
  setup(props, { emit }) {
    let talk = ref({ content: {}, nowPage: 0 })

    function getLine() {
      axios({
        url: BASE_URL + '/api/v1/mission/' + props.name,
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          console.log(res.data)
          talk.value.content = res.data
          talk.value.content.line = res.data.line.split('\\t')
        })
        .catch((err) => console.log(err))
    }

    function endTalk() {
      const content = talk.value.content
      const userInfo = JSON.parse(localStorage.getItem('userInfo'))
      console.log(content, userInfo)
      if (content.status !== 'STARTED') {
        if (userInfo.nowMissionId === content.missionId) {
          axios({
            url:
              BASE_URL +
              '/api/v1/mission/' +
              userInfo.nowMissionId +
              '?nowStatus=' +
              content.status,
            method: 'PUT',
            headers: {
              AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
            }
          }).then(() => emit('talkClose'))
        }
      } else {
        emit('quizStart')
      }
    }

    function nextTalk() {
      talk.value.nowPage += 1
    }

    onMounted(() => getLine())

    return {
      talk,
      endTalk,
      nextTalk
    }
  }
}
</script>

<style scoped>
.talk {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  position: fixed;
  z-index: 30;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.talk__box {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 50%;
}
.box {
  width: 80%;
  height: 70%;
  background-color: rgb(167, 105, 105);
}
</style>
