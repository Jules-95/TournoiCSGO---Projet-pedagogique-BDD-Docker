import { createRouter, createWebHistory } from 'vue-router'

// 1. Imports propres des composants (Vérifiés avec tes fichiers)
import HomeView from '../views/Home.vue'
import AproposView from '../views/Apropos.vue'
import MatchView from '../views/Match.vue'
import RejoindreView from '../views/Rejoindre.vue'
import TeamsList from '../views/TeamsList.vue'      // Nom standardisé
import Dashboard from '../views/Dashboard.vue'
import Leaderboard from '../views/Leaderboard.vue'
import TournamentDetail from '../views/TournamentDetail.vue' // Singulier (comme ton fichier)

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/a-propos',
      name: 'apropos',
      component: AproposView
    },
    {
      path: '/matchs',  // J'ai mis au pluriel pour faire propre dans l'URL
      name: 'matchs',
      component: MatchView
    },
    {
      path: '/rejoindre',
      name: 'rejoindre',
      component: RejoindreView
    },
    {
      path: '/equipes',
      name: 'teams',
      component: TeamsList
    },
    {
      path: '/classements',
      name: 'leaderboard',
      component: Leaderboard
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/tournoi/:id', // Route dynamique pour les détails
      name: 'tournament-detail',
      component: TournamentDetail
    }
  ]
})

export default router