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
          style="background-color: green; height: 30px; width: 100%"
        ></div>
      </div>
    </div>
    <div id="myStatus">
      <p>내 이름</p>
      <div
        id="myMaxHp"
        style="border: 5px solid black; height: 30px; width: 90%"
      >
        <div
          id="myHp"
          style="background-color: green; height: 30px; width: 100%"
        ></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      time: 0,

      getEnemyHpBar: 100,
      getmyHpBar: 100
    }
  },

  props: { myHpBar: String, enemyHpBar: String, begin: Number },

  created() {
    setInterval(() => {
      this.time += 1
    }, 100)
  },

  watch: {
    time() {
      if (this.enemyHpBar < this.getEnemyHpBar) {
        this.getEnemyHpBar -= 5
      }
      var enemyHpBarPer = this.getEnemyHpBar.toString() + '%'
      document.querySelector('#enemyHp').style.width = enemyHpBarPer
      if (this.myHpBar < this.getmyHpBar) {
        this.getmyHpBar -= 5
      }
      var myHpBarPer = this.getmyHpBar.toString() + '%'
      document.querySelector('#myHp').style.width = myHpBarPer
    },

    begin() {
      this.getEnemyHpBar = 100
      this.getmyHpBar = 100

      document.querySelector('#enemyHp').style.width = this.getEnemyHpBar
      document.querySelector('#myHp').style.width = this.getmyHpBar
    }
  },

  methods: {}
}
</script>

<style>
#enemyStatus {
  position: absolute;
  top: 100px;
  left: 200px;

  padding: 10px;
  width: 400px;
  height: 100px;
  background-color: white;
  z-index: 1;
}

#myStatus {
  position: absolute;
  top: 400px;
  left: 1000px;

  padding: 10px;
  width: 400px;
  height: 100px;
  background-color: white;
  z-index: 1;
}
</style>
