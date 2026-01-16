import { createApp } from 'vue'
import './style.css'
import App from './views/App.vue' // Attention: ton App.vue est dans views/
import router from './route/index.js' // Attention: ton index.js est dans route/

const app = createApp(App)

app.use(router) // INDISPENSABLE : On injecte le routeur

app.mount('#app')