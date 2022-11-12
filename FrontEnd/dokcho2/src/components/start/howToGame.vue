<template>
  <div class="howTo__container">
    <div class="howTo">
      게임설명

      <img
        class="exit__btn"
        @click="$emit('howtoGame')"
        src="@/assets/navbar/ExitButton.png"
        alt=""
      />
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style scoped>
.howTo__container {
  width: 100vw;
  height: 100vh;
  /* backdrop-filter: blur(4px); */
  z-index: 30;
  top: 0;
  left: 0;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: absolute;
}

.howTo {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 40;
  top: 4%;
  left: 25%;
  width: 50%;
  height: 90%;
  background: rgba(225, 225, 225, 0.714);
  /* background-image: url('@/assets/Paper.png'); */
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  backdrop-filter: blur(4px);
  border-radius: 20px;
  overflow: visible;
}

.exit__btn {
  width: 4vw;
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 4vh;
  right: 4vw;
  cursor: pointer;
}
</style>
