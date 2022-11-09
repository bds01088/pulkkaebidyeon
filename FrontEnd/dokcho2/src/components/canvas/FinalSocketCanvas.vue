<template>
  <div>
    <canvas
      ref="game"
      width="640"
      height="480"
      style="border: 1px solid black"
    ></canvas>
    <p>
      <button @click="move('right')">Right</button>
      <button @click="move('left')">Left</button>
      <button @click="move('up')">Up</button>
      <button @click="move('down')">Down</button>
    </p>
  </div>
</template>

<script>
import io from 'socket.io-client'
export default {
  name: 'BlockGame',
  data() {
    return {
      socket: {},
      context: {},
      position: {
        x: 0,
        y: 0
      },
      objList: [],
      keys: []
    }
  },
  created() {
    this.socket = io('http://localhost:3000')

    document.addEventListener('keydown', (event) => {
      if (!this.keys.includes(event.key)) {
        this.keys.push(event.key)
        console.log(this.keys)
      }
    })

    document.addEventListener('keyup', (event) => {
      for (var i = 0; i < this.keys.length; i++) {
        if (this.keys[i] == event.key) {
          this.keys.splice(i, 1)
        }
      }
    })

    this.socket.on('playerdata', (data) => {
      // for (let i = 0; i < objList.length; i++) {
      //   scene.remove(objList[i])
      // }
      // console.log(data)

      for (const [key, value] of Object.entries(data)) {
        if (key !== this.socket.id) {
          let temp = { position: { x: 0, y: 0 } }
          temp.position.x = value.object.x
          temp.position.y = value.object.y

          this.objList.push(temp)
          // console.log(this.objList)
          // this.context.clearRect(
          //   0,
          //   0,
          //   this.$refs.game.width,
          //   this.$refs.game.height
          // )
          this.context.fillRect(
            this.objList[this.objList.length - 1].x,
            this.objList[this.objList.length - 1].y,
            20,
            20
          )
          // scene.add(objList[objList.length - 1])
        }

        this.socket.emit('senddata', this.position)
      }
    })
  },

  mounted() {
    // window.addEventListener('keyup', this.move)
    this.context = this.$refs.game.getContext('2d')
    this.socket.on('position', (position) => {
      this.position = position
      this.context.clearRect(
        0,
        0,
        this.$refs.game.width,
        this.$refs.game.height
      )
      this.context.fillRect(this.position.x, this.position.y, 20, 20)
    })
    requestAnimationFrame(this.loop)
  },
  beforeDestory() {
    // window.addEventListener('keyup', this.move)
  },
  methods: {
    loop() {
      if (this.keys.includes('a')) {
        //좌
        this.position.x -= 10
      }
      if (this.keys.includes('d')) {
        //우
        this.position.x += 10
      }
      if (this.keys.includes('w')) {
        //상
        this.position.y += 10
      }
      if (this.keys.includes('s')) {
        //하
        this.position.y -= 10
      }
    }

    // move(event) {
    //   // this.socket.emit('move', direction)
    //   if (event.keyCode === 37) {
    //     //좌
    //     this.socket.emit('move', 'left')
    //   }
    //   if (event.keyCode === 38) {
    //     //상
    //     this.socket.emit('move', 'up')
    //   }
    //   if (event.keyCode === 39) {
    //     //우
    //     this.socket.emit('move', 'right')
    //   }
    //   if (event.keyCode === 40) {
    //     //하
    //     this.socket.emit('move', 'down')
    //   }
    // }
  }
}
</script>

<style scoped></style>
