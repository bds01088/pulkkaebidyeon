<template>
  <div>
    <div id="battle">
      <battle-status
        id="status"
        :myHpBar="myHpBar"
        :enemyHpBar="enemyHpBar"
      ></battle-status>
    </div>
    <div id="console" @click="changePhase()" style="cursor: pointer">
      <p v-show="this.phase === 'start'">적을 만남!!!</p>
      <p v-show="this.phase === 'ready'">기술을 선택하세요!!!</p>
      <p v-show="this.phase === 'mySelect'">
        <span v-for="(tech, idx) in myTech" :key="idx">
          <button @click="doMySelect(tech)">{{ tech.name }}</button>
        </span>
      </p>
      <p v-show="this.phase === 'myAct'">{{ actMsg[1] }}</p>
      <p v-show="this.phase === 'enemyAct'">{{ actMsg[1] }}</p>
      <p v-show="this.phase === 'enemyResult'">{{ actMsg[1] }}</p>
    </div>
    <div></div>
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
      phase: 'start',
      status: 'normal',
      first: '',

      myMaxHp: 100,
      myHp: 100,
      myHpBar: 100,
      myAttack: 10,
      myDefense: 10,
      mySpeed: 20,
      myTech: [
        { name: '공격', type: 'att', value: 3 },
        { name: '버프', type: 'buff', value: 0.5 }
      ],

      enemyMaxHp: 100,
      enemyHp: 100,
      enemyHpBar: 100,
      enemyAttack: 10,
      enemyDefense: 10,
      enemySpeed: 10,
      enemyTech: [
        { name: '공격', type: 'att', value: 4 },
        { name: '버프', type: 'buff', value: 0.2 }
      ],

      actMsg: [],
      myDamage: 0,
      enemyDamage: 0
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
      // this._setupEnemy()
      this._setupControls()

      window.onresize = this.resize.bind(this)
      this.resize()

      requestAnimationFrame(this.render.bind(this))
    },

    _setupControls() {
      this._controls = new OrbitControls(this._camera, this._divContainer)
      this._controls.target.set(100, 0, -40)
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

    async _setupModel() {
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
          // console.log(name)
          animationsMap[name] = mixer.clipAction(clip) // THREE.AnimationAction
        })

        this._mixer = mixer
        // this._animationMap = animationsMap
        // this._currentAnimationAction = this._animationMap['Idle']
        // this._currentAnimationAction.play()

        model.position.set(-100, 0, 100)

        const axisHelper = new THREE.AxesHelper(1000)
        this._scene.add(axisHelper)

        const boxHelper = new THREE.BoxHelper(model)
        this._scene.add(boxHelper)
        this._boxHelper = boxHelper
        this._model = model
      })

      loader.load('/models/enemy.glb', (gltf) => {
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
          // console.log(name)
          enemyAnimationsMap[name] = enemyMixer.clipAction(clip) // THREE.AnimationAction
        })

        this._enemyMixer = enemyMixer
        // this._animationMap = animationsMap
        // this._currentAnimationAction = this._animationMap['Idle']
        // this._currentAnimationAction.play()

        enemyModel.position.set(100, 0, -100)

        // const boxHelper = new THREE.BoxHelper(model)
        // this._scene.add(boxHelper)
        // this._enemyBoxHelper = boxHelper
        // this._enemyModel = model
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
          // console.log(name)
          enemyAnimationsMap[name] = enemyMixer.clipAction(clip) // THREE.AnimationAction
        })

        this._enemyMixer = enemyMixer
        // this._animationMap = animationsMap
        // this._currentAnimationAction = this._animationMap['Idle']
        // this._currentAnimationAction.play()

        enemyModel.position.set(100, 0, -100)

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

      camera.position.set(-150, 10, 150)
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
      }

      if (this._enemyMixer) {
        this._enemyMixer.update(time)
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
      // const width = this._divContainer.clientWidth
      // const height = this._divContainer.clientHeight

      // this._camera.aspect = width / height
      // this._camera.updateProjectionMatrix()

      // this._renderer.setSize(width, height)

      this._camera.aspect = window.innerWidth / window.innerHeight
      this._camera.updateProjectionMatrix()

      this._renderer.setSize(window.innerWidth, window.innerHeight)
    },

    changeCanvas() {
      this.$emit('changeCanvas')
    },

    changeTurn() {
      this.turn += 1
    },

    chooseFirst() {
      if (this.mySpeed > this.enemySpeed) {
        this.first = 'me'
      } else if (this.mySpeed < this.enemySpeed) {
        this.first = 'enemy'
      } else {
        const selectFirst = Math.random(0, 1)
        if (selectFirst >= 0.5) {
          this.first = 'me'
        } else {
          this.first = 'enemy'
        }
      }
    },

    changePhase() {
      if (this.phase == 'start') {
        this.chooseFirst()
        setTimeout(() => {
          this.phase = 'ready'
        }, 300)
      }

      if (this.phase == 'ready') {
        setTimeout(() => {
          this.phase = 'mySelect'
        }, 300)
      }
    },

    doMySelect(item) {
      if (item.type == 'att') {
        this.myDamage = this.myAttack * item.value - this.enemyDefense
        this.actMsg = ['att', `${this.myDamage}의 피해를 입혔다!!!`]

        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'myAct'
            this.getMyResult()

            setTimeout(() => {
              this.doEnemyAct()
              this.phase = 'enemyAct'
            }, 2000)
          }, 300)
        }
      } else if (item.type == 'buff') {
        this.myAttack += this.myAttack * item.value
        this.actMsg = [
          'buff',
          `${this.myAttack * item.value}만큼 공격력 상승!!!`
        ]

        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'myAct'
            this.getMyResult()

            setTimeout(() => {
              this.doEnemyAct()
              this.phase = 'enemyAct'
            }, 2000)
          }, 300)
        }
      }
    },

    getMyResult() {
      if (this.actMsg[0] === 'att') {
        this.enemyHp -= this.myDamage
        this.enemyHpBar = Math.round((this.enemyHp / this.enemyMaxHp) * 100)
        console.log(this.enemyHpBar)
      }
    },

    doEnemyAct() {
      const roll = Math.random(0, 1)

      if (roll >= 0.3) {
        this.actMsg = [
          'enemyAtt',
          `적은 ${this.enemyTech[0].name}을 사용했다!!!`
        ]
        setTimeout(() => {
          this.getEnemyResult()
          this.phase = 'enemyResult'
        }, 800)
      } else {
        this.actMsg = [
          'enemyBuff',
          `적은 ${this.enemyTech[1].name}을 사용했다!!!`
        ]

        setTimeout(() => {
          this.getEnemyResult()
          this.phase = 'enemyResult'
        }, 800)
      }
    },

    getEnemyResult() {
      if (this.actMsg[0] == 'enemyAtt') {
        this.enemyDamage =
          this.enemyAttack * this.enemyTech[0].value - this.myDefense
        this.actMsg[1] = `${this.enemyDamage}의 피해를 입었다!!!`

        this.myHp -= this.enemyDamage
        this.myHpBar = Math.round((this.myHp / this.myMaxHp) * 100)

        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'ready'
          }, 2000)
        }
      } else if (this.actMsg[0] == 'enemyBuff') {
        this.enemyAttack += this.enemyAttack * this.enemyTech[1].value
        this.actMsg[1] = `${
          this.myAttack * this.enemyTech[1].value
        }만큼 적의 공격력 상승!!!`

        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'ready'
          }, 2000)
        }
      }
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
  width: 100%;
  height: 100%;
}

#status {
  position: absolute;
  z-index: 1;
}

#console {
  position: absolute;
  top: 540px;
  left: 200px;

  width: 1200px;
  height: 100px;
  background-color: white;
  z-index: 1;
}
</style>
