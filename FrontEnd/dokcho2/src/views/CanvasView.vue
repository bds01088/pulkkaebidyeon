<template>
  <canvas id="canvas"></canvas>
</template>

<script>
import * as THREE from 'three'
import { TrackballControls } from 'three/examples/jsm/controls/TrackballControls'

export default {
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
      const scene1 = new THREE.Scene()

      const scene2 = new THREE.Scene()

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
      scene1.add(camera)
      scene2.add(camera)

      // light
      const alight = new THREE.AmbientLight('white')
      const alight2 = alight.clone()
      scene1.add(alight)
      scene2.add(alight2)

      const light = new THREE.DirectionalLight('white', 1)
      const light2 = light.clone()
      scene1.add(light)
      scene2.add(light2)

      //control
      const controls = new TrackballControls(camera, renderer.domElement)
      controls.enableDamping = true

      // mesh
      const geometry = new THREE.BoxGeometry(1, 1, 1)
      const material1 = new THREE.MeshStandardMaterial({
        side: THREE.DoubleSide,
        color: 'pink',
        wireframe: false
      })
      const material2 = new THREE.MeshStandardMaterial({
        side: THREE.DoubleSide,
        color: 'blue',
        wireframe: false
      })
      const cube1 = new THREE.Mesh(geometry, material1)
      const cube2 = new THREE.Mesh(geometry, material2)

      scene1.add(cube1)
      scene2.add(cube2)

      let sceneNow = scene1

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
        if (sceneNow === scene1) {
          sceneNow = scene2
        } else {
          sceneNow = scene1
        }
      }

      // 이벤트
      window.addEventListener('resize', setSize)

      draw()

      window.addEventListener('click', () => {
        // console.log('click')
        changeScene()
      })

      return {
        canvas,
        renderer,
        scene1,
        scene2,
        sceneNow,
        camera,
        light,
        cube1,
        cube2,
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
