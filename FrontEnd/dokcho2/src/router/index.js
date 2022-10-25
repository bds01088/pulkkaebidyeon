import { createRouter, createWebHistory } from 'vue-router'
// import axios from 'axios'
import CanvasView from '../views/CanvasView'

const routes = [
  {
    path: '/',
    name: 'canvas',
    component: CanvasView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
