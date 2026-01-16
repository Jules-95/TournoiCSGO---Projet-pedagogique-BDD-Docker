// Fichier : src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'

// 1. IMPORTEZ votre nouveau fichier ici
import HomeView from '../views/Home.vue'
import AproposView from '../views/Apropos.vue' // <--- AJOUT

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    // 2. AJOUTEZ l'objet de configuration ici
    {
      path: '/a-propos',      // L'URL que vous voulez (ex: monsite.com/a-propos)
      name: 'apropos',        // Un petit nom interne pour Vue
      component: AproposView  // Le composant importé plus haut
    }
  ]
})

export default router