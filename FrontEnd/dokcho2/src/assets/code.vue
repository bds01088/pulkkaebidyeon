<script>
/* 

import
  1. 필수 사용
  2. 기타 사용
  3. 컴포넌트 
  
*/

export default {
  name: '',
  components: {},
  props: {},
  data() {
    return {
      // raycaster 이쪽에 정의
      raycaster: new THREE.Raycaster(),
      mouse: new THREE.Vector2(),
      // 인식할 Mesh 넣을 배열
      meshes: []
    }
  },
  methods: {
    /* 
    
    1. emit 코드 

    2. 컴포넌트 관련 코드 ( ex) openmodal )

    3. init
      3-1. canvas
      3-2. scene
      3-3. renderer
      3-4. setting
      3-5. 기타 

    4. setting 관련 코드
      4-1. camera
      4-2. light
      4-3. control
      4-4. octree
      4-5. map (background)
      4-6. model
      4-7. animation

    5. 기타 코드 
      5-1. raycaster

    6. update, render, resize  
    
    
    */
  },
  mounted: {}
}
</script>

<style></style>
