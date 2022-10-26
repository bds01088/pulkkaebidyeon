<template>
  <canvas id="canvas"></canvas>
</template>

<script>
import * as THREE from 'three'
// import { TrackballControls } from 'three/examples/jsm/controls/TrackballControls'
import { sceneRoom } from './room'
import { sceneMain } from './main'
import { sceneGreedy, setmodel } from './greedy'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
// import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import Stats from 'three/examples/jsm/libs/stats.module'
import * as CANNON from 'cannon-es'

export default {
  name: 'CanvasView',
  setup() {
    setTimeout(() => {
      // Canvas
      const canvas = document.querySelector('#canvas')
      setmodel()
      // renderer
      const renderer = new THREE.WebGL1Renderer({
        canvas,
        antialias: true
      })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)
      renderer.shadowMap.enabled = true
      renderer.shadowMap.type = THREE.VSMShadowMap

      // Scene

      let sceneNow = sceneGreedy

      // camera
      const camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        1,
        5000
      )
      camera.position.x = 0
      camera.position.y = 100
      camera.position.z = 500
      sceneNow.add(camera)

      //control
      const controls = new OrbitControls(camera, canvas)
      controls.enableDamping = true
      controls.enablePan = false
      controls.target.set(0, 100, 0)

      const stats = new Stats()
      canvas.appendChild(stats.dom)

      // Cannon(물리 엔진)
      const cannonWorld = new CANNON.World()
      cannonWorld.gravity.set(0, -9.8, 0)

      // 그리기
      function draw() {
        controls.update()
        renderer.render(sceneNow, camera)
        renderer.setAnimationLoop(draw)
      }

      function setSize() {
        camera.aspect = window.innerWidth / window.innerHeight
        camera.updateProjectionMatrix()
        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.render(sceneNow, camera)
      }

      // scene 변경
      function changeScene() {
        if (sceneNow === sceneRoom) {
          sceneNow = sceneGreedy
        } else {
          sceneNow = sceneMain
        }
      }

      // 이벤트
      window.addEventListener('resize', setSize)

      draw()

      // window.addEventListener('click', () => {
      //   changeScene()
      // })

      return {
        canvas,
        renderer,
        sceneNow,
        camera,
        setSize,
        draw,
        changeScene
      }
    }, 100)
  }
}
</script>

<style scoped>
#canvas {
  position: absolute;
  left: 0;
  top: 0;
}
</style>
