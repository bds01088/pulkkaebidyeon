<template>
  <div>
    <canvas id="WorldCanvas"> </canvas>
    <TalkComponent
      v-if="isTalk.talk"
      @talkClose="talkClose"
      @quizStart="quizStart"
      :isTalk="isTalk"
    />
    <QuizComponent v-if="isQuiz.quiz" @quizClose="quizClose" />
    <miniGame1 v-if="miniGame1.miniGame1" @miniGame1Close="miniGame1Close" />
    <miniGame2 v-if="miniGame1.miniGame2" @miniGame2Close="miniGame2Close" />
    <miniGame3 v-if="miniGame1.miniGame3" @miniGame3Close="miniGame3Close" />
  </div>
</template>

<script>
import * as THREE from 'three'
import axios from 'axios'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { Player } from '../modules/Player'
import { House } from '../modules/House'
import { Character } from '../modules/Character'
import { Building } from '../modules/Building'
import { Environment } from '../modules/Environment'
import { Environments } from '../modules/Environments'
import { FBXLoad } from '../modules/FBXLoader'
import { myMon } from '../modules/MyMon'
import { Wall } from '../modules/Wall'
import { KeyController } from '../modules/CharacterControl'
import gsap from 'gsap'
import * as CANNON from 'cannon-es'
import TalkComponent from '../script/TalkComponent.vue'
import QuizComponent from '../script/QuizComponent.vue'
import { ref } from 'vue'

import { BASE_URL } from '@/constant/BASE_URL'

import miniGame1 from '@/components/minigame/miniGame1'
import miniGame2 from '@/components/minigame/miniGame2'
import miniGame3 from '@/components/minigame/miniGame3'

export default {
  name: 'WorldCanvas',
  props: {
    nowPage: Number,
    nowNavbar: Boolean
  },
  components: {
    TalkComponent: TalkComponent,
    QuizComponent: QuizComponent,
    miniGame1: miniGame1,
    miniGame2: miniGame2,
    miniGame3: miniGame3
  },
  setup(props, { emit }) {
    let isTalk = ref({ talk: false, name: '', content: {} })
    let isQuiz = ref({ quiz: false })
    const miniGame1 = ref({
      miniGame1: false,
      miniGame2: false,
      miniGame3: false
    })
    setTimeout(() => {
      // Texture
      const textureLoader = new THREE.TextureLoader()
      const floorTexture = textureLoader.load('/images/map17.png')
      floorTexture.wrapS = THREE.RepeatWrapping
      floorTexture.wrapT = THREE.RepeatWrapping
      floorTexture.repeat.x = 1
      floorTexture.repeat.y = 1
      let isLoading = 0

      // Renderer
      let canvas = document.querySelector('#WorldCanvas')
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

      const cameraPosition = new THREE.Vector3(0, 35, 0)
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

      // 안 떨어지게 하기
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

      // Mesh
      const meshes = []

      // 바닥 만들기
      const floorMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(150, 150),
        new THREE.MeshStandardMaterial({
          map: floorTexture
        })
      )
      floorMesh.name = 'floor'
      floorMesh.rotation.x = -Math.PI / 2
      floorMesh.receiveShadow = true
      scene.add(floorMesh)

      // 포인터 매쉬 필요없음(삭제 예정)
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

      // 집 앞에 있는 노란 박스(삭제 예정)
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

      // 집(수정 예정)
      const house = new House({
        gltfLoader,
        scene,
        meshes,
        modelSrc: '/models/house.glb',
        x: 5,
        y: 0,
        z: 2
      })

      // 플레이어
      const player = new Player({
        scene,
        meshes,
        cannonWorld,
        gltfLoader,
        modelSrc: '/models/character.glb'
      })

      // 맵 이동하는 박스 만들기(수정 예정)

      const boxGeometry = new THREE.BoxGeometry(0.5, 5, 0.5)
      const boxMaterial = new THREE.MeshStandardMaterial({
        color: 'seagreen'
      })
      const boxMesh = new THREE.Mesh(boxGeometry, boxMaterial)
      boxMesh.position.y = 0.5
      boxMesh.name = 'box'
      scene.add(boxMesh)
      meshes.push(boxMesh)

      // 박스에 캐논 씌우기
      const boxShape = new CANNON.Box(new CANNON.Vec3(0.25, 2.5, 0.25))
      const boxBody = new CANNON.Body({
        mass: 0,
        position: new CANNON.Vec3(0, 0, 0),
        shape: boxShape
      })
      cannonWorld.addBody(boxBody)

      // 맵 막는 박스 만들기
      new Wall({
        cannonWorld,
        x: 68,
        z: 68
      })
      // 위인들

      const Greats = [
        ['단군', { x: -34, y: 0, z: -50 }],
        ['장수왕', { x: -56, y: 0, z: -20 }],
        ['선덕여왕', { x: -5, y: 0, z: -13 }],
        ['공민왕', { x: 35, y: 0, z: 0 }],
        ['세종대왕', { x: -44, y: 0, z: 20 }],
        ['이순신', { x: -15, y: 0, z: 55 }],
        ['유관순', { x: 50, y: 0, z: 42 }]
      ]
      Greats.forEach((element) => {
        new Character({
          scene,
          meshes,
          cannonWorld,
          gltfLoader,
          modelSrc: `/models/Great/${element[0]}.glb`,
          position: element[1],
          name: element[0]
        })
      })

      // 빌런들

      const Villain = [
        ['지현몬', { x: -38, y: 0, z: -45 }],
        ['효근몬', { x: -58, y: 0, z: -17 }],
        ['재준몬', { x: 0, y: 0, z: -10 }],
        ['근희몬', { x: 32, y: 0, z: 5 }],
        ['상균몬', { x: -41, y: 0, z: 17 }],
        ['지원몬', { x: -18, y: 0, z: 52 }],
        ['하민몬', { x: 45, y: 0, z: 40 }]
      ]
      Villain.forEach((element) => {
        new Character({
          scene,
          meshes,
          cannonWorld,
          gltfLoader,
          modelSrc: `/models/Villain/${element[0]}.glb`,
          position: element[1],
          name: element[0]
        })
      })

      // 빌딩들

      const Buildings = [
        ['첨성대', { x: 5, y: 0, z: -30 }],
        ['덕수궁', { x: 45, y: 0, z: -10 }],
        ['광화문', { x: -40, y: 0, z: 45 }]
      ]
      Buildings.forEach((element) => {
        new Building({
          scene,
          meshes,
          cannonWorld,
          gltfLoader,
          modelSrc: `/models/Building/${element[0]}.glb`,
          position: element[1],
          name: element[0]
        })
      })

      // 나무나 그런거들

      Environments.forEach((element) => {
        new Environment({
          scene,
          meshes,
          cannonWorld,
          gltfLoader,
          modelSrc: `/models/Environment/${element[0]}.glb`,
          width: element[2] || {},
          position: element[1],
          name: element[0]
        })
      })
      // new Environment({
      //   scene,
      //   cannonWorld,
      //   gltfLoader
      // })

      // 마을
      const village = [
        ['house1', { x: -67, y: 0, z: 66 }],
        ['house2', { x: -62, y: 0, z: 61 }],
        ['house3', { x: -61, y: 0, z: 63 }],
        ['house4', { x: -58, y: 0, z: 64 }],
        ['house5', { x: -59, y: 0, z: 61 }],
        ['house6', { x: -60, y: 0, z: 68 }]
      ]
      village.forEach((element) => {
        new FBXLoad({
          scene,
          meshes,
          cannonWorld,
          modelSrc: `/models/Environment/${element[0]}.fbx`,
          position: element[1],
          name: element[0]
        })
      })

      // 내 풀깨비
      let myMonsterId = JSON.parse(
        localStorage.getItem('userInfo')
      ).representMonster
      let myMoster = new myMon({
        scene,
        meshes,
        gltfLoader,
        modelSrc: `/models/Monsters/${myMonsterId}.glb`
      })

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

        if (isLoading === 0 && scene.children.length === 155) {
          isLoading = 1
          console.log('로딩 끝1')
          emit('loadingEnd')
        }

        if (player.mixer) player.mixer.update(delta)

        if (player.modelMesh) {
          camera.lookAt(player.modelMesh.position)
        }
        if (
          player.modelMesh &&
          props.nowPage === 0 &&
          !props.nowNavbar &&
          !isTalk.value.talk
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
            player.modelMesh.position.x += Math.cos(angle) * 0.04
            player.modelMesh.position.z += Math.sin(angle) * 0.04
            player.cannonBody.position.x += Math.cos(angle) * 0.04
            player.cannonBody.position.z += Math.sin(angle) * 0.04

            camera.position.x =
              cameraPosition.x + player.modelMesh.position.x + 25
            camera.position.z =
              cameraPosition.z + player.modelMesh.position.z + 55

            player.actions[0].stop()
            player.actions[2].stop()
            player.actions[3].stop()
            player.actions[1].play()

            if (
              Math.abs(destinationPoint.x - player.modelMesh.position.x) <
                0.03 &&
              Math.abs(destinationPoint.z - player.modelMesh.position.z) < 0.03
            ) {
              player.moving = false
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
                  emit('changeCanvas')
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
          if (myMoster.modelMesh) {
            if (
              Math.abs(
                player.modelMesh.position.x - myMoster.modelMesh.position.x
              ) > 2 ||
              Math.abs(
                player.modelMesh.position.z - myMoster.modelMesh.position.z
              ) > 2
            ) {
              myMoster.moving = true
            }
          }

          // 대표풀깨비 따라오기
          if (myMoster.moving) {
            angle = Math.atan2(
              player.modelMesh.position.z - myMoster.modelMesh.position.z,
              player.modelMesh.position.x - myMoster.modelMesh.position.x
            )
            myMoster.modelMesh.position.x += Math.cos(angle) * 0.04
            myMoster.modelMesh.position.z += Math.sin(angle) * 0.04

            myMoster.modelMesh.lookAt(player.modelMesh.position)

            if (
              Math.abs(
                player.modelMesh.position.x - myMoster.modelMesh.position.x
              ) < 1 &&
              Math.abs(
                player.modelMesh.position.z - myMoster.modelMesh.position.z
              ) < 1
            ) {
              myMoster.moving = false
            }
          }
        }

        renderer.render(scene, camera)
        renderer.setAnimationLoop(draw)
      }
      function checkIntersects() {
        raycaster.setFromCamera(mouse, camera)
        console.log(meshes)
        const intersects = raycaster.intersectObjects(meshes)
        console.log(intersects)
        for (const item of intersects) {
          // if (item.object.name === 'floor') {
          //   destinationPoint.x = item.point.x
          //   destinationPoint.z = item.point.z
          //   player.modelMesh.lookAt(destinationPoint)

          //   // console.log(item.point)

          //   player.moving = true

          //   pointerMesh.position.x = destinationPoint.x
          //   pointerMesh.position.z = destinationPoint.z
          // }
          if (item.object.name === 'box') {
            onClick()
            isPressed = false
          }
          if (item.object.name.slice(0, 1) === '위') {
            talkStart(item.object.name.slice(1, 2))
            isTalk.value.name = item.object.name.slice(2, -2)
            isPressed = false
            const status = ['NOT_YET', 'READY', 'BATTLE_WIN', 'FINISHED']
            setTimeout(() => {
              if (status.includes(isTalk.value.content.status)) {
                isTalk.value.talk = true
              }
            }, 100)
          }
          if (item.object.name.slice(0, 1) === '빌') {
            talkStart(item.object.name.slice(1, 2))
            isTalk.value.name = item.object.name.slice(2, -2)
            isPressed = false
            const status = ['STARTED', 'QUIZ_PASSED']
            setTimeout(() => {
              if (status.includes(isTalk.value.content.status)) {
                isTalk.value.talk = true
              }
            }, 100)
          }
          if (item.object.name.slice(0, 1) === '건') {
            isPressed = false
            if (item.object.name.slice(1, 2) === '1') {
              miniGame1.value.miniGame1 = true
            } else if (item.object.name.slice(1, 2) === '2') {
              miniGame1.value.miniGame2 = true
            } else if (item.object.name.slice(1, 2) === '3') {
              miniGame1.value.miniGame3 = true
            }
            // 건1, 건2, 건3

            // 숫자 따라서 다른 함수 실행 -> 컴포넌트 true값으로 변경
            // myPage.value.myPage = true
            // if (item.object.name[1]) {
            //   miniGame1.value.miniGame1 = true
            // }

            // 바깥에 컴포넌트 false값으로 바꾸는 함수 따로 만들어서 컴포넌트에 달기
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
        if (props.nowPage === 0) {
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
        destinationPoint.y = 0.25
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
        localStorage.setItem(
          'position',
          JSON.stringify({
            x: player.modelMesh.position.x,
            z: player.modelMesh.position.z
          })
        )
      })
      draw()

      function onClick() {
        alert('aa')
        emit('changeCanvas')
        // emit('changeBattle')
      }
    }, 100)

    // 대화를 시작하는 함수(미리 받아야 status를 알고 위인과 빌런을 구분할 수 있음)
    function talkStart(missionId) {
      axios({
        url: BASE_URL + '/api/v1/mission/' + missionId,
        method: 'GET',
        headers: {
          AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
        }
      })
        .then((res) => {
          console.log(res.data)
          isTalk.value.content = res.data
          isTalk.value.content.line = res.data.line.split('\\t')
        })
        .catch((err) => console.log(err))
    }

    function talkClose() {
      isTalk.value.talk = false
    }

    function quizStart() {
      isTalk.value.talk = false
      isQuiz.value.quiz = true
    }

    function quizClose() {
      isQuiz.value.quiz = false
    }

    function miniGame1Close() {
      miniGame1.value.miniGame1 = false
    }

    function miniGame2Close() {
      miniGame1.value.miniGame2 = false
    }

    function miniGame3Close() {
      miniGame1.value.miniGame3 = false
    }

    return {
      isTalk,
      isQuiz,
      miniGame1,
      talkClose,
      quizStart,
      quizClose,
      miniGame1Close,
      miniGame2Close,
      miniGame3Close
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
