<template>
  <div>
    <battle-status
      id="status"
      :myHpBar="myHpBar"
      :enemyHpBar="enemyHpBar"
      :begin="begin"
    ></battle-status>

    <div id="battleDiv"><div id="battle"></div></div>

    <div id="consoleDiv">
      <div id="console" @click="changePhase()" v-show="phase === 'start'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" @click="changePhase()" v-show="phase === 'ready'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'selectAct'">
        <p>
          <span v-for="(act, idx) in actList" :key="idx">
            <button @click="doSelectAct(act)">{{ act }}</button>
          </span>
        </p>
      </div>

      <div id="console" v-show="phase === 'showAct'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'actResult'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'showEnemyAct'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'enemyActResult'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'noHappen'">
        <p>{{ msg }}</p>
      </div>

      <div id="console" v-show="phase === 'end'">
        <p>{{ phase }}</p>
      </div>

      <div id="console" v-show="phase === 'selectItem'">
        <p>
          <span v-for="(item, idx) in itemList" :key="idx">
            <button @click="doSelectItem(item)">{{ item }}</button>
          </span>
        </p>
      </div>

      <div id="console" v-show="phase === 'itemResult'">
        <p>{{ msg }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { Player } from '../modules/Player'

import gsap from 'gsap'
import * as CANNON from 'cannon-es'

import BattleStatus from './BattleStatus.vue'
import { ref } from 'vue'

// import { CreateText } from '../modules/CreateText'

export default {
  name: 'BattleCanvas',

  props: {
    nowPage: Number
  },

  components: { BattleStatus },

  setup() {
    // console.log(JSON.parse(localStorage.getItem('userInfo')))
    const myHpBar = ref('100')
    const enemyHpBar = ref('100')
    const begin = ref(0)

    const phase = ref('start')
    const msg = ref('적을 만남!!!!')

    const myMaxHp = ref(100)
    const myHp = ref(100)
    const myAttack = ref(40)
    const myDefense = ref(10)

    const enemyMaxHp = ref(100)
    const enemyHp = ref(100)
    const enemyAttack = ref(50)
    const enemyDefense = ref(10)

    const actList = ref(['공격', '방어', '아이템'])
    const myAct = ref('')
    const status = ref('대기')

    const enemyAct = ref('')
    const enemyStatus = ref('대기')

    const myDamage = ref(0)
    const enemyDamage = ref(0)

    const itemList = ref([
      '회복 물약(소)',
      '회복 물약(중)',
      '회복 물약(대)',
      '공격 무효화',
      '더블 어택'
    ])
    const useItem = ref('')

    const absoluteDefense = ref(false)
    const doubleAttack = ref(false)

    setTimeout(() => {
      // Texture
      const textureLoader = new THREE.TextureLoader()
      const floorTexture = textureLoader.load('/images/grid.png')
      floorTexture.wrapS = THREE.RepeatWrapping
      floorTexture.wrapT = THREE.RepeatWrapping
      floorTexture.repeat.x = 1
      floorTexture.repeat.y = 1

      const battleDiv = document.querySelector('#battleDiv')
      const battle = document.querySelector('#battle')
      battle.remove()

      const newBattle = document.createElement('div')
      newBattle.id = 'battle'
      battleDiv.appendChild(newBattle)

      // Renderer
      let canvas = document.querySelector('#battle')

      const renderer = new THREE.WebGLRenderer({ antialias: true })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)
      canvas.appendChild(renderer.domElement)
      renderer.shadowMap.enabled = true
      renderer.shadowMap.type = THREE.PCFSoftShadowMap

      // Scene
      const scene = new THREE.Scene()

      // Camera
      const camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        1,
        1000
      )

      camera.position.set(2, 3, 4.5)
      camera.lookAt(-0.5, 0, 1.5)
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

      // Mesh
      const meshes = []
      const floorMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(50, 50),
        new THREE.MeshStandardMaterial({
          map: floorTexture
        })
      )
      floorMesh.name = 'floor'
      floorMesh.rotation.x = -Math.PI / 2
      floorMesh.receiveShadow = true
      scene.add(floorMesh)
      meshes.push(floorMesh)

      const gltfLoader = new GLTFLoader()

      const player = new Player({
        scene,
        meshes,
        cannonWorld,
        gltfLoader,
        modelSrc: '/models/character.glb',
        x: -0.5,
        y: 3,
        z: 3
      })

      const enemy = new Player({
        scene,
        meshes,
        cannonWorld,
        gltfLoader,
        modelSrc: '/models/character.glb',
        x: -0.5,
        y: 3,
        z: -3
      })

      // 그리기
      const clock = new THREE.Clock()

      function draw() {
        const delta = clock.getDelta()

        let cannonStepTime = 1 / 60
        if (delta < 0.01) cannonStepTime = 1 / 120
        cannonWorld.step(cannonStepTime, delta, 3)

        if (player.modelMesh) {
          player.modelMesh.position.copy(player.cannonBody.position)
          player.modelMesh.quaternion.copy(player.cannonBody.quaternion)
          player.modelMesh.lookAt(-0.5, 0, -3)

          if (status.value == '공격') {
            gsap.to(player.cannonBody.position, {
              duration: 0.2,
              y: 1
            })

            status.value = '대기'
          }

          if (status.value == 'lose') {
            gsap.to(player.cannonBody.position, {
              duration: 5,
              x: -20,
              y: 10,
              z: 10
            })

            status.value = '대기'
          }
        }

        if (enemy.modelMesh) {
          enemy.modelMesh.position.copy(enemy.cannonBody.position)
          enemy.modelMesh.quaternion.copy(enemy.cannonBody.quaternion)
          enemy.modelMesh.lookAt(-0.5, 0, 3)

          if (enemyStatus.value == '공격') {
            console.log(scene)
            gsap.to(enemy.cannonBody.position, {
              duration: 0.2,
              y: 1
            })

            enemyStatus.value = '대기'
          }

          if (status.value == 'win') {
            gsap.to(enemy.cannonBody.position, {
              duration: 5,
              x: 20,
              y: 10,
              z: -15
            })

            status.value = '대기'
          }
        }

        if (player.mixer) player.mixer.update(delta)
        if (enemy.mixer) enemy.mixer.update(delta)

        renderer.render(scene, camera)
        renderer.setAnimationLoop(draw)
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
      draw()
    }, 100)

    function changePhase() {
      if (phase.value == 'start') {
        setTimeout(() => {
          msg.value = '기술을 선택해!!!'
          phase.value = 'ready'
        }, 100)
      }
      if (phase.value == 'ready') {
        phase.value = 'selectAct'
      }
      if (phase.value == 'itemSelect') {
        phase.value = 'itemResult'
      }
    }

    function doSelectAct(item) {
      status.value = item
      myAct.value = item

      enemySelectAct()

      if (myAct.value == '공격') {
        enemyDamage.value = enemyAttack.value

        msg.value = item + ' 사용!!!'
        phase.value = 'showAct'

        if (enemyAct.value == '방어') {
          myDamage.value = myAttack.value - enemyDefense.value

          setTimeout(() => {
            enemyShowAct()
          }, 800)
        } else {
          myDamage.value = myAttack.value

          setTimeout(() => {
            showActResult()
          }, 800)
        }
      } else if (myAct.value == '방어') {
        enemyDamage.value = enemyAttack.value - myDefense.value

        msg.value = item + ' 사용!!!'
        phase.value = 'showAct'

        setTimeout(() => {
          enemyShowAct()
        }, 800)
      } else if (myAct.value == '아이템') {
        phase.value = 'selectItem'
      }
    }

    function enemySelectAct() {
      const num = Math.random(0, 1)

      if (num <= 0.75) {
        enemyAct.value = '공격'
      } else if (num <= 0.9) {
        enemyAct.value = '방어'
      } else {
        enemyAct.value = '버프'
      }
    }

    function showActResult() {
      if (myAct.value == '공격') {
        if (enemyAct.value == '방어') {
          msg.value =
            '적의 방어태세로 ' +
            myDamage.value.toString() +
            '의 피해를 주었다!!!'
          phase.value = 'actResult'

          enemyHp.value -= myDamage.value
          enemyHpBar.value = Math.round(
            (enemyHp.value / enemyMaxHp.value) * 100
          )

          if (doubleAttack.value == true) {
            setTimeout(() => {
              if (enemyHp.value <= 0) {
                phase.value = 'end'
                status.value = 'win'
              } else {
                status.value = '공격'
                doubleAttack.value = false
                setTimeout(() => {
                  showActResult()
                }, 800)
              }
            }, 800)
          } else {
            setTimeout(() => {
              if (enemyHp.value <= 0) {
                phase.value = 'end'
                status.value = 'win'
              } else {
                phase.value = 'ready'
              }
            }, 800)
          }
        } else {
          msg.value = myDamage.value.toString() + '의 피해를 주었다!!!'
          phase.value = 'actResult'

          enemyHp.value -= myDamage.value
          enemyHpBar.value = Math.round(
            (enemyHp.value / enemyMaxHp.value) * 100
          )
          if (doubleAttack.value == true) {
            setTimeout(() => {
              if (enemyHp.value <= 0) {
                phase.value = 'end'
                status.value = 'win'
              } else {
                status.value = '공격'
                doubleAttack.value = false
                setTimeout(() => {
                  showActResult()
                }, 800)
              }
            }, 800)
          } else {
            setTimeout(() => {
              if (enemyHp.value <= 0) {
                phase.value = 'end'
                status.value = 'win'
              } else {
                enemyShowAct()
              }
            }, 800)
          }
        }
      }
    }

    function enemyShowAct() {
      msg.value = '적은 ' + enemyAct.value + ' 사용!!!'
      enemyStatus.value = enemyAct.value
      phase.value = 'showEnemyAct'

      if (myAct.value == '방어') {
        if (enemyAct.value == '방어') {
          setTimeout(() => {
            phase.value = 'noHappen'
            msg.value = '아무일도 일어나지 않았다...'
            phase.value = 'ready'
          }, 800)
        } else {
          setTimeout(() => {
            enemyActResult()
          }, 500)
        }
      } else if (enemyAct.value == '방어') {
        setTimeout(() => {
          showActResult()
        }, 500)
      } else {
        setTimeout(() => {
          enemyActResult()
        }, 500)
      }
    }

    function enemyActResult() {
      if (enemyAct.value == '공격') {
        if (absoluteDefense.value == true) {
          msg.value = '적의 공격이 무효화 되었다!!!'
          phase.value = 'enemyActResult'

          absoluteDefense.value = false

          setTimeout(() => {
            phase.value = 'ready'
          }, 500)
        } else if (myAct.value == '방어') {
          msg.value =
            '나의 방어태세로 ' +
            enemyDamage.value.toString() +
            '의 피해를 받았다!!!'
          phase.value = 'enemyActResult'

          myHp.value -= enemyDamage.value
          myHpBar.value = Math.round((myHp.value / myMaxHp.value) * 100)

          myAct.value = ''

          setTimeout(() => {
            if (myHp.value <= 0) {
              phase.value = 'end'
              status.value = 'lose'
            } else {
              phase.value = 'ready'
            }
          }, 800)
        } else {
          msg.value = enemyDamage.value.toString() + '의 피해를 받았다!!!'
          phase.value = 'enemyActResult'

          myHp.value -= enemyDamage.value
          myHpBar.value = Math.round((myHp.value / myMaxHp.value) * 100)

          setTimeout(() => {
            if (myHp.value <= 0) {
              phase.value = 'end'
              status.value = 'lose'
            } else {
              phase.value = 'ready'
            }
          }, 800)
        }
      } else if (enemyAct.value == '버프') {
        const buff = Math.round(enemyAttack.value * 0.2)
        enemyAttack.value += buff
        console.log(enemyAttack.value)

        msg.value = buff.toString() + '만큼 공격력 상승!!!'
        phase.value = 'enemyActResult'

        setTimeout(() => {
          phase.value = 'ready'
        }, 800)
      }
    }

    function doSelectItem(item) {
      useItem.value = item

      if (useItem.value == '회복 물약(소)') {
        phase.value = 'itemResult'

        let heal = 50
        if (myHp.value + heal > myMaxHp.value) {
          heal = myMaxHp.value - myHp.value
        }

        msg.value = heal.toString() + ' 체력을 회복했다!!!'

        myHp.value += heal
        myHpBar.value = Math.round((myHp.value / myMaxHp.value) * 100)

        useItem.value = ''

        setTimeout(() => {
          phase.value = 'selectAct'
        }, 800)
      } else if (useItem.value == '회복 물약(중)') {
        phase.value = 'itemResult'

        let heal = 200
        if (myHp.value + heal > myMaxHp.value) {
          heal = myMaxHp.value - myHp.value
        }

        msg.value = heal.toString() + ' 체력을 회복했다!!!'

        myHp.value += heal
        myHpBar.value = Math.round((myHp.value / myMaxHp.value) * 100)

        useItem.value = ''

        setTimeout(() => {
          phase.value = 'selectAct'
        }, 800)
      } else if (useItem.value == '회복 물약(대)') {
        phase.value = 'itemResult'

        let heal = 500
        if (myHp.value + heal > myMaxHp.value) {
          heal = myMaxHp.value - myHp.value
        }

        msg.value = heal.toString() + ' 체력을 회복했다!!!'

        myHp.value += heal
        myHpBar.value = Math.round((myHp.value / myMaxHp.value) * 100)

        useItem.value = ''

        setTimeout(() => {
          phase.value = 'selectAct'
        }, 800)
      } else if (useItem.value == '공격 무효화') {
        phase.value = 'itemResult'
        absoluteDefense.value = true

        msg.value = '다음 적의 공격은 무효화된다!!!'
        useItem.value = ''

        setTimeout(() => {
          phase.value = 'selectAct'
        }, 500)
      } else if (useItem.value == '더블 어택') {
        phase.value = 'itemResult'
        doubleAttack.value = true

        msg.value = '다음 나의 공격은 2번 연속!!!'
        useItem.value = ''

        setTimeout(() => {
          phase.value = 'selectAct'
        }, 500)
      }
    }

    return {
      myHpBar,
      enemyHpBar,
      begin,
      phase,
      msg,
      changePhase,
      actList,
      status,
      doSelectAct,
      itemList,
      doSelectItem
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
