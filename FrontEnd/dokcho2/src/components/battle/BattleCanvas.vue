<template>
  <div>
    <button @click="doAttack">dd</button>
    <div id="battle">
      <battle-status
        id="status"
        :myHpBar="myHpBar"
        :enemyHpBar="enemyHpBar"
      ></battle-status>
      <div id="console">
        <p v-show="this.status === 'start'">적을 만남!!!</p>
      </div>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'

import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'
// import Stats from 'three/examples/jsm/libs/stats.module.js'

import BattleStatus from './BattleStatus.vue'

export default {
  name: 'BattleCanvas',
  props: {
    nowPage: Number
  },
  components: { BattleStatus },
  data() {
    return {
      turn: 1,
      status: 'start',
      first: '',
      second: '',

      myMaxHp: 100,
      myHp: 100,
      myHpBar: '101%',
      myAttack: 10,
      myDefense: 10,
      mySpeed: 20,
      myTech: [
        { name: '공격', type: 'att', value: 3 },
        { name: '버프', type: 'buff', value: 0.5 }
      ],

      enemyMaxHp: 100,
      enemyHp: 100,
      enemyHpBar: '101%',
      enemyAttack: 10,
      enemyDefense: 10,
      enemySpeed: 10,
      enemyTech: [
        { name: '공격', type: 'att', value: 4 },
        { name: '버프', type: 'buff', value: 0.2 }
      ]
    }
  },

  mounted() {
    this.init()
  },

  methods: {
    init() {
      const divContainer = document.querySelector('#battle')
      this._divContainer = divContainer

      const renderer = new THREE.WebGLRenderer({ antialias: true })
      renderer.setPixelRatio(window.devicePixelRatio)
      divContainer.appendChild(renderer.domElement)

      renderer.shadowMap.enabled = true
      renderer.shadowMap.type = THREE.VSMShadowMap

      this._renderer = renderer

      const scene = new THREE.Scene()
      this._scene = scene

      //this._setupOctree();
      this._setupCamera()
      this._setupLight()
      this._setupBack()
      this._setupModel()
      this._setupEnemy()
      this._setupControls()

      window.onresize = this.resize.bind(this)
      this.resize()

      requestAnimationFrame(this.render.bind(this))
    },

    _setupControls() {
      this._controls = new OrbitControls(this._camera, this._divContainer)
      this._controls.target.set(0, 100, 0)
      this._controls.enablePan = false
      this._controls.enableDamping = true
    },

    _processAnimation() {
      const previousAnimationAction = this._currentAnimationAction
      if (this.nowPage === 0) {
        if (
          this._pressedKeys['w'] ||
          this._pressedKeys['a'] ||
          this._pressedKeys['s'] ||
          this._pressedKeys['d']
        ) {
          this.maxSpeed = 350
          this.acceleration = 3
          //   if (this._pressedKeys['shift']) {
          //     this._currentAnimationAction = this._animationMap['Run']
          //     // this.speed = 350;
          //     this.maxSpeed = 350
          //     this.acceleration = 3
          //   } else {
          //     this._currentAnimationAction = this._animationMap['Walk']
          //     //this.speed = 80;
          //     this.maxSpeed = 80
          //     this.acceleration = 3
          //   }
        } else {
          // this._currentAnimationAction = this._animationMap['Idle']
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

    _setupModel() {
      const loader = new GLTFLoader()

      loader.load('/models/character.glb', (gltf) => {
        gltf.scene.scale.set(10, 10, 10)
        const model = gltf.scene
        this._scene.add(model)

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
          console.log(name)
          animationsMap[name] = mixer.clipAction(clip) // THREE.AnimationAction
        })

        this._mixer = mixer
        // this._animationMap = animationsMap
        // this._currentAnimationAction = this._animationMap['Idle']
        // this._currentAnimationAction.play()

        model.position.set(100, 0, 100)

        const axisHelper = new THREE.AxesHelper(1000)
        this._scene.add(axisHelper)

        const boxHelper = new THREE.BoxHelper(model)
        this._scene.add(boxHelper)
        this._boxHelper = boxHelper
        this._model = model
      })
    },

    _setupEnemy() {
      const enemyLoader = new GLTFLoader()

      enemyLoader.load('/models/enemy.glb', (gltf) => {
        gltf.scene.scale.set(50, 0, 50)
        const enemyModel = gltf.scene
        this._scene.add(enemyModel)

        enemyModel.traverse((child) => {
          if (child instanceof THREE.Mesh) {
            child.castShadow = true
          }
        })

        const enemyAnimationClips = gltf.animations // THREE.AnimationClip[]
        const enemyMixer = new THREE.AnimationMixer(enemyModel)
        const enemyAnimationsMap = {}
        enemyAnimationClips.forEach((clip) => {
          const name = clip.name
          console.log(name)
          enemyAnimationsMap[name] = enemyMixer.clipAction(clip) // THREE.AnimationAction
        })

        this._enemyMixer = enemyMixer
        // this._animationMap = animationsMap
        // this._currentAnimationAction = this._animationMap['Idle']
        // this._currentAnimationAction.play()

        enemyModel.position.set(-100, 0, -100)

        // const boxHelper = new THREE.BoxHelper(model)
        // this._scene.add(boxHelper)
        // this._enemyBoxHelper = boxHelper
        // this._enemyModel = model
      })
    },

    _setupBack() {
      const textureLoader = new THREE.TextureLoader()
      const floorTexture = textureLoader.load('/images/grid.png')
      floorTexture.wrapS = THREE.RepeatWrapping
      floorTexture.wrapT = THREE.RepeatWrapping
      floorTexture.repeat.x = 10
      floorTexture.repeat.y = 10

      const floorMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(1000, 1000),
        new THREE.MeshStandardMaterial({
          color: 0xffcc00
        })
      )
      floorMesh.name = 'floor'
      floorMesh.rotation.x = -Math.PI / 2
      floorMesh.receiveShadow = true
      this._scene.add(floorMesh)
    },

    _setupCamera() {
      const camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        1,
        5000
      )

      camera.position.set(0, 100, 500)
      this._camera = camera
    },

    _addPointLight(x, y, z, helperColor) {
      const color = 0xffffff
      const intensity = 1.5

      const pointLight = new THREE.PointLight(color, intensity, 2000)
      pointLight.position.set(x, y, z)

      this._scene.add(pointLight)

      const pointLightHelper = new THREE.PointLightHelper(
        pointLight,
        10,
        helperColor
      )
      this._scene.add(pointLightHelper)
    },

    _setupLight() {
      const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
      this._scene.add(ambientLight)

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
      this._scene.add(directionalLightHelper)

      this._scene.add(shadowLight)
      this._scene.add(shadowLight.target)

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
      this._scene.add(shadowCameraHelper)
    },

    update(time) {
      time *= 0.001 // second unit

      this._controls.update()

      // this._fps.update()
      if (this._mixer) {
        this._mixer.update(time)
        if (this._enemyMixer) {
          this._enemyMixer.update(time)
        }
      }

      // if (this._enemyMixer) {
      //   this._enemyMixer.update(time)
      // }
    },

    render(time) {
      this._renderer.render(this._scene, this._camera)
      this.update(time)

      requestAnimationFrame(this.render.bind(this))
    },

    resize() {
      const width = this._divContainer.clientWidth
      const height = this._divContainer.clientHeight

      this._camera.aspect = width / height
      this._camera.updateProjectionMatrix()

      this._renderer.setSize(width, height)
    },

    changeCanvas() {
      this.$emit('changeCanvas')
    },

    changeTurn() {
      this.turn += 1
    },

    changeStatus() {
      if (this.status == 'select') {
        this.status = 'act'
      } else if (this.status == 'act') {
        this.status = 'result'
      } else {
        this.status = 'select'
      }
    },

    act() {
      if (this.speed > this.enemySpeed) {
        this.myAct()
        this.enemyAct()
      } else if (this.speed < this.enemySpeed) {
        this.myAct()
        this.enemyAct()
      } else {
        const selectFirst = Math.random()
        if (selectFirst >= 0.5) {
          this.myAct()
          this.enemyAct()
        } else {
          this.enemyAct()
          this.myAct()
        }
      }
    },

    myAct() {},

    enemyAct() {},

    doAttack() {
      //   const damage = this.myAttack * val - this.enemyDefense
      const damage = this.myAttack * this.myTech[0].value - this.enemyDefense
      const nowHp = this.myHp - damage
      this.myHpBar = Math.round((nowHp / this.myMaxHp) * 100) + '%'
      console.log(this.myHpBar)

      // document.querySelector('#enemyHp').style.width = `${nowHpBar}%`
    }
  }
}
</script>

<style scoped>
* {
  outline: none;
  margin: 0;
}

#battle {
  width: 600px;
  height: 600px;
}

#status {
  position: absolute;
  z-index: 1;
}

#console {
  position: absolute;
  top: 540px;

  width: 600px;
  height: 100px;
  background-color: white;
}
</style>
