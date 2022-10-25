import * as THREE from 'three'

// Scene
const sceneMain = new THREE.Scene()

// mesh
const geometry = new THREE.BoxGeometry(1, 1, 1)
const material = new THREE.MeshStandardMaterial({
  side: THREE.DoubleSide,
  color: 'pink',
  wireframe: false
})
const cube = new THREE.Mesh(geometry, material)
sceneMain.add(cube)

// light
const alight = new THREE.AmbientLight('white')
sceneMain.add(alight)

const light = new THREE.DirectionalLight('white', 1)
sceneMain.add(light)

export { sceneMain }
