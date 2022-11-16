<template>
  <div>
    <div id="enemyStatus">
      <p style="margin-left: 10px">{{ enemyName }}</p>
      <div
        id="enemyMaxHp"
        style="border: 5px solid black; height: 30px; width: 88%"
      >
        <div
          id="enemyHp"
          style="background-color: green; height: 31px; width: 100%"
        ></div>
      </div>
      <p style="margin-top: 5px; margin-left: 75%">
        {{ enemyHp }} / {{ enemyMaxHp }}
      </p>
    </div>
    <div id="myStatus">
      <p style="margin-left: 10px">{{ myName }}</p>
      <div
        id="myMaxHp"
        style="border: 5px solid black; height: 30px; width: 88%"
      >
        <div
          id="myHp"
          style="background-color: green; height: 31px; width: 100%"
        ></div>
      </div>
      <p style="margin-top: 5px; margin-left: 75%">
        {{ myHp }} / {{ myMaxHp }}
      </p>
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

  props: {
    myHpBar: String,
    enemyHpBar: String,
    begin: Number,
    poison: Boolean,
    myMaxHp: Number,
    myHp: Number,
    enemyMaxHp: Number,
    enemyHp: Number,
    myName: String,
    enemyName: String
  },

  created() {
    setInterval(() => {
      this.time += 1
    }, 30)
  },

  watch: {
    time() {
      if (this.enemyHpBar < this.getEnemyHpBar) {
        this.getEnemyHpBar -= 1
      } else if (this.enemyHpBar > this.getEnemyHpBar) {
        this.getEnemyHpBar += 1
      }
      var enemyHpBarPer = this.getEnemyHpBar.toString() + '%'
      document.querySelector('#enemyHp').style.width = enemyHpBarPer

      if (this.myHpBar < this.getmyHpBar) {
        this.getmyHpBar -= 1
      } else if (this.myHpBar > this.getmyHpBar) {
        this.getmyHpBar += 1
      }
      var myHpBarPer = this.getmyHpBar.toString() + '%'
      document.querySelector('#myHp').style.width = myHpBarPer
    },

    begin() {
      this.getEnemyHpBar = 100
      this.getmyHpBar = 100

      document.querySelector('#enemyHp').style.width = this.getEnemyHpBar
      document.querySelector('#myHp').style.width = this.getmyHpBar
    },

    poison() {
      if (this.poison == true) {
        document.querySelector('#enemyHp').style.backgroundColor = 'purple'
      } else {
        document.querySelector('#enemyHp').style.backgroundColor = 'green'
      }
    }
  },

  methods: {}
}
</script>

<style>
#enemyStatus {
  position: absolute;
  top: 15%;
  left: 15%;

  padding: 10px;
  padding-right: 0px;
  width: 28%;
  height: 12%;
  background-color: white;
  z-index: 1;

  border: 2px solid black;
  border-radius: 10px;
}

#myStatus {
  position: absolute;
  top: 55%;
  left: 60%;

  padding: 10px;
  padding-right: 0px;
  width: 28%;
  height: 12%;
  background-color: white;
  z-index: 1;

  border: 2px solid black;
  border-radius: 10px;
}
</style>
