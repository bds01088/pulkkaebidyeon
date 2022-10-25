<template>
  <canvas id="canvas"></canvas>
</template>

<script>
import * as THREE from 'three'

export default {
  name: 'CanvasView',
  setup() {
    setTimeout(() => {
      // Canvas
      const canvas = document.querySelector('#canvas')

      // renderer
      const renderer = new THREE.WebGL1Renderer({ canvas, antialias: true })
      renderer.setSize(window.innerWidth, window.innerHeight)
      renderer.setPixelRatio(window.devicePixelRatio > 1 ? 2 : 1)

      // Scene
      const scene = new THREE.Scene()

      // camera
      const camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        0.1,
        1000
      )
      camera.position.z = 4
      scene.add(camera)

      // light
      const alight = new THREE.AmbientLight('white')
      scene.add(alight)

      const light = new THREE.DirectionalLight('white')
      scene.add(light)

      // mesh
      const geometry = new THREE.BoxGeometry(1, 1, 1)
      const material = new THREE.MeshStandardMaterial({
        side: THREE.DoubleSide,
        color: 'pink',
        wireframe: false
      })
      const cube = new THREE.Mesh(geometry, material)
      scene.add(cube)

      // 그리기
      renderer.render(scene, camera)

      return {
        canvas,
        renderer,
        scene,
        camera,
        light,
        cube
      }
    }, 100)
  }
}
</script>

<style></style>
