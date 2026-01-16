<script setup>
import { ref, onMounted } from 'vue'

const teams = ref([])
const participants = ref([]) 
const loading = ref(true)

const fetchData = async () => {
    loading.value = true
    setTimeout(() => {
      // Mock Data Équipes
      teams.value = [
        { id: 1, nom: 'Karmine Corp', tag: 'KC', jeu: 'VALORANT', avatar: '🟦', membres: 5, description: "L'équipe au mur bleu." },
        { id: 2, nom: 'Vitality', tag: 'VIT', jeu: 'CS2', avatar: '🐝', membres: 5, description: "V for Victory." },
        { id: 3, nom: 'Gentle Mates', tag: 'M8', jeu: 'VALORANT', avatar: '🟩', membres: 6, description: "Mates before dates." },
        { id: 4, nom: 'Solary', tag: 'SLY', jeu: 'LOL', avatar: '☀️', membres: 5, description: "Les amis du soleil." },
        { id: 5, nom: 'Mandatory', tag: 'MDR', jeu: 'VALORANT', avatar: '🔨', membres: 5, description: "Toujours présents." }
      ]

      // Mock Data Participants
      participants.value = [
        { id: 1, pseudo: 'ZywOo', isPro: true, structure: 'Vitality', country: 'FR', avatar: '👑' },
        { id: 2, pseudo: 'Faker', isPro: true, structure: 'T1', country: 'KR', avatar: '🐐' },
        { id: 3, pseudo: 'Gotaga', isPro: false, structure: null, country: 'FR', avatar: '🔴' },
        { id: 4, pseudo: 'S1mple', isPro: true, structure: 'Falcons', country: 'UA', avatar: '🎯' },
        { id: 5, pseudo: 'KennyS', isPro: false, structure: null, country: 'FR', avatar: '⚡' },
        { id: 6, pseudo: 'Caps', isPro: true, structure: 'G2', country: 'DK', avatar: '🧢' }
      ]

      loading.value = false
    }, 600)
}

onMounted(() => {
  fetchData()
})
</script>

<template>
  <div class="page-container">
    <div class="header-section">
      <h1 class="page-main-title">Les Forces en Présence</h1>
      <p class="page-subtitle">Découvrez l'ensemble des compétiteurs inscrits au tournoi.</p>
    </div>

    <div v-if="!loading">
      
      <section class="list-section">
        <h2 class="section-title">🏆 Les Équipes</h2>
        <div class="grid-container teams-grid">
          <div v-for="team in teams" :key="team.id" class="card team-card">
            <div class="card-header">
              <div class="avatar-large">{{ team.avatar }}</div>
              <div class="identity">
                <h2>{{ team.nom }}</h2>
                <span class="tag">[{{ team.tag }}]</span>
              </div>
            </div>
            <div class="card-body">
              <p class="description">{{ team.description }}</p>
              <div class="info-badges">
                <span class="badge game">🎮 {{ team.jeu }}</span>
                <span class="badge members">👥 {{ team.membres }} Joueurs</span>
              </div>
            </div>
            <div class="card-footer">
              <button class="btn btn-outline full-width">Voir l'équipe</button>
            </div>
          </div>
        </div>
      </section>

      <div class="section-divider"></div>

      <section class="list-section">
        <h2 class="section-title">👤 Les Participants</h2>
        <div class="grid-container participants-grid">
          <div v-for="player in participants" :key="player.id" class="card participant-card" :class="{ 'pro-card': player.isPro }">
            <div class="participant-header">
              <div class="avatar-medium">{{ player.avatar }}</div>
              <div class="identity">
                <h2>{{ player.pseudo }} <span v-if="player.isPro" class="pro-badge">PRO</span></h2>
                <span class="country-flag">{{ player.country }}</span>
              </div>
            </div>
            <div class="participant-body">
              <p class="structure-info" v-if="player.isPro">Structure : <strong>{{ player.structure }}</strong></p>
              <p class="structure-info amateur" v-else>Statut : Amateur</p>
            </div>
            <div class="card-footer">
              <button class="btn btn-outline full-width btn-sm">Profil</button>
            </div>
          </div>
        </div>
      </section>
      
    </div>
    
    <div v-else class="loading-state">Chargement...</div>
  </div>
</template>

<style scoped>
.page-container { padding: 60px 5%; max-width: 1400px; margin: 0 auto; }

.header-section { text-align: center; margin-bottom: 60px; }
.page-main-title { font-size: 3rem; text-transform: uppercase; font-weight: 900; color: var(--text-light); text-shadow: 0 0 20px rgba(0, 212, 255, 0.2); }
.page-subtitle { color: var(--text-gray); font-size: 1.2rem; margin-top: 10px; }

/* Sections */
.list-section { margin-bottom: 40px; }
.section-title { 
  font-size: 2rem; 
  margin-bottom: 30px; 
  border-left: 5px solid var(--accent-primary); 
  padding-left: 20px; 
  color: var(--text-light);
}

.section-divider {
  height: 1px;
  background: linear-gradient(to right, transparent, rgba(255,255,255,0.1), transparent);
  margin: 60px 0;
}

/* Grilles et Cartes */
.grid-container { display: grid; gap: 30px; animation: fadeIn 0.4s ease; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

.teams-grid { grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); }
.participants-grid { grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); }

.card {
  background: var(--bg-card);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 16px;
  padding: 25px;
  display: flex; flex-direction: column;
  transition: transform 0.3s ease, border-color 0.3s;
}
.card:hover { transform: translateY(-5px); border-color: var(--accent-primary); }

/* Styles spécifiques */
.card-header, .participant-header { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 15px; }
.avatar-large { width: 64px; height: 64px; background: rgba(255,255,255,0.05); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; }
.avatar-medium { width: 50px; height: 50px; background: rgba(255,255,255,0.05); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; }
.identity h2 { font-size: 1.3rem; margin: 0; font-weight: 800; }
.tag { color: var(--accent-primary); font-weight: 700; }

.pro-card { border-color: rgba(255, 165, 0, 0.3); background: linear-gradient(to bottom right, var(--bg-card), rgba(255, 165, 0, 0.05)); }
.pro-badge { background: orange; color: black; font-size: 0.7rem; padding: 2px 6px; border-radius: 4px; margin-left: 8px; vertical-align: middle; font-weight: bold; }

.card-body, .participant-body { flex-grow: 1; margin-bottom: 20px; color: var(--text-gray); }
.info-badges { display: flex; gap: 10px; margin-top: 15px; }
.badge { font-size: 0.8rem; padding: 4px 10px; border-radius: 4px; background: rgba(255,255,255,0.05); }
.badge.game { background: rgba(155, 89, 182, 0.2); color: #d2b4de; border: 1px solid rgba(155, 89, 182, 0.3); }
.btn-sm { padding: 8px 16px; font-size: 0.9rem; }
.loading-state { text-align: center; padding: 50px; color: var(--text-gray); }
</style>