<script setup>
import { ref } from 'vue'

// Simulation de la table "JEU"
const gamesData = {
  VALORANT: { 
    nom: 'VALORANT', 
    image: 'https://images.unsplash.com/photo-1624138784614-87fd1b6528f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    badgeStyle: null 
  },
  LOL: { 
    nom: 'LEAGUE OF LEGENDS', 
    image: 'https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    badgeStyle: null 
  },
  RL: { 
    nom: 'ROCKET LEAGUE', 
    image: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    badgeStyle: { backgroundColor: '#9b59b6' } 
  },
  CS2: {
    nom: 'COUNTER-STRIKE 2',
    image: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    badgeStyle: { backgroundColor: '#ff9f43' } 
  }
}

// Simulation de la table "TOURNOI"
const featuredTournaments = ref([
  {
    numeroTournoi: 1, 
    nomPublic: 'Weekly Spike Clash #42',
    dateDebut: '24 Oct, 20:00',
    statut: 'Ouvert', 
    format: '5v5',
    codeJeu: 'VALORANT'
  },
  {
    numeroTournoi: 2,
    nomPublic: "Summoner's Rift Cup",
    dateDebut: '26 Oct, 14:00',
    statut: 'Ouvert',
    format: '5v5',
    codeJeu: 'LOL'
  },
  {
    numeroTournoi: 3,
    nomPublic: 'Nitro Doubles Championship',
    dateDebut: '28 Oct, 19:00',
    statut: 'En cours',
    format: '2v2',
    codeJeu: 'RL'
  },
  {
    numeroTournoi: 4,
    nomPublic: 'Major Copenhagen Qualifier',
    dateDebut: '01 Nov, 18:00',
    statut: 'Terminé',
    format: '5v5',
    codeJeu: 'CS2'
  }
])

// Helper pour afficher les infos complètes
const getTournamentDisplay = (tourney) => {
  const game = gamesData[tourney.codeJeu]
  return {
    ...tourney,
    gameName: game.nom,
    imageUrl: game.image,
    badgeStyle: game.badgeStyle
  }
}
</script>

<template>
    <section class="hero">
        <div class="hero-content">
            <h1>Let's go!<br>Dominez la compétition</h1>
            <p>La plateforme ultime pour créer, gérer et rejoindre des tournois esport. Prouvez votre valeur et grimpez au classement.</p>
            <button class="btn btn-primary size-lg">Trouver un tournoi</button>
        </div>
    </section>

    <section class="featured-section">
        <h2 class="section-title">Tournois <span>À la une</span></h2>
        
        <div class="tournament-grid">
            <div v-for="item in featuredTournaments" :key="item.numeroTournoi" class="tournament-card">
                
                <component :is="'script'" v-show="false">
                  {{ displayData = getTournamentDisplay(item) }}
                </component>

                <div class="card-image" :style="{ backgroundImage: `url(${displayData.imageUrl})` }">
                    <span class="game-badge" :style="displayData.badgeStyle ? displayData.badgeStyle : ''">
                      {{ displayData.gameName }}
                    </span>
                </div>
                
                <div class="card-content">
                    <h3>{{ displayData.nomPublic }}</h3>
                    <div class="card-info">
                        <span>📅 {{ displayData.dateDebut }}</span>
                        <span>👥 {{ displayData.format }}</span>
                    </div>
                    
                    <div class="status-badge" :class="displayData.statut.toLowerCase().replace(' ', '-')">
                        ● {{ displayData.statut }}
                    </div>

                    <button class="btn btn-outline full-width">Voir les détails</button>
                </div>
            </div>
        </div>
    </section>
</template>