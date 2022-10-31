<template>
  <div>
    <div id="enemyStatus">
      <p>적 이름</p>
      <div
        id="enemyMaxHp"
        style="border: 5px solid black; height: 30px; width: 90%"
      >
        <div
          id="enemyHp"
          style="background-color: green; height: 30px; width: 101%"
        ></div>
      </div>
    </div>
    <div id="myStatus">내체력</div>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  },

  props: { myHpBar: String, enemyHpBar: String },

  watch: {
    myHpBar() {
      console.log(this.myHpBar)
      document.querySelector('#enemyHp').style.width = this.myHpBar
    }
  },

  methods: {}
}
</script>

<style>
#enemyStatus {
  position: absolute;

  width: 200px;
  height: 100px;
  background-color: white;
}

#enemyMaxHp {
  margin: 0;
  padding: 0;
}

#myStatus {
  position: absolute;
  top: 400px;
  left: 500px;

  width: 200px;
  height: 100px;
  background-color: white;
}
</style>
