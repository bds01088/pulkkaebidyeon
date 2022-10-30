<template>
  <div>
    <nav class="navbar">
      <div>
        <ul class="navbar__centerIcons">
          <li>
            <a @click="openModal">
              <p class="TITLE">미 션</p>
              <font-awesome-icon icon="fa-solid fa-scroll" size="xl" />
            </a>
          </li>

          <li>
            <a @click="openModal">
              <p class="TITLE">지 도</p>
              <font-awesome-icon icon="map-location-dot" size="xl" />
            </a>
          </li>
          <li>
            <a @click="openModal">
              <p class="TITLE">가 방</p>
              <font-awesome-icon icon="fa-solid fa-suitcase" size="xl" />
            </a>
          </li>
        </ul>
      </div>
    </nav>
    <MyModal @close="closeModal" v-if="modal">
      <!-- default 슬롯 콘텐츠 -->
      <p>미션창</p>
      <div><input v-model="message" /></div>
      <!-- /default -->
      <!-- footer 슬롯 콘텐츠 -->
      <template v-slot:footer>
        <button @click="doSend">닫기</button>
      </template>
      <!-- /footer -->
    </MyModal>
  </div>
</template>

<script>
import MyModal from './MyModal.vue'
export default {
  data() {
    return {
      modal: false,
      message: ''
    }
  },
  components: { MyModal },
  methods: {
    openModal() {
      this.modal = true
    },
    closeModal() {
      this.modal = false
    },
    doSend() {
      if (this.message.length > 0) {
        alert(this.message)
        this.message = ''
        this.closeModal()
      } else {
        alert('메시지를 입력해주세요.')
      }
    }
  }
}
</script>

<style scoped>
.navbar {
  position: absolute;
  /* z-index: -9; */
  margin-left: 500px;
}
</style>
>
