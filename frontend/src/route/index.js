import { createRouter, createWebHistory } from 'vue-router'

import HomeView from '../views/Home.vue'
import AproposView from '../views/Apropos.vue' // <--- AJOUT
import MatchView from '../views/Match.vue'
import RejoindreView from '../views/Rejoindre.vue'

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
    },
     {
      path: '/match',      // L'URL que vous voulez (ex: monsite.com/a-propos)
      name: 'match',        // Un petit nom interne pour Vue
      component: MatchView  // Le composant importé plus haut
     },
    {
      path: '/rejoindre',      // L'URL que vous voulez (ex: monsite.com/a-propos)
      name: 'rejoindre',        // Un petit nom interne pour Vue
      component: RejoindreView  // Le composant importé plus haut
    }
  ]
})

export default router