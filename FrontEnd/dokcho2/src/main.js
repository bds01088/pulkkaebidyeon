import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { fas } from '@fortawesome/free-solid-svg-icons'

library.add(fas)

createApp(App)
  .component('font-awesome-icon', FontAwesomeIcon)
  .use(store)
  .use(router)
  .mount('#app')

// const app = createApp(App)
// app.component('font-awesome-icon', FontAwesomeIcon)
// app.use(store)
// app.use(router)
// app.mount('#app')

// 웰컴 콘솔 메시지 🙋‍♀️
function welcome() {
  console.log(`
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣄⣀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠄⠒⢀⡰⠊⠉⠉⠀⠀⠈⢿⣿⠇⠈⣹⣿⣿⣿⣿⣿⣷⣴⣿⣿⣶⣄⠀
풀⠀깨⠀비⠀뎐⠀❤⠀🌿⠀🐥⠀⢠⡡⠖⠋⠉⠘⠉⠉⠉⠓⢄⠀⠀⠀⠀⠸⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠋⠀⠀⠀⠀⠀⠀⣠⣤⣤⣸⠄⠀⢀⣀⣤⣀⡀⠀⠀⢿⣿⣿⣿⣿⣿⠉⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⢸⣿⣏⣻⣿⠀⣠⣭⣤⣄⠀⠈⠳⡄⠸⣿⣿⣿⣿⣿⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠋⠁⠸⣿⣍⣿⣿⠀⠀⠀⠁⣀⣀⠿⠿⢿⣿⠁⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠁⠀⢀⠔⠊⢀⠀⠀⠀⠀⠙⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⢆⣘⣦⡀⠀⠀⠠⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠀⠠⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡀⠁⠀⢸⣿⣿⣶⣤⡀⠀⠀⠀⠀⡠⠤⡀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⣤⣾⣿⣿⣿⣿⣿⣷⣶⣤⣤⡇⠀⠺⣶⣶⣶⣦⣤⡀⠀⠀⠀⠀⠀⠠⠐⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣯⡁⠀⠀⠈⣿⣿⣿⣿⣷⡦⠠⠄⠐⠉⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿제작자 🙂 서상균 김성빈 김효근 박지현 오하민 이근희 🍀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⡿⠛⣿⣿⣿⣿⣿⣿⣿⣿⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠉⠉⡘⠀⠀⠈⢿⣿⣿⣿⣿⣿⡿⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠍⠐⠊⠀⠀⠀⠀⠀⠛⡿⠿⠟⠛⠇
  `)
}

window.onload = function () {
  welcome()
}
