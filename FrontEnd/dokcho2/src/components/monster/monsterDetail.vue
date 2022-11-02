<template>
  <div class="card" style="width: 18rem">
    <!-- <img class="card-img-top" src="..." alt="Card image cap" /> -->
    <div class="card-body">
      <button @click="showMonster">x</button>
      <h5 class="card-title">{{ this.monsterDetail.name }}</h5>
      <p class="card-text"></p>
      <!-- <a href="#" class="btn btn-primary">Go somewhere</a> -->
    </div>
  </div>
</template>

<script>
export default {
  props: {
    monsterDetail: Object,
    monster: Boolean
  },
  methods: {
    showMonster() {
      this.$emit('showMonster')
    }
  }
}
</script>

<style></style>
