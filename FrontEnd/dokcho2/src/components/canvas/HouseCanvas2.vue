<template>
  <div>
    <div id="house"></div>
    <myPage v-if="modal" />
  </div>
</template>

<script>
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { Octree } from 'three/examples/jsm/math/Octree.js'
import { Capsule } from 'three/examples/jsm/math/Capsule.js'

import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'
import axios from 'axios'
import { BASE_URL } from '@/constant/BASE_URL'
import Swal from 'sweetalert2'

import myPage from '../accounts/myPage.vue'

let scene = null
let camera = null
let renderer = null

export default {
  name: 'HouseView',
  components: {
    myPage
  },
  props: {
    nowPage: Number
  },
  data() {
    return {
      previousDirectionOffset: 0,
      speed: 0,
      maxSpeed: 0,
      acceleration: 0,
      bOnTheGround: false,
      jump: false,
      fallingAcceleration: 0,
      fallingSpeed: 0,
      isjumped: false,
      isPressed: false,

      //raycaster
      raycaster: new THREE.Raycaster(),
      mouse: new THREE.Vector2(),
      meshes: [],

      // monsterdetail
      monster: false,
      monsterDetail: {},

      // account modal
      modal: false
    }
  },
  methods: {
    // 1. emit 코드
    changeCanvas() {
      this.$emit('changeCanvas')
    },

    // 2. 컴포넌트 관련 코드

    // myPage 열고 닫는 코드
    openModal() {
      this.modal = true
    },
    closeModal() {
      this.modal = false
    },

    // 3. init
    init() {
      this.fallingAcceleration = 0
      this.fallingSpeed = 0

      // 3-1. canvas
      const divContainer = document.querySelector('#house')
      this._divContainer = divContainer

      // 3-2. scene
      scene = new THREE.Scene()
      this._scene = scene

      // 3-3. renderer

      renderer = new THREE.WebGLRenderer({ antialias: true })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)
      divContainer.appendChild(renderer.domElement)

      renderer.shadowMap.enabled = true
      renderer.shadowMap.type = THREE.VSMShadowMap

      this._renderer = renderer

      // 3-4. setting

      this._setupCamera()
      this._setupLight()
      this._setupBack()
      this._setupModel()
      this._setupControls()

      // 3-5. etc

      window.onresize = this.resize.bind(this)
      this.resize()

      requestAnimationFrame(this.render.bind(this))
    },

    // 4. setting

    // 4-1. camera

    _setupCamera() {
      camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        1,
        5000
      )

      camera.position.set(0, 100, 500)
      this._camera = camera
    },

    // 4-2. light
    _addPointLight(x, y, z, helperColor) {
      const color = 0xffffff
      const intensity = 1.5

      const pointLight = new THREE.PointLight(color, intensity, 2000)
      pointLight.position.set(x, y, z)

      const pointLightHelper = new THREE.PointLightHelper(
        pointLight,
        10,
        helperColor
      )

      this._scene.add(pointLight, pointLightHelper)
    },

    _setupLight() {
      const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)

      this._addPointLight(500, 150, 500, 0xff0000)
      this._addPointLight(-500, 150, 500, 0xffff00)
      this._addPointLight(-500, 150, -500, 0x00ff00)
      this._addPointLight(500, 150, -500, 0x0000ff)

      const shadowLight = new THREE.DirectionalLight(0xffffff, 0.2)
      shadowLight.position.set(200, 500, 200)
      shadowLight.target.position.set(0, 0, 0)
      const directionalLightHelper = new THREE.DirectionalLightHelper(
        shadowLight,
        10
      )

      shadowLight.castShadow = true
      shadowLight.shadow.mapSize.width = 1024
      shadowLight.shadow.mapSize.height = 1024
      shadowLight.shadow.camera.top = shadowLight.shadow.camera.right = 700
      shadowLight.shadow.camera.bottom = shadowLight.shadow.camera.left = -700
      shadowLight.shadow.camera.near = 100
      shadowLight.shadow.camera.far = 900
      shadowLight.shadow.radius = 5
      const shadowCameraHelper = new THREE.CameraHelper(
        shadowLight.shadow.camera
      )

      this._scene.add(
        ambientLight,
        directionalLightHelper,
        shadowLight,
        shadowLight.target,
        shadowCameraHelper
      )
    },

    // 4-3. control

    _setupControls() {
      this._controls = new OrbitControls(
        this._camera,
        this._renderer.domElement
      )
      this._controls.target.set(0, 100, 0)
      this._controls.enablePan = false
      this._controls.enableDamping = true

      this._pressedKeys = {}

      document.addEventListener('keydown', (event) => {
        console.log(event.key.toLowerCase())
        this._pressedKeys[event.key.toLowerCase()] = true
        this._processAnimation()
      })

      document.addEventListener('keyup', (event) => {
        this._pressedKeys[event.key.toLowerCase()] = false
        this._processAnimation()
      })

      // EventListner

      // 클릭 이벤트 바인딩
      document.addEventListener('dblclick', (e) => {
        this.mouse.x = (e.clientX / window.innerWidth) * 2 - 1
        this.mouse.y = -((e.clientY / window.innerHeight) * 2 - 1)
        console.log(this.mouse.x, this.mouse.y)
        this.checkIntersects()
      })

      // pointer 이동 커서 변환 함수
      document.addEventListener('pointermove', (e) => {
        if (this.nowPage === 1) {
          this.onPointerMove(e)
        }
      })
    },

    _jump() {
      this.jump = true
      this.isjumped = true
      setTimeout(() => {
        this.jump = false
      }, 400)
      setTimeout(() => {
        this.isjumped = false
      }, 1000)
    },

    _directionOffset() {
      const pressedKeys = this._pressedKeys
      let directionOffset = 0 // w

      if (pressedKeys['w']) {
        if (pressedKeys[' '] && this.isjumped === false) {
          this._jump()
          if (pressedKeys['a']) {
            directionOffset = Math.PI / 4 // w+a (45도)
          } else if (pressedKeys['d']) {
            directionOffset = -Math.PI / 4 // w+d (-45도)
          }
        } else {
          if (pressedKeys['a']) {
            directionOffset = Math.PI / 4 // w+a (45도)
          } else if (pressedKeys['d']) {
            directionOffset = -Math.PI / 4 // w+d (-45도)
          }
        }
      } else if (pressedKeys['s']) {
        if (pressedKeys[' '] && this.isjumped === false) {
          this._jump()
          if (pressedKeys['a']) {
            directionOffset = Math.PI / 4 + Math.PI / 2 // s+a (135도)
          } else if (pressedKeys['d']) {
            directionOffset = -Math.PI / 4 - Math.PI / 2 // s+d (-135도)
          } else {
            directionOffset = Math.PI // s (180도)
          }
        } else {
          if (pressedKeys['a']) {
            directionOffset = Math.PI / 4 + Math.PI / 2 // s+a (135도)
          } else if (pressedKeys['d']) {
            directionOffset = -Math.PI / 4 - Math.PI / 2 // s+d (-135도)
          } else {
            directionOffset = Math.PI // s (180도)
          }
        }
      } else if (pressedKeys['a']) {
        if (pressedKeys[' '] && this.isjumped === false) {
          this._jump()
          directionOffset = Math.PI / 2 // a (90도)
        } else {
          directionOffset = Math.PI / 2 // a (90도)
        }
      } else if (pressedKeys['d']) {
        if (pressedKeys[' '] && this.isjumped === false) {
          this._jump()
          directionOffset = -Math.PI / 2 // d (-90도)
        } else {
          directionOffset = -Math.PI / 2 // d (-90도)
        }
      } else {
        directionOffset = this.previousDirectionOffset
      }

      this.previousDirectionOffset = directionOffset

      return directionOffset
    },

    // 4-4. octree

    _setupOctree(model) {
      this._worldOctree = new Octree()
      this._worldOctree.fromGraphNode(model)
    },

    // 4-5. map

    async _setupBack() {
      const loader = new GLTFLoader()

      await loader.load('/models/toonisland.glb', (gltf) => {
        gltf.scene.scale.set(50, 50, 50)
        const model = gltf.scene

        model.traverse((child) => {
          if (child instanceof THREE.Mesh) {
            child.castShadow = true
            child.receiveShadow = true
          }
        })

        this._scene.add(model)
        this._setupOctree(model)
      })
    },

    // 4-6. model

    _setupModel() {
      const loader = new GLTFLoader()

      loader.load('/models/character.glb', (gltf) => {
        gltf.scene.scale.set(10, 10, 10)
        const model = gltf.scene
        // model.position.set(10, 10, 10)

        model.traverse((child) => {
          if (child instanceof THREE.Mesh) {
            child.castShadow = true
          }
        })

        const animationClips = gltf.animations // THREE.AnimationClip[]
        const mixer = new THREE.AnimationMixer(model)
        const animationsMap = {}
        animationClips.forEach((clip) => {
          const name = clip.name
          animationsMap[name] = mixer.clipAction(clip) // THREE.AnimationAction
        })

        this._mixer = mixer

        const box = new THREE.Box3().setFromObject(model)
        model.position.y = (box.max.y - box.min.y) / 2

        const height = box.max.y - box.min.y
        const diameter = box.max.z - box.min.z
        // console.log(diameter)

        model._capsule = new Capsule(
          new THREE.Vector3(0, diameter / 2, 0),
          new THREE.Vector3(0, height - diameter / 2, 0),
          diameter / 2
        )

        const axisHelper = new THREE.AxesHelper(1000)
        const boxHelper = new THREE.BoxHelper(model)
        this._boxHelper = boxHelper
        this._model = model

        const boxG = new THREE.BoxGeometry(100, 100, 100)
        const boxM = new THREE.MeshStandardMaterial({ color: 'plum' })
        const boxbox = new THREE.Mesh(boxG, boxM)
        boxbox.name = ['monster', 1]
        boxbox.receiveShadow = true
        boxbox.castShadow = true
        boxbox.position.set(0, -1, 0)

        // map 이동용

        const boxG2 = new THREE.BoxGeometry(50, 50, 50)
        const boxM2 = new THREE.MeshStandardMaterial({ color: 'green' })
        const boxbox2 = new THREE.Mesh(boxG2, boxM2)
        boxbox2.name = 'move'
        boxbox2.receiveShadow = true
        boxbox2.castShadow = true
        boxbox2.position.set(100, 100, 200)

        // 개인정보수정
        const geometry = new THREE.PlaneGeometry(100, 100)
        const material = new THREE.MeshBasicMaterial({
          color: 'blue',
          side: THREE.DoubleSide
        })
        const plane = new THREE.Mesh(geometry, material)
        plane.name = 'account'
        plane.position.set(-100, -50, 100)

        this._scene.add(model, axisHelper, boxHelper, boxbox, boxbox2, plane)
        this.meshes.push(boxbox, boxbox2, plane)
        this._worldOctree.fromGraphNode(boxbox, boxbox2, plane)
      })
    },

    // 4-7. animation

    _processAnimation() {
      const previousAnimationAction = this._currentAnimationAction

      if (this.nowPage === 1 && this.modal === false) {
        if (
          this._pressedKeys['w'] ||
          this._pressedKeys['a'] ||
          this._pressedKeys['s'] ||
          this._pressedKeys['d'] ||
          this._pressedKeys['shift']
        ) {
          this.maxSpeed = 350
          this.acceleration = 3
        } else if (this._pressedKeys[' '] && this.isjumped === false) {
          this.bOnTheGround = false
          this.jump = true
          this.isjumped = true
          setTimeout(() => {
            this.jump = false
          }, 400)
          setTimeout(() => {
            this.isjumped = false
          }, 1000)
        } else {
          this.speed = 0
          this.maxSpeed = 0
          this.acceleration = 0
        }

        if (previousAnimationAction !== this._currentAnimationAction) {
          previousAnimationAction.fadeOut(0.5)
          this._currentAnimationAction.reset().fadeIn(0.5).play()
        }
      }
    },

    // 5. 기타 코드

    // raycaster : hover시 커서 변경 함수
    onPointerMove(e) {
      this.mouse.x = (e.clientX / window.innerWidth) * 2 - 1
      this.mouse.y = -((e.clientY / window.innerHeight) * 2 - 1)

      this.raycaster.setFromCamera(this.mouse, this._camera)
      const intersects = this.raycaster.intersectObjects(this.meshes)

      if (intersects && intersects.length > 0) {
        document.body.style.cursor = 'pointer'
      } else {
        document.body.style.cursor = 'default'
      }
    },

    // raycaster : check click event
    checkIntersects() {
      this.raycaster.setFromCamera(this.mouse, this._camera)
      const intersects = this.raycaster.intersectObjects(this.meshes)

      if (intersects.length > 0) {
        for (const item of intersects) {
          console.log(item.object.name)
          if (item.object.name[0] === 'monster') {
            let monsterId = item.object.name[1]
            console.log(monsterId)
            axios({
              url: BASE_URL + '/api/v1/monster/' + monsterId,
              method: 'GET',
              headers: {
                AUTHORIZATION: 'Bearer ' + localStorage.getItem('accessToken')
              }
            })
              .then((res) => {
                this.monsterDetail = res.data

                Swal.fire(`${this.monsterDetail.name}`)
                this.showMonster()
              })
              .catch((err) => {
                console.log(err)
              })
          } else if (item.object.name === 'move') {
            this.changeCanvas()
          } else if (item.object.name === 'account') {
            this.openModal()
          }
        }
      }
    },

    // 6. update, render, resize

    update(time) {
      time *= 0.001 // second unit

      this._controls.update()

      if (this._boxHelper) {
        this._boxHelper.update()
      }

      // this._fps.update()

      if (this._mixer) {
        const deltaTime = time - this._previousTime
        this._mixer.update(deltaTime)

        const angleCameraDirectionAxisY =
          Math.atan2(
            this._camera.position.x - this._model.position.x,
            this._camera.position.z - this._model.position.z
          ) + Math.PI

        const rotateQuarternion = new THREE.Quaternion()
        rotateQuarternion.setFromAxisAngle(
          new THREE.Vector3(0, 1, 0),
          angleCameraDirectionAxisY + this._directionOffset()
        )

        this._model.quaternion.rotateTowards(
          rotateQuarternion,
          THREE.MathUtils.degToRad(5)
        )

        const walkDirection = new THREE.Vector3()
        this._camera.getWorldDirection(walkDirection)

        //walkDirection.y = 0;
        if (!this.bOnTheGround) {
          walkDirection.y = -1
        }
        if (this.jump) {
          walkDirection.y = 1
        }

        walkDirection.normalize()

        walkDirection.applyAxisAngle(
          new THREE.Vector3(0, 1, 0),
          this._directionOffset()
        )

        if (this.speed < this.maxSpeed) this.speed += this.acceleration
        else this.speed -= this.acceleration * 2

        if (!this.bOnTheGround) {
          this.fallingSpeed = 300
        } else if (this.jump) {
          this.fallingSpeed = 600
        } else {
          this.fallingAcceleration = 0
          this.fallingSpeed = 0
        }

        const velocity = new THREE.Vector3(
          walkDirection.x * this.speed,
          walkDirection.y * this.fallingSpeed,
          walkDirection.z * this.speed
        )

        const deltaPosition = velocity.clone().multiplyScalar(deltaTime)

        this._model._capsule.translate(deltaPosition)

        const result = this._worldOctree.capsuleIntersect(this._model._capsule)
        if (result) {
          // 충돌한 경우
          this._model._capsule.translate(
            result.normal.multiplyScalar(result.depth)
          )
          this.bOnTheGround = true
        } else {
          // 충돌하지 않은 경우
          this.bOnTheGround = false
        }

        const previousPosition = this._model.position.clone()
        const capsuleHeight =
          this._model._capsule.end.y -
          this._model._capsule.start.y +
          this._model._capsule.radius * 2
        this._model.position.set(
          this._model._capsule.start.x,
          this._model._capsule.start.y -
            this._model._capsule.radius +
            capsuleHeight / 2,
          this._model._capsule.start.z
        )

        this._camera.position.x -= previousPosition.x - this._model.position.x
        this._camera.position.z -= previousPosition.z - this._model.position.z

        this._controls.target.set(
          this._model.position.x,
          this._model.position.y,
          this._model.position.z
        )
      }
      this._previousTime = time
    },

    render(time) {
      this._renderer.render(this._scene, this._camera)
      this.update(time)

      requestAnimationFrame(this.render.bind(this))
    },

    resize() {
      this._camera.aspect = window.innerWidth / window.innerHeight
      this._camera.updateProjectionMatrix()

      this._renderer.setSize(window.innerWidth, window.innerHeight)
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style scoped>
* {
  outline: none;
  margin: 0;
}
</style>
