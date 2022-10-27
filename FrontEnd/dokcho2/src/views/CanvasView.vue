<template>
  <NavBar></NavBar>
  <canvas id="canvas"></canvas>
</template>

<script>
import * as THREE from 'three'
import { TrackballControls } from 'three/examples/jsm/controls/TrackballControls'
import { sceneRoom } from './room'
import { sceneMain } from './main'
import NavBar from '@/components/main/NavBar.vue'

export default {
  components: {
    NavBar
  },
  name: 'CanvasView',
  setup() {
    setTimeout(() => {
      // Canvas
      const canvas = document.querySelector('#canvas')

      // renderer
      const renderer = new THREE.WebGL1Renderer({
        canvas,
        antialias: true
      })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)

      // Scene

      let sceneNow = sceneMain

      // camera
      const camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        0.1,
        1000
      )
      camera.position.x = 2
      camera.position.y = 2
      camera.position.z = 4
      sceneNow.add(camera)

      //control
      const controls = new TrackballControls(camera, renderer.domElement)
      controls.enableDamping = true

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
        if (sceneNow === sceneMain) {
          sceneNow = sceneRoom
        } else {
          sceneNow = sceneMain
        }
      }

      // 이벤트
      window.addEventListener('resize', setSize)

      draw()

      window.addEventListener('click', () => {
        changeScene()
      })

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
