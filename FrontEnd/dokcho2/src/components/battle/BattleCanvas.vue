<template>
  <div>
    <battle-status
      id="status"
      :myHpBar="myHpBar"
      :enemyHpBar="enemyHpBar"
      :begin="begin"
    ></battle-status>

    <div id="battleDiv">
      <div id="battle"></div>
    </div>

    <div id="consoleDiv">
      <div id="console" @click="changePhase()">
        <p v-show="this.phase === 'start'">적을 만남!!!</p>
        <p v-show="this.phase === 'ready'">기술을 선택하세요!!!</p>
        <p v-show="this.phase === 'mySelect'">
          <span v-for="(tech, idx) in myTech" :key="idx">
            <button @click="doMySelect(tech)">{{ tech.name }}</button>
          </span>
        </p>
        <p v-show="this.phase === 'showMySelect'">{{ actMyMsg[1] }}</p>
        <p v-show="this.phase === 'myAct'">{{ actMyMsg[1] }}</p>
        <p v-show="this.phase === 'enemyAct'">{{ actEnemyMsg[1] }}</p>
        <p v-show="this.phase === 'enemyResult'">
          {{ actEnemyMsg[1] }}
        </p>
        <p v-show="this.phase === 'win'" @click="changeBattle()">
          {{ endMsg }}
        </p>
        <p v-show="this.phase === 'lose'" @click="changeBattle()">
          {{ endMsg }}
        </p>
      </div>
      <!-- <button @click="changeBattle()">rr</button> -->
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
      begin: 0,
      turn: 1,
      phase: 'start',
      status: 'normal',
      first: '',

      myMaxHp: 100,
      myHp: 100,
      myHpBar: 100,
      myAttack: 10,
      myDefense: 10,
      mySpeed: 5,
      myTech: [
        { name: '공격', type: 'att', value: 3 },
        { name: '버프', type: 'buff', value: 0.5 }
      ],
      mySelectTech: { name: '', type: '', value: 0 },

      enemyMaxHp: 100,
      enemyHp: 100,
      enemyHpBar: 100,
      enemyAttack: 20,
      enemyDefense: 10,
      enemySpeed: 10,
      enemyTech: [
        { name: '공격', type: 'att', value: 4 },
        { name: '버프', type: 'buff', value: 0.2 }
      ],

      actMyMsg: [],
      actEnemyMsg: [],
      myDamage: 0,
      enemyDamage: 0,

      endMsg: ''
    }
  },

  // mounted() {
  //   this.init()
  // },

  watch: {
    nowPage() {
      if (this.nowPage == 3) {
        this.begin += 1
        const battleDiv = document.querySelector('#battleDiv')
        const battle = document.querySelector('#battle')
        battle.remove()

        const newBattle = document.createElement('div')
        newBattle.id = 'battle'
        battleDiv.appendChild(newBattle)

        // 초기화
        this.phase = 'start'
        this.myMaxHp = 100
        this.myHp = 100
        this.myHpBar = 100
        this.enemyMaxHp = 100
        this.enemyHp = 100
        this.enemyHpBar = 100

        this.init()
      }
    }
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
      // this._setupBack()
      this._setupBackground()
      // this._setupModel()
      // this._setupEnemy()
      this._setupControls()

      window.onresize = this.resize.bind(this)
      this.resize()

      requestAnimationFrame(this.render.bind(this))
    },

    _setupControls() {
      this._controls = new OrbitControls(this._camera, this._divContainer)
      this._controls.target.set(100, 0, -40)
      this._controls.enabled = false
      // this._controls.enablePan = false
      // this._controls.enableDamping = true
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
      const gltfLoader = new GLTFLoader()

      const items = [
        { url: '/models/character.glb' },
        { url: '/models/enemy.glb' }
      ]

      items.forEach((item, index) => {
        gltfLoader.load(item.url, (gltf) => {
          if (index == 0) {
            gltf.scene.scale.set(10, 10, 10)
          } else if (index == 1) {
            gltf.scene.scale.set(50, 50, 50)
          }

          const obj3d = gltf.scene
          this._scene.add(obj3d)

          obj3d.traverse((child) => {
            child.castShadow = true
            child.receiveShadow = true
          })

          const animationClips = gltf.animations // THREE.AnimationClip[]
          const mixer = new THREE.AnimationMixer(obj3d)
          const animationsMap = {}
          animationClips.forEach((clip) => {
            const name = clip.name
            // console.log(name)
            animationsMap[name] = mixer.clipAction(clip) // THREE.AnimationAction
          })

          if (index == 0) {
            // obj3d.position.set(-100, 0, 100)
            obj3d.position.set(-120, 0, 100)
            obj3d.lookAt(170, 0, -30)

            this._myModel = obj3d
            this._myMixer = mixer
            // this._myAnimationMap = animationsMap
            // this._myCurrentAnimationAction = this._animationMap['Idle']
            // this._myCurrentAnimationAction.play()
          } else if (index == 1) {
            // obj3d.position.set(170, 20, 90)
            obj3d.position.set(170, 20, 120)
            obj3d.lookAt(-100, -10, 100)

            this._enemyModel = obj3d
            this._enemyMixer = mixer
            // this._enemyAnimationMap = animationsMap
            // this._enemyCurrentAnimationAction = this._animationMap['Idle']
            // this._enemyCurrentAnimationAction.play()
          }
        })
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

    _setupBackground() {
      const loader = new THREE.CubeTextureLoader()
      loader.load(
        [
          '/cubemap/Lycksele/posx.jpg',
          '/cubemap/Lycksele/negx.jpg',
          '/cubemap/Lycksele/posy.jpg',
          '/cubemap/Lycksele/negy.jpg',
          '/cubemap/Lycksele/posz.jpg',
          '/cubemap/Lycksele/negz.jpg'
        ],
        (cubeTexture) => {
          this._scene.background = cubeTexture
          this._setupModel()
        }
      )
    },

    _setupCamera() {
      const camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        2,
        5000
      )
      // camera.position.set(100, 0, -40)
      camera.position.set(-120, 15, 130)
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
      if (this._myMixer) {
        this._myMixer.update(time)

        if (this._myModel) {
          if (this._myModel.position.x <= -100) {
            this._myModel.position.x += 0.2
          }
        }
      }

      if (this._enemyMixer) {
        this._enemyMixer.update(time)

        if (this._enemyModel) {
          if (this._enemyModel.position.z >= 70) {
            this._enemyModel.position.z -= 0.4
          }
        }
      }
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

    changeBattle() {
      this.$emit('changeBattle')
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
      this.mySelectTech.type = item.type
      this.mySelectTech.name = item.name
      this.mySelectTech.value = item.value

      this.actMyMsg = [
        this.mySelectTech.type,
        this.mySelectTech.name + '를 사용했다!!!'
      ]

      // 선공
      if (this.first == 'me') {
        this.phase = 'showMySelect'

        setTimeout(() => {
          this.phase = 'myAct'
          this.getMySelect()
        }, 500)
      }
      // 후공
      else {
        setTimeout(() => {
          this.doEnemyAct()
          this.phase = 'enemyAct'
        }, 500)
      }
    },

    getMySelect() {
      if (this.mySelectTech.type == 'att') {
        // this.myDamage =
        //   this.myAttack * this.mySelectTech.value - this.enemyDefense
        // this.actMyMsg[1] = `${this.myDamage}의 피해를 입혔다!!!`

        // 선공
        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'myAct'
            this.getMyResult()

            if (this.enemyHp <= 0) {
              setTimeout(() => {
                this.phase = 'win'
                this.endMsg = '이김!!!!!!!!!!!!1'
              }, 2000)
            } else {
              setTimeout(() => {
                this.doEnemyAct()
                this.phase = 'enemyAct'
              }, 2000)
            }
          }, 300)
        }
        // 후공
        else {
          setTimeout(() => {
            this.phase = 'myAct'
            this.getMyResult()

            if (this.enemyHp <= 0) {
              setTimeout(() => {
                this.phase = 'win'
                this.endMsg = '이김!!!!!!!!!!!!1'
              }, 2000)
            } else {
              setTimeout(() => {
                this.phase = 'ready'
              }, 2000)
            }
          }, 300)
        }
      } else if (this.mySelectTech.type == 'buff') {
        // this.myAttack += this.myAttack * this.mySelectTech.value
        // this.actMyMsg[1] = `${
        //   this.myAttack * this.mySelectTech.value
        // }만큼 공격력 상승!!!`

        // 선공
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
        // 후공
        else {
          setTimeout(() => {
            this.phase = 'myAct'
            this.getMyResult()

            if (this.enemyHp <= 0) {
              setTimeout(() => {
                this.phase = 'win'
                this.endMsg = '이김!!!!!!!!!!1'
              }, 2000)
            } else {
              setTimeout(() => {
                this.phase = 'ready'
              }, 2000)
            }
          }, 300)
        }
      }
    },

    getMyResult() {
      if (this.actMyMsg[0] === 'att') {
        this.myDamage =
          this.myAttack * this.mySelectTech.value - this.enemyDefense
        this.enemyHp -= this.myDamage
        this.enemyHpBar = Math.round((this.enemyHp / this.enemyMaxHp) * 100)
        this.actMyMsg[1] = `${this.myDamage}의 피해를 입혔다!!!`
      } else if (this.actMyMsg[0] === 'buff') {
        this.myAttack += this.myAttack * this.mySelectTech.value
        this.actMyMsg[1] = `${
          this.myAttack * this.mySelectTech.value
        }만큼 공격력 상승!!!`
      }
    },

    doEnemyAct() {
      const roll = Math.random(0, 1)

      if (roll >= 0.3) {
        this.actEnemyMsg = [
          'enemyAtt',
          `적은 ${this.enemyTech[0].name}을 사용했다!!!`
        ]
        setTimeout(() => {
          this.getEnemyResult()
          this.phase = 'enemyResult'
        }, 800)
      } else {
        this.actEnemyMsg = [
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
      if (this.actEnemyMsg[0] == 'enemyAtt') {
        this.enemyDamage =
          this.enemyAttack * this.enemyTech[0].value - this.myDefense
        this.actEnemyMsg[1] = `${this.enemyDamage}의 피해를 입었다!!!`

        this.myHp -= this.enemyDamage
        this.myHpBar = Math.round((this.myHp / this.myMaxHp) * 100)

        // 선공
        if (this.first == 'me') {
          if (this.myHp <= 0) {
            setTimeout(() => {
              this.phase = 'lose'
              this.endMsg = '짐!!!!!!!!!!!11'
            }, 2000)
          } else {
            setTimeout(() => {
              this.phase = 'ready'
            }, 2000)
          }
        }
        // 후공
        else {
          if (this.myHp <= 0) {
            setTimeout(() => {
              this.phase = 'lose'
              this.endMsg = '짐!!!!!!!!!!!11'
            }, 2000)
          } else {
            setTimeout(() => {
              this.phase = 'showMySelect'

              setTimeout(() => {
                this.getMySelect()
              }, 500)
            }, 500)
          }
        }
      } else if (this.actEnemyMsg[0] == 'enemyBuff') {
        this.enemyAttack += this.enemyAttack * this.enemyTech[1].value
        this.actEnemyMsg[1] = `${
          this.enemyAttack * this.enemyTech[1].value
        }만큼 적의 공격력 상승!!!`

        // 선공
        if (this.first == 'me') {
          setTimeout(() => {
            this.phase = 'ready'
          }, 2000)
        }
        // 후공
        else {
          setTimeout(() => {
            this.phase = 'showMySelect'

            setTimeout(() => {
              this.getMySelect()
            }, 500)
          }, 500)
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
