
import { createApp } from 'vue'
import App from './views/App.vue'
import './style.css'
// Importer le routeur que vous avez configuré
import router from './route/index.js' 

const app = createApp(App)

app.use(router) 

app.mount('#app')