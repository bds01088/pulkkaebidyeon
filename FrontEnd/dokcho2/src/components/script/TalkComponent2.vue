<template>
  <div class="talk">
    <div class="talk__box">
      <div class="box" v-if="this.isTalk.content.line">
        <div
          class="content__box"
          @click="nextTalk()"
          v-if="this.isTalk.content.line.length !== nowPage.nowPage + 1"
        >
          <div class="name">{{ this.isTalk.name }}</div>
          <div class="content">
            <!-- {{ this.isTalk.content }} -->
            {{ this.isTalk.content.line[nowPage.nowPage] }}
          </div>
        </div>
        <div class="content__box" v-else @click="endTalk()">
          <div class="name">{{ this.isTalk.name }}</div>
          <div class="content">
            <!-- {{ this.isTalk.content }} -->
            {{ this.isTalk.content.line[nowPage.nowPage] }}
          </div>
        </div>
        <div class="btn__box">
          <font-awesome-icon
            class="icon"
            @click="nextTalk()"
            v-if="this.isTalk.content.line.length !== nowPage.nowPage + 1"
            icon="fa-solid fa-caret-down"
            style="font-size: 50px"
          />
          <font-awesome-icon
            v-else
            class="icon"
            icon="fa-solid fa-xmark"
            @click="endTalk()"
            style="font-size: 45px"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { ref } from 'vue'
import { useStore } from 'vuex'
import Swal from 'sweetalert2'

export default {
  props: {
    isTalk: Object
  },
  setup(props, { emit }) {
    let nowPage = ref({ nowPage: 0 })

    const store = useStore()
    // store.dispatch('fetchnowUserInfo')
    const Toast = Swal.mixin({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    })

    function endTalk() {
      const content = props.isTalk.content
      const userInfo = JSON.parse(localStorage.getItem('userInfo'))
      console.log(content)
      console.log(userInfo)

      const clearImg = require('@/assets/mission/clear.png')

      // started : 미션 시작한 상태 -> 보스 찾아가 문제 풀기 / 대화 끝나고 바로 퀴즈 시작
      if (content.status === 'STARTED') {
        Toast.fire({
          icon: 'success',
          title: `${props.isTalk.name}이 내는 퀴즈를 통과해라!`
        })
        emit('quizStart')
      } else {
        if (userInfo.nowMissionId === content.missionId) {
          // ready : 미션 수행 가능한 상태 -> 위인이 도움 요청
          if (content.status === 'READY') {
            axios({
              url: BASE_URL + '/api/v1/mission/',
              method: 'PUT',
              headers: {
                AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
              }
            }).then(() => {
              emit('talkClose')
              Toast.fire({
                icon: 'success',
                html:
                  `<p><b>유물 도둑을 찾아라!</b></p>` +
                  '<br />' +
                  `<p>${content.next}</p>`
              })
            })
          } else if (content.status === 'QUIZ_PASSED') {
            // quiz_passed : 퀴즈 다 맞힌 상태 -> 시비거는 보스와 배틀 시작
            emit('talkClose')
            Toast.fire({
              icon: 'success',
              title: `${props.isTalk.name}과의 배틀에서 승리하라!`
            })
            emit('enterBattle')
          } else if (content.status === 'BATTLE_WIN') {
            if (content.missionId === 2 || content.missionId === 5) {
              // battle win : 배틀 이긴 상태 -> 위인한테 유물 가져다준다 / 미션 마지막!
              axios({
                url: BASE_URL + '/api/v1/mission/',
                method: 'PUT',
                headers: {
                  AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
                }
              }).then(() => {
                store.dispatch('fetchnowUserInfo')
                // mission complete alert 그 외에는 다음 설명
                if (content.missionId === 2) {
                  const monster1 = { id: 2, name: '도꼬마리몬' }
                  axios({
                    url: BASE_URL + '/api/v1/monster/' + monster1.id,
                    method: 'POST',
                    headers: {
                      AUTHORIZATION:
                        'Bearer ' + localStorage.getItem('accessToken')
                    }
                  }).catch((err) => console.log(err))

                  Swal.fire({
                    title: `${content.characters}의 고민 해결 완료 ✨`,
                    html:
                      `<div style="display:flex; flex-direction: row; justify-content:center">

                  <div style="margin: 1vw">
                    <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/mission/exp.png')}"/>
                    <p style="font-size:0.9rem;">경험치 <b>${
                      content.exp
                    }</b></p>
                  </div>

                  <div style="margin: 1vw">
                  <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/item/' +
                    content.item +
                    '.png')}"/>
                    <p style="font-size:0.9rem;">${content.itemName}</p>
                  </div>

                  <div style="margin: 1vw">
                    <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/mission/' +
                      monster1.id +
                      '.png')}"/>
                    <p style="font-size:0.9rem;">${monster1.name}</p>
                  </div>
                    
                  </div>` +
                      '<br />' +
                      `<p>🔍 ${content.next}</p>`,
                    imageUrl: clearImg,
                    imageWidth: 300,
                    imageHeight: 100,
                    imageAlt: 'Custom image',
                    // showConfirmButton: false,
                    // timer: 2500,
                    background: 'rgba(255, 255, 255)'
                  })
                } else if (content.missionId === 5) {
                  const monster2 = { id: 3, name: '마늘몬' }

                  axios({
                    url: BASE_URL + '/api/v1/monster/' + monster2.id,
                    method: 'POST',
                    headers: {
                      AUTHORIZATION:
                        'Bearer ' + localStorage.getItem('accessToken')
                    }
                  }).catch((err) => console.log(err))

                  Swal.fire({
                    title: `${content.characters}의 고민 해결 완료 ✨`,
                    html:
                      `<div style="display:flex; flex-direction: row; justify-content:center">

                  <div style="margin: 1vw">
                    <img  style="height:60px;width:60px;text-align:center;margin-bottom:1vh;" src="${require('@/assets/mission/exp.png')}"/>
                    <p style="font-size:0.9rem;">경험치 <b>${
                      content.exp
                    }</b></p>
                  </div>

                  <div style="margin: 1vw">
                  <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/item/' +
                    content.item +
                    '.png')}"/>
                    <p style="font-size:0.9rem;">${content.itemName}</p>
                  </div>

                  <div style="margin: 1vw">
                    <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/mission/' +
                      monster2.id +
                      '.png')}"/>
                    <p style="font-size:0.9rem;">${monster2.name}</p>
                  </div>
                    
                  </div>` +
                      '<br />' +
                      `<p>🔍 ${content.next}</p>`,
                    imageUrl: clearImg,
                    imageWidth: 300,
                    imageHeight: 100,
                    imageAlt: 'Custom image',
                    // showConfirmButton: false,
                    // timer: 2500,
                    background: 'rgba(255, 255, 255)'
                  })
                }

                emit('talkClose')
              })
            } else {
              // battle win : 배틀 이긴 상태 -> 위인한테 유물 가져다준다 / 미션 마지막!
              axios({
                url: BASE_URL + '/api/v1/mission/',
                method: 'PUT',
                headers: {
                  AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
                }
              }).then(() => {
                store.dispatch('fetchnowUserInfo')
                // mission complete alert 그 외에는 다음 설명
                Swal.fire({
                  title: `${content.characters}의 고민 해결 완료 ✨`,
                  html:
                    `<div style="display:flex; flex-direction: row; justify-content:center">

                  <div style="margin: 1vw">
                    <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/mission/exp.png')}"/>
                    <p style="font-size:0.9rem;">경험치 <b>${
                      content.exp
                    }</b></p>
                  </div>

                  <div style="margin: 1vw">
                  <img  style="height:60px;width:60px;text-align:center;" src="${require('@/assets/item/' +
                    content.item +
                    '.png')}"/>
                    <p style="font-size:0.9rem;">${content.itemName}</p>
                  </div>
                    
                  </div>` +
                    '<br />' +
                    `<p>🔍 ${content.next}</p>`,
                  imageUrl: clearImg,
                  imageWidth: 300,
                  imageHeight: 100,
                  imageAlt: 'Custom image',
                  // showConfirmButton: false,
                  // timer: 2500,
                  background: 'rgba(255, 255, 255)'
                })
                emit('talkClose')
              })
            }
          } else {
            emit('talkClose')
          }
        } else {
          emit('talkClose')
        }
      }
    }

    function nextTalk() {
      nowPage.value.nowPage += 1
    }

    return {
      nowPage,
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
  cursor: url('@/assets/pointer.cur'), auto;
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
  border-top-right-radius: 10vw;
  border-top-left-radius: 10vw;
  border-bottom-right-radius: 6vw;
  border-bottom-left-radius: 6vw;
  width: 60%;
  height: 50%;
  padding: 2vw 7vw;
  /* box-shadow: 0 0 1px 1px gray; */
  box-shadow: 10px 10px 10px #00000092;
  background-color: rgb(229, 224, 196);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.content__box {
  position: relative;
  cursor: url('@/assets/selector.cur'), pointer;
}
.name {
  width: 10vw;
  height: 6vh;
  border-radius: 3vh;
  box-shadow: 2px 3px 5px 0px rgba(0, 0, 0, 0.5);
  /* border: 2px rgba(0, 0, 0, 0.5) solid; */
  background-color: rgb(242, 241, 235);
  top: -7vh;
  position: absolute;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 3.5vh;
  font-weight: bold;
}

/* 대사  */
.content {
  margin-top: 5vh;
  margin-left: 2vh;
  font-size: 1.4rem;
  letter-spacing: 0.3px;
  word-spacing: 5px;
  /* overflow: hidden;
  font-size: 1.4rem;
  width: 0;
  white-space: nowrap;
  animation: typing 1s steps(20, end) forwards; */
}
.btn__box {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 3vh;
}

.icon {
  /* border-radius: 3vh;
  border: 2px gray solid;
  width: 6vw;
  height: 5vh;
  font-size: 1vw; */
  cursor: url('@/assets/selector.cur'), pointer;
  transition: 0.5s;
}

.icon:hover {
  scale: 1.1;
  color: #467302;
}

/* 타이핑 애니메이션 : 첫번째 줄 시작에만 적용돼서 주석처리 */
/* @keyframes typing {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
} */
</style>
