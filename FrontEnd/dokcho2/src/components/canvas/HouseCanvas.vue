<template>
  <div>
    <canvas id="HouseCanvas"> </canvas>
    <monsterDetail
      v-if="monster.monster"
      :monsterDetail="monsterDetail.monsterDetail"
      @monsterClose="monsterClose"
    />
    <myPage v-if="myPage.myPage" @mypageClose="mypageClose" />
  </div>
</template>

<script>
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { Player } from '../modules/Player'
import { House } from '../modules/House'
import gsap from 'gsap'
import { KeyController } from '../modules/CharacterControl'
import * as CANNON from 'cannon-es'
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import monsterDetail from '@/components/monster/monsterDetail.vue'
import myPage from '@/components/accounts/myPage.vue'

export default {
  name: 'HouseCanvas',
  props: {
    nowPage: Number,
    nowNavbar: Boolean
  },
  components: {
    monsterDetail: monsterDetail,
    myPage: myPage
  },
  setup(props, { emit }) {
    const userInfo = JSON.parse(localStorage.getItem('userInfo'))
    const userMonster = ref({ userMonster: {} })
    const monster = ref({ monster: false })
    const monsterDetail = ref({ monsterDetail: {} })
    const myPage = ref({ myPage: false })

    setTimeout(() => {
      // Texture

      const textureLoader = new THREE.TextureLoader()
      const floorTexture = textureLoader.load('/images/floor.png')
      floorTexture.wrapS = THREE.RepeatWrapping
      floorTexture.wrapT = THREE.RepeatWrapping
      floorTexture.repeat.x = 1
      floorTexture.repeat.y = 1
      let isLoading = 0

      // Renderer
      let canvas = document.querySelector('#HouseCanvas')
      console.log(canvas)
      const renderer = new THREE.WebGLRenderer({
        canvas,
        antialias: true
      })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)
      renderer.shadowMap.enabled = true
      renderer.shadowMap.type = THREE.PCFSoftShadowMap

      // Scene
      const scene = new THREE.Scene()

      // Camera
      const camera = new THREE.OrthographicCamera(
        -(window.innerWidth / window.innerHeight), // left
        window.innerWidth / window.innerHeight, // right,
        1, // top
        -1, // bottom
        -1000,
        1000
      )

      const cameraPosition = new THREE.Vector3(1, 5, 5)
      camera.position.set(cameraPosition.x, cameraPosition.y, cameraPosition.z)
      camera.zoom = 0.3
      camera.updateProjectionMatrix()
      scene.add(camera)

      // Light
      const ambientLight = new THREE.AmbientLight('white', 0.7)
      scene.add(ambientLight)

      const directionalLight = new THREE.DirectionalLight('white', 0.5)
      const directionalLightOriginPosition = new THREE.Vector3(1, 1, 1)
      directionalLight.position.x = directionalLightOriginPosition.x
      directionalLight.position.y = directionalLightOriginPosition.y
      directionalLight.position.z = directionalLightOriginPosition.z
      directionalLight.castShadow = true

      // mapSize 세팅으로 그림자 퀄리티 설정
      directionalLight.shadow.mapSize.width = 2048
      directionalLight.shadow.mapSize.height = 2048
      // 그림자 범위
      directionalLight.shadow.camera.left = -100
      directionalLight.shadow.camera.right = 100
      directionalLight.shadow.camera.top = 100
      directionalLight.shadow.camera.bottom = -100
      directionalLight.shadow.camera.near = -100
      directionalLight.shadow.camera.far = 100
      scene.add(directionalLight)

      // Cannon(물리 엔진)
      const cannonWorld = new CANNON.World()
      cannonWorld.gravity.set(0, -10, 0)

      const floorShape = new CANNON.Plane()
      const floorBody = new CANNON.Body({
        mass: 0,
        position: new CANNON.Vec3(0, 0, 0),
        shape: floorShape
      })
      floorBody.quaternion.setFromAxisAngle(
        new CANNON.Vec3(-1, 0, 0),
        Math.PI / 2
      )
      cannonWorld.addBody(floorBody)

      const boxShape = new CANNON.Box(new CANNON.Vec3(0.25, 2.5, 0.25))
      const boxBody = new CANNON.Body({
        mass: 1,
        position: new CANNON.Vec3(0, 10, 0),
        shape: boxShape
      })
      cannonWorld.addBody(boxBody)

      // Mesh
      const meshes = []
      const floorMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(15, 15),
        new THREE.MeshStandardMaterial({
          map: floorTexture
        })
      )
      floorMesh.name = 'floor'
      floorMesh.rotation.x = -Math.PI / 2
      floorMesh.receiveShadow = true
      scene.add(floorMesh)
      // meshes.push(floorMesh)

      // const pointerMesh = new THREE.Mesh(
      //   new THREE.PlaneGeometry(0.5, 0.5),
      //   new THREE.MeshBasicMaterial({
      //     color: 'crimson',
      //     transparent: true,
      //     opacity: 0.5
      //   })
      // )
      // pointerMesh.rotation.x = -Math.PI / 2
      // pointerMesh.position.y = 0.01
      // pointerMesh.receiveShadow = true
      // scene.add(pointerMesh)

      const spotMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(3, 3),
        new THREE.MeshStandardMaterial({
          color: 'yellow',
          transparent: true,
          opacity: 0.5
        })
      )
      spotMesh.position.set(5, 0.005, 5)
      spotMesh.rotation.x = -Math.PI / 2
      spotMesh.receiveShadow = true
      scene.add(spotMesh)

      const gltfLoader = new GLTFLoader()

      // 내가 가진 풀깨비 넣기
      for (let monsterID in userMonster.value.userMonster) {
        let id = Number(monsterID) + 1
        gltfLoader.load(`/models/Monsters/${id}.glb`, (item) => {
          const monster = item.scene
          monster.name = ['monster', `${id}`]
          monster.position.x = (Math.random() - 0.5) * 5
          monster.position.z = (Math.random() - 0.5) * 5
          monster.scale.set(0.5, 0.5, 0.5)
          scene.add(monster)
          meshes.push(monster)
        })
      }

      const house = new House({
        gltfLoader,
        scene,
        meshes,
        modelSrc: '/models/house.glb',
        x: 5,
        y: 0,
        z: 2
      })

      const player = new Player({
        scene,
        meshes,
        cannonWorld,
        gltfLoader,
        modelSrc: '/models/character.glb'
      })
      console.log(player)
      const boxGeometry = new THREE.BoxGeometry(0.5, 5, 0.5)
      const boxMaterial = new THREE.MeshStandardMaterial({
        color: 'seagreen'
      })
      const boxMesh = new THREE.Mesh(boxGeometry, boxMaterial)
      boxMesh.position.y = 0.5
      boxMesh.name = 'box'
      scene.add(boxMesh)
      meshes.push(boxMesh)

      const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5)
      const material = new THREE.MeshBasicMaterial({
        color: 'blue',
        side: THREE.DoubleSide
      })
      const plane = new THREE.Mesh(geometry, material)
      plane.name = 'mypage'
      plane.position.x = -2

      scene.add(plane)
      meshes.push(plane)

      const raycaster = new THREE.Raycaster()
      let mouse = new THREE.Vector2()
      let destinationPoint = new THREE.Vector3()
      let angle = 0
      let isPressed = false // 마우스를 누르고 있는 상태

      // 그리기
      const clock = new THREE.Clock()
      let keys = {}

      function draw() {
        const delta = clock.getDelta()

        let cannonStepTime = 1 / 60
        if (delta < 0.01) cannonStepTime = 1 / 120
        cannonWorld.step(cannonStepTime, delta, 3)

        boxMesh.position.copy(boxBody.position) // 위치
        boxMesh.quaternion.copy(boxBody.quaternion) // 회전
        if (player.modelMesh) {
          player.modelMesh.position.copy(player.cannonBody.position)
          player.modelMesh.quaternion.copy(player.cannonBody.quaternion)
        }
        // 씬에 다 들어가는지?
        if (isLoading === 0 && scene.children.length >= 12) {
          isLoading = 1
          console.log('로딩 끝2')
          emit('loadingEnd')
        }

        if (player.mixer) player.mixer.update(delta)

        if (player.modelMesh) {
          camera.lookAt(player.modelMesh.position)
        }
        if (
          player.modelMesh &&
          props.nowPage === 1 &&
          !monster.value.monster &&
          !myPage.value.myPage &&
          !props.nowNavbar
        ) {
          if (isPressed) {
            raycasting()
          }

          if (player.moving) {
            // 걸어가는 상태
            walk()
            angle = Math.atan2(
              destinationPoint.z - player.modelMesh.position.z,
              destinationPoint.x - player.modelMesh.position.x
            )
            player.modelMesh.position.x += Math.cos(angle) * 0.02
            player.modelMesh.position.z += Math.sin(angle) * 0.02
            player.cannonBody.position.x += Math.cos(angle) * 0.02
            player.cannonBody.position.z += Math.sin(angle) * 0.02

            camera.position.x = cameraPosition.x + player.modelMesh.position.x
            camera.position.z = cameraPosition.z + player.modelMesh.position.z

            player.actions[0].stop()
            player.actions[2].stop()
            player.actions[3].stop()
            player.actions[1].play()

            if (
              Math.abs(destinationPoint.x - player.modelMesh.position.x) <
                0.02 &&
              Math.abs(destinationPoint.z - player.modelMesh.position.z) < 0.02
            ) {
              player.moving = false
              console.log('멈춤')
            }

            if (
              Math.abs(spotMesh.position.x - player.modelMesh.position.x) <
                1.5 &&
              Math.abs(spotMesh.position.z - player.modelMesh.position.z) < 1.5
            ) {
              if (!house.visible) {
                console.log('나와')
                house.visible = true
                spotMesh.material.color.set('seagreen')
                gsap.to(house.modelMesh.position, {
                  duration: 1,
                  y: 1,
                  ease: 'Bounce.easeOut'
                })
                gsap.to(camera.position, {
                  duration: 1,
                  y: 3
                })
                setTimeout(() => {
                  alert('집에 들어감')
                  emit('now')
                }, 1000)
              }
            } else if (house.visible) {
              console.log('들어가')
              house.visible = false
              spotMesh.material.color.set('yellow')
              gsap.to(house.modelMesh.position, {
                duration: 0.5,
                y: -1.3
              })
              gsap.to(camera.position, {
                duration: 1,
                y: 5
              })
            }
          } else {
            // 서 있는 상태
            if (player.rumba) {
              player.actions[1].stop()
              player.actions[3].stop()
              player.actions[2].play()
            } else if (player.hiphop) {
              player.actions[1].stop()
              player.actions[2].stop()
              player.actions[3].play()
            } else {
              player.actions[1].stop()
              player.actions[0].play()
            }
          }
        }

        renderer.render(scene, camera)
        renderer.setAnimationLoop(draw)
      }
      function checkIntersects() {
        raycaster.setFromCamera(mouse, camera)
        const intersects = raycaster.intersectObjects(meshes)
        for (const item of intersects) {
          // if (item.object.name === 'floor') {
          //   destinationPoint.x = item.point.x
          //   destinationPoint.z = item.point.z
          //   player.modelMesh.lookAt(destinationPoint)

          //   player.moving = true

          //   pointerMesh.position.x = destinationPoint.x
          //   pointerMesh.position.z = destinationPoint.z
          // }

          if (item.object.name === 'mypage') {
            isPressed = false
            myPage.value.myPage = true
          }
          if (item.object.name === 'box') {
            onClick()
            isPressed = false
          }
          // 몬1_2 형태로 object.name 옴 / 몬스터 눌렀을때 detail 받아서 저장
          if (item.object.name[0] === '몬') {
            isPressed = false
            let monsterId = item.object.name[1]
            axios({
              url: BASE_URL + '/api/v1/monster/' + monsterId,
              method: 'GET',
              headers: {
                AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
              }
            })
              .then((res) => {
                monsterDetail.value.monsterDetail = res.data
                monster.value.monster = true
              })
              .catch((err) => {
                console.log(err)
              })
          }
          break
        }
      }

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

      // 마우스 좌표를 three.js에 맞게 변환
      function calculateMousePosition(e) {
        mouse.x = (e.clientX / canvas.clientWidth) * 2 - 1
        mouse.y = -((e.clientY / canvas.clientHeight) * 2 - 1)
      }

      // 변환된 마우스 좌표를 이용해 래이캐스팅
      function raycasting() {
        raycaster.setFromCamera(mouse, camera)
        checkIntersects()
      }

      // 클릭할 수 있으면 커서 변경하기 (지금 안먹는듯)
      function onPointerMove(e) {
        mouse.x = (e.clientX / window.innerWidth) * 2 - 1
        mouse.y = -((e.clientY / window.innerHeight) * 2 - 1)

        raycaster.setFromCamera(mouse, camera)
        const intersects = raycaster.intersectObjects(meshes)

        if (intersects && intersects.length > 0) {
          document.body.style.cursor = 'pointer'
        } else {
          document.body.style.cursor = 'default'
        }
      }

      // 마우스 이벤트
      canvas.addEventListener('mousedown', (e) => {
        isPressed = true
        calculateMousePosition(e)
      })
      canvas.addEventListener('mouseup', () => {
        isPressed = false
      })
      canvas.addEventListener('mousemove', (e) => {
        if (isPressed) {
          calculateMousePosition(e)
        }
        if (props.nowPage === 1) {
          onPointerMove(e)
        }
      })

      // 터치 이벤트
      canvas.addEventListener('touchstart', (e) => {
        isPressed = true
        calculateMousePosition(e.touches[0])
      })
      canvas.addEventListener('touchend', () => {
        isPressed = false
      })
      canvas.addEventListener('touchmove', (e) => {
        if (isPressed) {
          calculateMousePosition(e.touches[0])
        }
      })

      const keyController = new KeyController()

      function walk() {
        if (keyController.keys['KeyW'] || keyController.keys['ArrowUp']) {
          destinationPoint.z = player.modelMesh.position.z - 1
        }
        if (keyController.keys['KeyS'] || keyController.keys['ArrowDown']) {
          destinationPoint.z = player.modelMesh.position.z + 1
        }
        if (keyController.keys['KeyD'] || keyController.keys['ArrowRight']) {
          destinationPoint.x = player.modelMesh.position.x + 1
        }
        if (keyController.keys['KeyA'] || keyController.keys['ArrowLeft']) {
          destinationPoint.x = player.modelMesh.position.x - 1
        }
        if (player.modelMesh.position.z) {
          // console.log(destinationPoint.z, player.modelMesh.position.z)
        }
        player.modelMesh.lookAt(destinationPoint)
      }
      window.addEventListener('keydown', (e) => {
        console.log(e.key)
        if (
          e.key === 'a' ||
          e.key === 's' ||
          e.key === 'd' ||
          e.key === 'w' ||
          e.key === 'A' ||
          e.key === 'S' ||
          e.key === 'D' ||
          e.key === 'W' ||
          e.key === 'ArrowDown' ||
          e.key === 'ArrowUp' ||
          e.key === 'ArrowLeft' ||
          e.key === 'ArrowRight'
        ) {
          if (!keys[e.key]) {
            keys[e.key] = 1
          }
          player.moving = true
          player.rumba = false
          player.hiphop = false
        } else if (e.key === 'p') {
          player.moving = false
          player.rumba = true
          player.hiphop = false
        } else if (e.key === 'o') {
          player.moving = false
          player.rumba = false
          player.hiphop = true
        }
      })
      window.addEventListener('keyup', (e) => {
        delete keys[e.key]
        if (!Object.keys(keys).length) {
          player.moving = false
          player.rumba = false
          player.hiphop = false
        }
        if (
          e.key === 'a' ||
          e.key === 'd' ||
          e.key === 'A' ||
          e.key === 'D' ||
          e.key === 'ArrowLeft' ||
          e.key === 'ArrowRight'
        ) {
          destinationPoint.x = player.modelMesh.position.x
        }
        if (
          e.key === 'w' ||
          e.key === 's' ||
          e.key === 'W' ||
          e.key === 'S' ||
          e.key === 'ArrowUp' ||
          e.key === 'ArrowDown'
        ) {
          destinationPoint.z = player.modelMesh.position.z
        }
        if (keys === {}) {
          player.moving = false
        }
      })
      draw()

      function onClick() {
        alert('aa')
        emit('changeCanvas')
      }
    }, 100)

    function fetchUserMonster() {
      axios({
        url: BASE_URL + '/api/v1/monster',
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          userMonster.value.userMonster = res.data
          console.log('axios 내부', userMonster.value.userMonster)
        })
        .catch((err) => {
          console.log(err)
        })
    }

    function monsterClose() {
      monster.value.monster = false
    }

    function mypageClose() {
      myPage.value.myPage = false
    }

    onMounted(() => fetchUserMonster())

    return {
      userInfo,
      fetchUserMonster,
      monsterClose,
      userMonster,
      monster,
      monsterDetail,
      mypageClose,
      myPage
    }
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
