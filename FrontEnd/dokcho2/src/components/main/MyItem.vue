<template>
  <div class="item__container"></div>
  <div class="myItem">
    <div class="item__header">
      <p>가방</p>
    </div>
    <div class="item__body" v-if="items.items.length > 0">
      <h3>미션 획득 아이템</h3>
      <div class="item__body1" v-if="missionItems.missionItems.length > 0">
        <div
          class="item__item"
          v-for="item in missionItems.missionItems"
          :key="item.itemId"
        >
          <div class="tooltip">
            <img
              :src="require('@/assets/item/' + item.itemId + '.png')"
              alt=""
              class="item__image"
            />
            <span class="tooltiptext"
              >"{{ item.itemName }}" <br />
              {{ item.description }}</span
            >
          </div>

          <!-- <p>{{ item.itemName }}</p> -->
        </div>
      </div>
      <div class="item__body1" v-else>
        <p>미션을 해결하고 아이템을 모아보세요!</p>
      </div>
      <h3>배틀 사용 아이템</h3>
      <div class="item__body2" v-if="battleItems.battleItems.length > 0">
        <div
          class="item__item"
          v-for="item in battleItems.battleItems"
          :key="item.itemId"
        >
          <div class="tooltip">
            <!-- 지금 이미지, count 안넣어서 주석처리해둠 -->
            <!-- <img
              :src="require('@/assets/item/' + item.itemId + '.png')"
              alt=""
              class="item__image"
            /> -->
            <span class="tooltiptext"> {{ item.description }}</span>
            <div class="battle__item">
              <p>{{ item.itemName }}</p>
              <p>1</p>
              <!-- <p>{{ item.count }}</p> -->
            </div>
          </div>
        </div>
      </div>
      <div class="item__body2" v-else>
        <p>미니게임을 통해 아이템을 모아봐요 >.^</p>
      </div>
    </div>
    <div class="item__x" v-else>
      <p>가지고 있는 아이템이 없어요 😥</p>
    </div>
    <img
      class="exit__btn"
      @click="closeModal2()"
      src="@/assets/navbar/ExitButton.png"
      alt=""
    />
  </div>
</template>

<script>
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import { ref, onMounted } from 'vue'

export default {
  setup(props, { emit }) {
    const items = ref({ items: [] })
    const battleItems = ref({ battleItems: [] })
    const missionItems = ref({ missionItems: [] })

    function fetchItems() {
      axios({
        // 테스트용으로 요청 전체 아이템 받음 / 실제로는 item까지만
        url: BASE_URL + '/api/v1/item/itemList',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          items.value.items = res.data
          missionItems.value.missionItems = items.value.items.filter(
            (item) => item.itemId < 8
          )
          battleItems.value.battleItems = items.value.items.filter(
            (item) => item.itemId > 20
          )
        })
        .catch((err) => {
          console.log(err)
        })
    }

    function closeModal2() {
      emit('closeModal2')
    }

    onMounted(() => {
      fetchItems()
    })

    return {
      items,
      battleItems,
      missionItems,
      fetchItems,
      closeModal2
    }
  }
}
</script>

<style scoped>
.item__container {
  width: 100%;
  height: 100%;
  /* backdrop-filter: blur(4px); */
  z-index: 30;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
}

.myItem {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  z-index: 40;
  top: 10%;
  left: 25%;
  width: 50%;
  height: 80%;
  background: rgba(169, 170, 150, 0.714);
  /* background-image: url('@/assets/Paper.png'); */
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  backdrop-filter: blur(4px);
  border-radius: 20px;
  overflow: visible;
}
.item__header {
  font-weight: bolder;
  font-size: 2rem;
  margin-bottom: 5vh;
  margin-top: 0;
}

.item__body {
  /* margin: 2vh; */
  border: 1px solid white;
  background-color: #ffffff;
  width: 80%;
  height: 60%;
  top: 30%;
  padding: 1vh;
  border-radius: 10px;
  box-shadow: 1px 1px 5px 1px gray;
}

h3 {
  margin: 2vh;
}
.item__body1,
.item__body2 {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  margin-left: 2vh;
}

.item__item {
  width: 60px;
  height: 60px;
  /* border: 1px solid black; */
  background-color: #ffffff;
  /* padding: 1vh; */
  border-radius: 10px;
  /* box-shadow: 1px 1px 5px 1px gray; */
  margin-bottom: 2vh;
  cursor: pointer;
}

.item__image {
  width: 100%;
}

.item__item p {
  font-size: 0.5rem;
}

.battle__item {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  text-align: center;
}

.battle__item p {
  margin-left: 10%;
}
.item__count {
  border: 1px solid white;
  background-color: yellow;
  width: 20%;
  padding: 1vh;
  border-radius: 10px;
}

.item__no {
  padding-top: 25%;
}

.item__no p {
  text-align: center;
  margin: auto;
  font-size: 1.5rem;
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

.tooltip {
  position: relative;
  display: inline-block;
  /* border-bottom: 1px dotted black; */
}

.tooltip .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: black;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  font-size: 0.8rem;

  /* Position the tooltip */
  position: absolute;
  z-index: 1;
  bottom: 100%;
  left: 50%;
  margin-left: -60px;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
}
</style>
