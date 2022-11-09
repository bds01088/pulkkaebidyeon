import { Body, Box, Vec3 } from 'cannon-es'
import { FBXLoader } from 'three/examples/jsm/loaders/FBXLoader'

export class FBXLoad {
  constructor(info) {
    this.moving = false
    this.scene = info.scene
    this.meshes = info.meshes
    this.cannonWorld = info.cannonWorld
    this.rotationY = info.rotationY || 0
    this.width = info.width.x || 0.8
    this.height = info.width.y || 0.8
    this.depth = info.width.z || 0.8
    this.x = info.position.x
    this.y = info.position.y
    this.z = info.position.z
    this.fbxloader = new FBXLoader()
    this.fbxloader.load(
      info.modelSrc,
      (object) => {
        object.scale.set(0.023, 0.023, 0.023)
        object.position.set(this.x, this.y, this.z)
        this.scene.add(object)
      },
      (error) => {
        console.log(error)
      }
    )
  }
  setCannonBody() {
    const shape = new Box(
      new Vec3(this.width / 2, this.height / 2, this.depth / 2)
    )
    this.cannonBody = new Body({
      mass: 0,
      position: new Vec3(this.x, this.y, this.z),
      shape
    })

    this.cannonBody.quaternion.setFromAxisAngle(
      new Vec3(0, 1, 0), // y축
      this.rotationY
    )

    this.modelMesh.cannonBody = this.cannonBody

    this.cannonWorld.addBody(this.cannonBody)
  }
}
