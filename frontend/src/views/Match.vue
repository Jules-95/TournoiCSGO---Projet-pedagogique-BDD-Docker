
<script setup>
import { ref } from 'vue'

// Mock données des matchs
const plannedMatches = ref([
  {
    id: 1,
    team1: 'Team Falcons',
    team2: 'G2 Esports',
    score: '0-0',
    time: '18:00',
    date: '16 Jan',
    tournament: 'VCT Masters',
    gameTous: 'CS:GO'
  },
  {
    id: 2,
    team1: 'Astralis',
    team2: 'Natus Vincere',
    score: '0-0',
    time: '20:30',
    date: '16 Jan',
    tournament: 'BLAST Premier',
    game: 'CS:GO'
  },
  {
    id: 3,
    team1: 'T1',
    team2: 'DWG KIA',
    score: '0-0',
    time: '22:00',
    date: '16 Jan',
    tournament: 'LCK Spring',
    game: 'CS:GO'
  }
])

const liveMatches = ref([
  {
    id: 4,
    team1: 'Fnatic',
    team2: 'Team Liquid',
    score: '12-8',
    time: 'LIVE',
    date: '16 Jan',
    tournament: 'VCT EMEA',
    game: 'CS:GO',
  },
  {
    id: 5,
    team1: 'Vitality',
    team2: 'Heroic',
    score: '15-14',
    time: 'LIVE',
    date: '16 Jan',
    tournament: 'ESL Pro League',
    game: 'CS:GO',
    map: 'Map 3/3'
  }
])

const completedMatches = ref([
  {
    id: 6,
    team1: 'Cloud9',
    team2: '100 Thieves',
    score: '2-0',
    time: '16:30',
    date: '15 Jan',
    tournament: 'VCT Americas',
    game: 'CS:GO',
    winner: 'Cloud9'
  },
  {
    id: 7,
    team1: 'FaZe Clan',
    team2: 'Complexity',
    score: '2-1',
    time: '19:00',
    date: '15 Jan',
    tournament: 'IEM Katowice',
    game: 'CS:GO',
    winner: 'FaZe Clan'
  },
  {
    id: 8,
    team1: 'Gen.G',
    team2: 'T1',
    score: '2-0',
    time: '14:00',
    date: '15 Jan',
    tournament: 'LCK Spring',
    game: 'CS:GO',
    winner: 'Gen.G'
  },
  {
    id: 9,
    team1: 'NRG Esports',
    team2: 'OpTic Gaming',
    score: '3-2',
    time: '17:30',
    date: '15 Jan',
    tournament: 'RLCS',
    game: 'CS:GO',
    winner: 'NRG Esports'
  }
])

const getGameBadgeStyle = (game) => {
  const styles = {
    'CS:GO': { backgroundColor: '#ff9f43' },
  }
  return styles[game] || { backgroundColor: '#666' }
}
</script>

<template>
  <div class="matches-container">
    <section class="matches-header">
      <h1>CONFRONTATIONS</h1>
      <p>Suivez tous les matchs en direct et consultez les résultats</p>
    </section>

    <div class="matches-grid">
      <!-- Matchs Planifiés -->
      <div class="matches-column">
        <div class="column-header">
          <h2>📅 À VENIR</h2>
          <span class="match-count">{{ plannedMatches.length }} matchs</span>
        </div>
        
        <div class="matches-list">
          <div v-for="match in plannedMatches" :key="match.id" class="match-card">
            <div class="match-header">
              <span class="game-badge" :style="getGameBadgeStyle(match.game)">
                {{ match.game }}
              </span>
              <span class="match-time">{{ match.date }}, {{ match.time }}</span>
            </div>
            
            <div class="teams">
              <div class="team">
                <span class="team-name">{{ match.team1 }}</span>
              </div>
              <div class="score-display">
                <span class="score">{{ match.score }}</span>
              </div>
              <div class="team">
                <span class="team-name">{{ match.team2 }}</span>
              </div>
            </div>
            
            <div class="match-footer">
              <span class="tournament-name">{{ match.tournament }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Matchs en Cours -->
      <div class="matches-column">
        <div class="column-header">
          <h2>🔴 EN DIRECT</h2>
          <span class="match-count">{{ liveMatches.length }} matchs</span>
        </div>
        
        <div class="matches-list">
          <div v-for="match in liveMatches" :key="match.id" class="match-card live">
            <div class="match-header">
              <span class="game-badge" :style="getGameBadgeStyle(match.game)">
                {{ match.game }}
              </span>
              <span class="live-indicator">● {{ match.time }}</span>
              <span v-if="match.map" class="map-info">{{ match.map }}</span>
            </div>
            
            <div class="teams">
              <div class="team">
                <span class="team-name">{{ match.team1 }}</span>
              </div>
              <div class="score-display">
                <span class="score live-score">{{ match.score }}</span>
              </div>
              <div class="team">
                <span class="team-name">{{ match.team2 }}</span>
              </div>
            </div>
            
            <div class="match-footer">
              <span class="tournament-name">{{ match.tournament }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Matchs Terminés -->
      <div class="matches-column">
        <div class="column-header">
          <h2>✅ TERMINÉS</h2>
          <span class="match-count">{{ completedMatches.length }} matchs</span>
        </div>
        
        <div class="matches-list">
          <div v-for="match in completedMatches" :key="match.id" class="match-card completed">
            <div class="match-header">
              <span class="game-badge" :style="getGameBadgeStyle(match.game)">
                {{ match.game }}
              </span>
              <span class="match-time">{{ match.date }}, {{ match.time }}</span>
            </div>
            
            <div class="teams">
              <div class="team" :class="{ winner: match.winner === match.team1 }">
                <span class="team-name">{{ match.team1 }}</span>
              </div>
              <div class="score-display">
                <span class="score">{{ match.score }}</span>
              </div>
              <div class="team" :class="{ winner: match.winner === match.team2 }">
                <span class="team-name">{{ match.team2 }}</span>
              </div>
            </div>
            
            <div class="match-footer">
              <span class="tournament-name">{{ match.tournament }}</span>
              <span v-if="match.winner" class="winner-text">🏆 {{ match.winner }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.matches-container {
  padding: 40px 5%;
  min-height: calc(100vh - 200px);
}

.matches-header {
  text-align: center;
  margin-bottom: 50px;
}

.matches-header h1 {
  font-size: 3rem;
  font-weight: 900;
  margin-bottom: 15px;
  text-transform: uppercase;
  background: linear-gradient(to right, var(--text-light), var(--accent-primary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.matches-header p {
  color: var(--text-gray);
  font-size: 1.2rem;
}

.matches-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
}

.matches-column {
  display: flex;
  flex-direction: column;
}

.column-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid var(--accent-primary);
}

.column-header h2 {
  font-size: 1.5rem;
  font-weight: 800;
  margin: 0;
}

.match-count {
  color: var(--text-gray);
  font-size: 0.9rem;
  font-weight: 600;
}

.matches-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
  flex-grow: 1;
}

.match-card {
  background-color: var(--bg-card);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: transform 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
}

.match-card:hover {
  transform: translateY(-5px);
  border-color: var(--accent-primary);
  box-shadow: 0 10px 25px rgba(0, 212, 255, 0.2);
}

.match-card.live {
  border-color: rgba(255, 0, 85, 0.3);
  background: linear-gradient(135deg, var(--bg-card), rgba(255, 0, 85, 0.05));
  animation: pulse 2s infinite;
}

.match-card.completed {
  border-color: rgba(179, 179, 179, 0.3);
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(255, 0, 85, 0.2); }
  50% { box-shadow: 0 0 0 10px rgba(255, 0, 85, 0); }
  100% { box-shadow: 0 0 0 0 rgba(255, 0, 85, 0); }
}

.match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  flex-wrap: wrap;
  gap: 10px;
}

.game-badge {
  padding: 4px 8px;
  font-size: 0.75rem;
  font-weight: 800;
  border-radius: 4px;
  text-transform: uppercase;
  color: white;
}

.match-time {
  color: var(--text-gray);
  font-size: 0.85rem;
  font-weight: 600;
}

.live-indicator {
  color: #ff0055;
  font-weight: bold;
  font-size: 0.85rem;
  animation: blink 1s infinite;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0.5; }
}

.map-info {
  background: rgba(0, 212, 255, 0.2);
  color: var(--accent-primary);
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
}

.teams {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.team {
  flex: 1;
  text-align: center;
}

.team-name {
  font-weight: 700;
  font-size: 1rem;
  color: var(--text-light);
}

.team.winner .team-name {
  color: #00ff88;
  text-shadow: 0 0 10px rgba(0, 255, 136, 0.5);
}

.score-display {
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.score {
  font-size: 1.5rem;
  font-weight: 900;
  color: var(--accent-primary);
  background: rgba(0, 212, 255, 0.1);
  padding: 8px 16px;
  border-radius: 8px;
  min-width: 60px;
  text-align: center;
}

.live-score {
  color: #ff0055;
  background: rgba(255, 0, 85, 0.1);
  animation: pulse 1.5s infinite;
}

.match-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.tournament-name {
  color: var(--text-gray);
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
}

.winner-text {
  color: #00ff88;
  font-size: 0.8rem;
  font-weight: 700;
}

/* Responsive */
@media (max-width: 1200px) {
  .matches-grid {
    grid-template-columns: 1fr;
    gap: 40px;
  }
  
  .matches-column {
    max-width: 600px;
    margin: 0 auto;
    width: 100%;
  }
}

@media (max-width: 768px) {
  .matches-container {
    padding: 20px 3%;
  }
  
  .matches-header h1 {
    font-size: 2rem;
  }
  
  .match-card {
    padding: 15px;
  }
  
  .teams {
    flex-direction: column;
    gap: 15px;
  }
  
  .score-display {
    padding: 0;
  }
  
  .team-name {
    font-size: 0.9rem;
  }
  
  .score {
    font-size: 1.2rem;
  }
}
</style>