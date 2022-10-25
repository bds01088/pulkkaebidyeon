import * as THREE from 'three'

// Scene
const sceneRoom = new THREE.Scene()

// mesh
const geometry = new THREE.BoxGeometry(1, 1, 1)
const material = new THREE.MeshStandardMaterial({
  side: THREE.DoubleSide,
  color: 'blue',
  wireframe: false
})
const cube = new THREE.Mesh(geometry, material)
sceneRoom.add(cube)

// light
const alight = new THREE.AmbientLight('white')
sceneRoom.add(alight)

const light = new THREE.DirectionalLight('white', 1)
sceneRoom.add(light)

export { sceneRoom }
