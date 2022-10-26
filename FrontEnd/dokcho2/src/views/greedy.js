import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
// import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
// import Stats from 'three/examples/jsm/libs/stats.module'
// import * as CANNON from 'cannon-es'
// import { canvas } from './main'
// import { camera } from './CanvasView.vue'

// Scene
const sceneGreedy = new THREE.Scene()
let currentAnimationAction = []
let animationsMap = {}
function setmodel() {
  // model
  const loader = new GLTFLoader()
  loader.load('./3Ddata/character.glb', (gltf) => {
    const model = gltf.scene
    sceneGreedy.add(model)

    model.traverse((child) => {
      if (child instanceof THREE.Mesh) {
        child.castShadow = true
      }
    })

    const animationClips = gltf.animations
    const mixer = new THREE.AnimationMixer(model)

    animationClips.forEach((clip) => {
      const name = clip.name
      console.log(name)
      animationsMap[name] = mixer.clipAction(clip)
    })
    currentAnimationAction = animationsMap['Idle']
    currentAnimationAction.play()
  })

  loader.load('./3Ddata/spacestair.glb', (gltf) => {
    const model = gltf.scene

    sceneGreedy.add(model)

    model.traverse((child) => {
      if (child instanceof THREE.Mesh) {
        child.castShadow = true
        child.receiveShadow = true
      }
    })

    // this._setupOctree(model);
  })
}

let speed = 0
let maxSpeed = 0
let acceleration = 0

//animation

const pressedKeys = {}

function processAnimation() {
  const previousAnimationAction = currentAnimationAction

  if (
    pressedKeys['w'] ||
    pressedKeys['a'] ||
    pressedKeys['s'] ||
    pressedKeys['d']
  ) {
    if (pressedKeys['shift']) {
      currentAnimationAction = animationsMap['Run']
      // this._speed = 350;
      maxSpeed = 350
      acceleration = 3
    } else {
      currentAnimationAction = animationsMap['Walk']
      // this._speed = 80;
      maxSpeed = 80
      acceleration = 3
    }
  } else {
    currentAnimationAction = animationsMap['Idle']
    speed = 0
    maxSpeed = 0
    acceleration = 0
  }

  if (previousAnimationAction !== currentAnimationAction) {
    previousAnimationAction.fadeOut(0.5)
    currentAnimationAction.reset().fadeIn(0.5).play()
  }
}

document.addEventListener('keydown', (event) => {
  pressedKeys[event.key.toLowerCase()] = true
  processAnimation()
})

document.addEventListener('keyup', (event) => {
  pressedKeys[event.key.toLowerCase()] = false
  processAnimation()
})

let previousDirectionOffset = 0

function directionOffset() {
  const pressedKeys = pressedKeys
  let directionOffset = 0

  if (pressedKeys['w']) {
    if (pressedKeys['a']) {
      directionOffset = Math.PI / 4
    } else if (pressedKeys['d']) {
      directionOffset = -Math.PI / 4
    }
  } else if (pressedKeys['s']) {
    if (pressedKeys['a']) {
      directionOffset = Math.PI / 4 + Math.PI / 2
    } else if (pressedKeys['d']) {
      directionOffset = -Math.PI / 4 - Math.PI / 2
    } else {
      directionOffset = Math.PI
    }
  } else if (pressedKeys['a']) {
    directionOffset = Math.PI / 2
  } else if (pressedKeys['d']) {
    directionOffset = -Math.PI / 2
  } else {
    directionOffset = this.previousDirectionOffset
  }

  previousDirectionOffset = directionOffset

  return directionOffset
}

// light
function addPointLight(x, y, z) {
  const color = 0xffffff
  const intensity = 1.5

  const pointLight = new THREE.PointLight(color, intensity, 2000)
  pointLight.position.set(x, y, z)

  sceneGreedy.add(pointLight)
}

const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
sceneGreedy.add(ambientLight)

addPointLight(500, 150, 500)
addPointLight(-500, 150, 500)
addPointLight(-500, 150, -500)
addPointLight(500, 150, -500)

const shadowLight = new THREE.DirectionalLight(0xffffff, 0.2)
shadowLight.position.set(200, 500, 200)
shadowLight.target.position.set(0, 0, 0)

shadowLight.castShadow = true
shadowLight.shadow.mapSize.width = 1024
shadowLight.shadow.mapSize.height = 1024
shadowLight.shadow.camera.top = shadowLight.shadow.camera.right = 700
shadowLight.shadow.camera.bottom = shadowLight.shadow.camera.left = -700
shadowLight.shadow.camera.near = 100
shadowLight.shadow.camera.far = 900
shadowLight.shadow.radius = 5

sceneGreedy.add(shadowLight)
sceneGreedy.add(shadowLight.target)

function update(time) {
  time *= 0.001

  if (mixer) {
    const deltaTime = time - previousTime
    mixer.update(deltaTime)
  }
  previousTime = time
}

export {
  sceneGreedy,
  speed,
  maxSpeed,
  acceleration,
  previousDirectionOffset,
  directionOffset,
  setmodel
}
