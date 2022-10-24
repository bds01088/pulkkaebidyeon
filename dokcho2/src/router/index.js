import { createRouter, createWebHistory } from 'vue-router'
// import axios from 'axios'
import StartView from '../views/StartView'

const routes = [
  {
    path: '/',
    name: 'start',
    component: StartView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
