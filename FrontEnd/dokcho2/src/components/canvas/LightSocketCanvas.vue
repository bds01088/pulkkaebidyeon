<template>
  <div></div>
  <!-- <canvas id="canvas"> </canvas> -->
</template>

<script>
import * as THREE from 'three'
import { io } from 'socket.io-client'
import * as CANNON from 'cannon-es'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
// import CannonDebugger from 'cannon-es-debugger'

export default {
  name: 'HouseCanvas',
  props: {
    nowPage: Number
  },
  setup() {
    THREE.Cache.enabled = true
    // const socket = io('http://k2031.p.ssafy.io:3000')
    // let message = "";
    // let receivedMessage = [];
    const socket = io('http://k7e2031.p.ssafy.io:3000/')

    // Keyboard Input //
    var keys = []
    // var shift = false;
    const clock = new THREE.Clock()

    var playerObj = ''
    var temp = ''

    document.addEventListener('keydown', (event) => {
      if (!keys.includes(event.key)) {
        keys.push(event.key)
      }
      // shift = event.shiftKey;
    })

    document.addEventListener('keyup', (event) => {
      for (var i = 0; i < keys.length; i++) {
        if (keys[i] == event.key) {
          keys.splice(i, 1)
        }
      }
    })

    // Main script //
    var WIDTH = window.innerWidth
    var HEIGHT = window.innerHeight

    // Setup networking //
    // var socket = io();
    // var userlist = {};

    var objList = []
    // var objBodyList = []

    // Setup WebGL //
    var renderer = new THREE.WebGLRenderer({ antialias: true })
    renderer.setSize(WIDTH, HEIGHT)
    renderer.setClearColor(0x8cd3f5, 1)
    document.body.appendChild(renderer.domElement)

    // Create scene //
    var scene = new THREE.Scene()

    // Create camera //
    const camera = new THREE.OrthographicCamera(
      -(window.innerWidth / window.innerHeight), // left
      window.innerWidth / window.innerHeight, // right,
      1, // top
      -1, // bottom
      -1000,
      1000
    )
    const cameraPosition = new THREE.Vector3(50, 500, 700)
    camera.position.set(cameraPosition.x, cameraPosition.y, cameraPosition.z)
    camera.zoom = 0.01
    camera.updateProjectionMatrix()
    scene.add(camera)

    function setSize() {
      camera.left = -(window.innerWidth / window.innerHeight)
      camera.right = window.innerWidth / window.innerHeight
      camera.top = 1
      camera.bottom = -1

      camera.updateProjectionMatrix()
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.render(scene, camera)
    }

    // 이벤트
    window.addEventListener('resize', setSize)

    // Spinning cube
    var basicMaterial = new THREE.MeshLambertMaterial({ color: 0x0095dd })
    var cube = new THREE.Mesh(new THREE.BoxGeometry(10, 10, 10), basicMaterial)
    scene.add(cube)
    cube.rotation.set(0, 0, 0)

    // Cannon(물리 엔진)
    const cannonWorld = new CANNON.World()
    cannonWorld.gravity.set(0, -10, 0)

    // Floor
    var floor = new THREE.Mesh(
      new THREE.BoxGeometry(300, 5, 300),
      // new THREE.PlaneGeometry(100, 100),
      new THREE.MeshLambertMaterial({ color: 0xdfdfdf })
    )
    scene.add(floor)

    floor.position.y = -20

    // const floorShape = new CANNON.Box(new CANNON.Vec3(150, 2.5, 150))
    // const floorBody = new CANNON.Body({
    //   mass: 0,
    //   shape: floorShape
    // })
    // floorBody.position.x = floor.position.x
    // floorBody.position.y = floor.position.y
    // floorBody.position.z = floor.position.z
    // floorBody.quaternion.setFromAxisAngle(
    //   new CANNON.Vec3(-1, 0, 0),
    //   Math.PI / 2
    // )
    // cannonWorld.addBody(floorBody)

    var Ofloor = new THREE.Mesh(
      new THREE.BoxGeometry(50, 5, 50),
      // new THREE.PlaneGeometry(100, 100),
      new THREE.MeshLambertMaterial({ color: 0x5cee30 })
    )
    Ofloor.position.y = -15
    Ofloor.position.x = -50

    scene.add(Ofloor)

    var Xfloor = new THREE.Mesh(
      new THREE.BoxGeometry(50, 5, 50),
      // new THREE.PlaneGeometry(100, 100),
      new THREE.MeshLambertMaterial({ color: 0xee5130 })
    )
    Xfloor.position.y = -15
    Xfloor.position.x = 50
    scene.add(Xfloor)

    // Create player //
    // var playermesh = new THREE.BoxGeometry(8, 18, 8)
    // var playermat = new THREE.MeshLambertMaterial({ color: 0x7499ab })
    // var playerObj = new THREE.Mesh(playermesh, playermat)
    // playerObj.position.y = 20
    // scene.add(playerObj)

    // const playerShape = new CANNON.Box(new CANNON.Vec3(4, 9, 4))
    // const playerBody = new CANNON.Body({
    //   mass: 1,
    //   shape: playerShape
    // })
    // playerBody.position.x = playerObj.position.x
    // playerBody.position.y = playerObj.position.y
    // playerBody.position.z = playerObj.position.z
    // cannonWorld.addBody(playerBody)

    const gltfLoader = new GLTFLoader()

    gltfLoader.load('/models/bbb.glb', (gltf) => {
      playerObj = gltf.scene
      scene.add(playerObj)

      playerObj.traverse((child) => {
        if (child instanceof THREE.Mesh) {
          child.castShadow = true
        }
      })
    })

    // Create dummy //
    // var enemy = new THREE.Mesh(playermesh, playermat)
    // enemy.position.x = 50
    // scene.add(enemy)

    // Create light //
    var light = new THREE.PointLight(0xffffff)
    light.position.set(100, 200, 200)
    scene.add(light)

    const amb_light = new THREE.AmbientLight(0x404040)
    scene.add(amb_light)

    // let sensitivity = 1;
    let t = 0

    // Main loop //

    function loop() {
      t += 0.01

      cube.rotation.x = t * 8
      cube.rotation.y = t * 8
      if (playerObj) {
        camera.lookAt(playerObj.position)
      }
      camera.position.x = cameraPosition.x + playerObj.position.x
      camera.position.z = cameraPosition.z + playerObj.position.z
      let shiftboost = 0 //shift === true ? 1 : 0;

      if (keys.includes('a')) {
        playerObj.translateX(-1 - shiftboost)
        // playerBody.position.x -= 1
      }
      if (keys.includes('d')) {
        playerObj.translateX(1 + shiftboost)
        // playerBody.position.x += 1
      }

      if (keys.includes('w')) {
        playerObj.translateZ(-1 - shiftboost)
        // playerBody.position.z -= 1
      }
      if (keys.includes('s')) {
        playerObj.translateZ(1)
        // playerBody.position.z += 1
      }

      // camera.position.x = playerObj.position.x
      // camera.position.y = playerObj.position.y + 4
      // camera.position.z = playerObj.position.z + 3

      // camera.rotation.y = playerObj.rotation.y
      const delta = clock.getDelta()

      let cannonStepTime = 1 / 60
      if (delta < 0.01) cannonStepTime = 1 / 120
      cannonWorld.step(cannonStepTime, delta, 3)

      // floorBody.position.set(
      //   floor.position.x,
      //   floor.position.y,
      //   floor.position.z
      // )

      // playerBody.position.set(
      //   playerObj.position.x,
      //   playerObj.position.y,
      //   playerObj.position.z
      // )

      // boxMesh.position.copy(boxBody.position) // 위치
      // boxMesh.quaternion.copy(boxBody.quaternion) // 회전
      if (playerObj) {
        playerObj.position.copy(playerObj.position)
        // playerObj.quaternion.copy(playerObj.quaternion)
      }
      // if (floor) {
      //   floor.position.copy(floorBody.position)
      // }

      requestAnimationFrame(loop)
      renderer.render(scene, camera)
    }

    loop()

    // Clamp function //
    // function clamp(num, min, max) {
    //   return Math.min(Math.max(num, min), max)
    // }

    // Mouse movement without pointer lock
    // document.addEventListener('mousemove', (event) => {
    //   camera.rotation.x += -event.movementY / 100

    //   camera.rotation.x = clamp(
    //     camera.rotation.x,
    //     (-90 * Math.PI) / 180,
    //     (90 * Math.PI) / 180
    //   )

    //   playerObj.rotation.y += -event.movementX / 100
    // })

    socket.on('playerdata', (data) => {
      // let userlist = []
      // userlist = data
      // console.log(userlist)

      for (let i = 0; i < objList.length; i++) {
        scene.remove(objList[i])
      }

      objList = []
      // objBodyList = []

      for (const [key, value] of Object.entries(data)) {
        if (key !== socket.id) {
          gltfLoader.load('/models/bbb.glb', (gltf) => {
            temp = gltf.scene
            temp.traverse((child) => {
              if (child instanceof THREE.Mesh) {
                child.castShadow = true
              }
            })
            console.log(temp.position)
            temp.position.x = value.object.x
            temp.position.y = value.object.y
            temp.position.z = value.object.z

            objList.push(temp)
            scene.add(objList[objList.length - 1])
          })
          // let temp = new THREE.Mesh(playermesh, playermat)
          socket.emit('senddata', playerObj.position)
        }
      }
      // for (const [key, value] of Object.entries(data)) {
      //   if (key !== socket.id) {
      //     let temp = new THREE.Mesh(playermesh, playermat)
      //     temp.position.x = value.object.x
      //     temp.position.y = value.object.y
      //     temp.position.z = value.object.z

      //     const tempShape = new CANNON.Box(new CANNON.Vec3(4, 9, 4))
      //     const tempBody = new CANNON.Body({
      //       mass: 1,
      //       shape: tempShape
      //     })
      //     tempBody.position.x = value.object.x
      //     tempBody.position.y = value.object.y
      //     tempBody.position.z = value.object.z
      //     // cannonWorld.addBody(tempBody)

      //     objList.push(temp)
      //     scene.add(objList[objList.length - 1])

      //     objBodyList.push(tempBody)
      //     cannonWorld.addBody(objBodyList[objBodyList.length - 1])
      //   }

      //   socket.emit('senddata', playerObj.position)
      // }
    })
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
canvas {
  width: 100vw;
  height: 100vh;
}
</style>
