<template>
  <canvas id="EndingCanvas"> </canvas>

  <div class="fade"></div>

  <section class="star-wars">
    <div class="crawl">
      <div class="title">
        <p>독초도감 최종판</p>
        <h1>풀깨비뎐</h1>
      </div>

      <p>
        이것은 독초도감의 마지막 이야기이다. 독초도감은 2022년 8월에 시작되어...
      </p>

      <div class="teammate">
        <div class="title">
          <h3>팀장</h3>
          <p>서상균</p>
          <br />
          <h3>조원</h3>
          <p>김성빈</p>
          <p>김효근</p>
          <p>박지현</p>
          <p>오하민</p>
          <p>이근희</p>
          <br />
          <h3>출연</h3>
          <p>단군 장수왕 선덕여왕 공민왕</p>
          <p>세종대왕 이순신 유관순 호랑이</p>
          <p>지현몬 묘근몬 재준몬</p>
          <p>근희몬 상균몬 지원몬 하민몬</p>
          <br />
        </div>
      </div>

      <div class="title">
        <h1>플레이 해주셔서 감사합니다!</h1>
      </div>
    </div>
  </section>
</template>

<script>
import * as THREE from 'three'

export default {
  name: 'EndingCredits',
  setup() {
    setTimeout(() => {
      // Texture
      const textureLoader = new THREE.TextureLoader()
      const floorTexture = textureLoader.load('/images/map18.png')
      floorTexture.wrapS = THREE.RepeatWrapping
      floorTexture.wrapT = THREE.RepeatWrapping
      floorTexture.repeat.x = 1
      floorTexture.repeat.y = 1

      // Renderer
      let canvas = document.querySelector('#EndingCanvas')

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
      const camera = new THREE.PerspectiveCamera(
        60,
        window.innerWidth / window.innerHeight,
        1,
        1000
      )

      camera.position.set(3, 1, 3)
      camera.lookAt(0, 1, 0)
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

      //   const clock = new THREE.Clock()

      function draw() {
        // const delta = clock.getDelta()

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
  }
}
</script>

<style>
body {
  width: 100%;
  height: 100%;
  background: #000;
  overflow: hidden;
}

canvas {
  width: 100vw;
  height: 100vh;
}

.fade {
  position: absolute;
  width: 100%;
  min-height: 60vh;
  top: -25px;
  background-image: linear-gradient(0deg, transparent, black 75%);
  z-index: 2;
}

.star-wars {
  display: flex;
  justify-content: center;
  position: relative;
  height: 80vh;
  color: #feda4a;
  font-family: 'Pathway Gothic One', sans-serif;
  font-size: 500%;
  font-weight: 600;
  letter-spacing: 6px;
  line-height: 150%;
  perspective: 400px;
  text-align: justify;

  z-index: 1;
  background-color: black;
  background-color: rgba(0, 0, 0, 0.5);
}

.crawl {
  position: relative;
  top: 9999px;
  transform-origin: 50% 100%;
  animation: crawl 60s linear;
}

.crawl > .title {
  font-size: 90%;
  text-align: center;
}

.crawl > .title h1 {
  margin: 0 0 100px;
  text-transform: uppercase;
}

.teammate {
  text-align: center;
}

.teammate > .title h3 {
  margin: 0 0 50px;
  text-transform: uppercase;
}

.teammate > .title p {
  margin: 0 0 10px;
  text-transform: uppercase;
}

@keyframes crawl {
  0% {
    top: 0;
    transform: rotateX(10deg) translateZ(0);
  }
  100% {
    top: -6000px;
    transform: rotateX(15deg) translateZ(-2000px);
  }
}
</style>
