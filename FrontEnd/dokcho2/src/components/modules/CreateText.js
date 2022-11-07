import * as THREE from 'three'
import { FontLoader } from 'three/examples/jsm/loaders/FontLoader'
import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry'

export class CreateText {
  constructor(info) {
    this.model = info.model
    this.content = info.content

    const loader = new FontLoader()

    loader.load('/font/dohun.json', (font) => {
      const geometry = new TextGeometry(this.content, {
        font: font,
        size: 0.3,
        height: 0.1
      })

      const material = new THREE.MeshStandardMaterial({
        color: '#689F38',
        roughness: 0.3,
        metalness: 0.7
      })

      const text = new THREE.Mesh(geometry, material)

      text.position.set(
        this.model.modelMesh.position.x,
        this.model.modelMesh.position.y + 1,
        this.model.modelMesh.position.z
      )

      info.scene.add(text)
    })
  }
}
