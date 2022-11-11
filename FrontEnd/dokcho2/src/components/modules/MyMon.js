export class myMon {
  constructor(info) {
    this.moving = false
    this.scene = info.scene
    this.meshes = info.meshes
    this.rotationY = info.rotationY || 0
    // this.x = info.position.x || 0
    // this.y = info.position.y || 0
    // this.z = info.position.z || 0
    info.gltfLoader.load(info.modelSrc, (glb) => {
      glb.scene.traverse((child) => {
        if (child.isMesh) {
          child.castShadow = true
        }
      })

      this.modelMesh = glb.scene
      this.modelMesh.scale.x = 0.4
      this.modelMesh.scale.y = 0.4
      this.modelMesh.scale.z = 0.4
      this.modelMesh.position.set(0, 0.25, 0)
      this.modelMesh.name = info.name
      this.scene.add(this.modelMesh)
      this.meshes.push(this.modelMesh)
    })
  }
}
