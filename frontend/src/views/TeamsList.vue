<script setup>
import { ref, onMounted } from 'vue'

const teams = ref([])
const participants = ref([]) 
const loading = ref(true)
const error = ref(null)

// --- FORMULAIRE DE CRÉATION ---
const newTeam = ref({
  nom: '',
  // Tableau de 5 slots pour les ID des joueurs
  membres: ["", "", "", "", ""]
})
const isCreating = ref(false)

// --- FONCTION MODIFIÉE SELON TA DEMANDE (FormData) ---
const createTeam = async () => {
  // 1. Validation basique
  if (!newTeam.value.nom) {
    alert("Veuillez donner un nom à votre équipe !")
    return
  }

  // Filtrer les IDs vides
  const selectedIds = newTeam.value.membres.filter(id => id !== "")
  
  // Vérifier qu'il y a bien 5 joueurs
  if (selectedIds.length < 5) {
    alert("Il faut sélectionner 5 joueurs.")
    return
  }

  // Vérifier les doublons
  const uniqueIds = new Set(selectedIds)
  if (uniqueIds.size !== 5) {
    alert("Un joueur ne peut pas être sélectionné deux fois !")
    return
  }

  try {
    isCreating.value = true

    // 2. Création du FormData
    const formData = new FormData();
    formData.append("nom_equipe", newTeam.value.nom);

    // Pour envoyer une liste via FormData, on append plusieurs fois la même clé
    selectedIds.forEach(id => {
        formData.append("ids_participants", id);
    });

    // 3. Envoi au Backend
    // Note : Pas besoin de header 'Content-Type', le navigateur le met automatiquement en 'multipart/form-data'
    const res = await fetch("http://localhost:8000/equipes", {
      method: "POST",
      body: formData, 
    });

    if (!res.ok) {
        const errText = await res.text()
        throw new Error(errText || "Erreur lors de la création")
    }

    const data = await res.json();
    
    // 4. Succès
    alert("Équipe créée avec succès ! ID: " + (data.id_equipe || 'N/A'));
    
    // Reset du formulaire
    newTeam.value.nom = ''
    newTeam.value.membres = ["", "", "", "", ""]
    
    // Rafraîchir la liste
    fetchData() 

  } catch (e) {
    console.error(e)
    alert("Erreur : " + e.message)
  } finally {
    isCreating.value = false
  }
}

// --- UTILITAIRES ---
const getAvatarColor = (name) => {
    if (!name) return '#34495e';
    const colors = ['#e74c3c', '#3498db', '#9b59b6', '#f1c40f', '#2ecc71', '#e67e22'];
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
        hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
}

const fetchData = async () => {
    loading.value = true
    error.value = null
    try {
        // On récupère les listes
        const [resEquipes, resParticipants] = await Promise.all([
            fetch('/api/equipes'),
            fetch('/api/participants')
        ])
        
        if (!resEquipes.ok || !resParticipants.ok) throw new Error("Erreur serveur")
        
        teams.value = await resEquipes.json()
        participants.value = await resParticipants.json()

    } catch (e) {
        console.error(e)
        error.value = "Impossible de charger les données."
    } finally {
        loading.value = false
    }
}

onMounted(() => {
  fetchData()
})
</script>

<template>
  <div class="page-container">
    
    <div class="header-section">
      <h1 class="page-main-title">Les Forces en Présence</h1>
      <p class="page-subtitle">Découvrez l'ensemble des compétiteurs ou formez votre propre escouade.</p>
    </div>

    <div v-if="loading" class="state-container"><div class="spinner"></div>Chargement...</div>
    <div v-else-if="error" class="state-container error">⚠️ {{ error }}</div>

    <div v-else>
      
      <section class="list-section">
        <h2 class="section-title">🏆 Les Équipes</h2>
        
        <div class="grid-container teams-grid">
          
          <div class="card create-card">
            <div class="create-header">
              <h3>✨ Créer une Équipe</h3>
            </div>
            
            <div class="create-body">
              <div class="form-group">
                <label>Nom de l'équipe</label>
                <input v-model="newTeam.nom" type="text" placeholder="Ex: Les Vengeurs..." />
              </div>

              <div class="roster-selects">
                <label>Sélectionnez 5 Joueurs :</label>
                <div v-for="(member, index) in newTeam.membres" :key="index" class="select-wrapper">
                  <select v-model="newTeam.membres[index]">
                    <option value="" disabled selected>Joueur {{ index + 1 }}</option>
                    <option 
                      v-for="p in participants" 
                      :key="p.id_participant" 
                      :value="p.id_participant">
                      {{ p.pseudo }}
                    </option>
                  </select>
                </div>
              </div>
            </div>

            <div class="card-footer">
              <button 
                @click="createTeam" 
                :disabled="isCreating"
                class="btn btn-primary full-width">
                {{ isCreating ? 'Création...' : 'Valider l\'équipe' }}
              </button>
            </div>
          </div>

          <div v-for="team in teams" :key="team.id_equipe" class="card team-card">
            <div class="card-header">
              <div class="avatar-large" :style="{ backgroundColor: getAvatarColor(team.nom_equipe) }">
                {{ team.nom_equipe ? team.nom_equipe.charAt(0).toUpperCase() : '?' }}
              </div>
              <div class="identity">
                <h2>{{ team.nom_equipe }}</h2>
                <span class="tag">INSCRIT</span> 
              </div>
            </div>
            <div class="card-body">
              <p class="description">Équipe enregistrée.</p>
              <div class="info-badges">
                <span class="badge game">🎮 CS2</span>
              </div>
            </div>
            <div class="card-footer">
              <button class="btn btn-outline full-width">Voir le Roster</button>
            </div>
          </div>

        </div>
      </section>

      <div class="section-divider"></div>

      <section class="list-section">
        <h2 class="section-title">👤 Les Participants Disponibles</h2>
        <div class="grid-container participants-grid">
          <div v-for="player in participants" :key="player.id_participant" class="card participant-card">
            <div class="participant-header">
              <div class="avatar-medium" :style="{ backgroundColor: getAvatarColor(player.pseudo) }">
                 {{ player.pseudo ? player.pseudo.charAt(0).toUpperCase() : '?' }}
              </div>
              <div class="identity">
                <h2>{{ player.pseudo }}</h2>
                <span class="country-flag" v-if="player.pays">📍 {{ player.pays }}</span>
              </div>
            </div>
            <div class="card-footer">
              <button class="btn btn-outline full-width btn-sm">Profil</button>
            </div>
          </div>
        </div>
      </section>
      
    </div>
  </div>
</template>

<style scoped>
/* STYLES GÉNÉRAUX */
.page-container { padding: 60px 5%; max-width: 1400px; margin: 0 auto; }
.header-section { text-align: center; margin-bottom: 60px; }
.page-main-title { font-size: 3rem; text-transform: uppercase; font-weight: 900; color: var(--text-light); text-shadow: 0 0 20px rgba(0, 212, 255, 0.2); }
.page-subtitle { color: var(--text-gray); font-size: 1.2rem; margin-top: 10px; }

/* LOADING / ERROR */
.state-container { text-align: center; padding: 50px; color: var(--text-gray); background: rgba(255,255,255,0.02); border-radius: 12px; margin: 20px 0; }
.state-container.error { color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.3); }
.spinner { width: 40px; height: 40px; border: 4px solid rgba(255,255,255,0.1); border-top-color: var(--accent-primary); border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px auto; }
@keyframes spin { to { transform: rotate(360deg); } }

/* GRILLES */
.list-section { margin-bottom: 40px; }
.section-title { font-size: 2rem; margin-bottom: 30px; border-left: 5px solid var(--accent-primary); padding-left: 20px; color: var(--text-light); font-weight: 800; }
.section-divider { height: 1px; background: linear-gradient(to right, transparent, rgba(255,255,255,0.1), transparent); margin: 60px 0; }
.grid-container { display: grid; gap: 30px; animation: fadeIn 0.5s ease; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.teams-grid { grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); }
.participants-grid { grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); }

/* CARTES STANDARDS */
.card { background: var(--bg-card); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 25px; display: flex; flex-direction: column; transition: transform 0.3s ease, border-color 0.3s; }
.card:hover { transform: translateY(-5px); border-color: var(--accent-primary); }

/* --- STYLE SPÉCIFIQUE CARTE CRÉATION --- */
.create-card {
  border: 2px dashed rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.02);
}
.create-card:hover { border-color: var(--accent-primary); background: rgba(255, 255, 255, 0.05); }
.create-header h3 { margin: 0 0 20px 0; color: var(--accent-primary); text-transform: uppercase; font-size: 1.2rem; }

.form-group { margin-bottom: 15px; }
.form-group label, .roster-selects label { display: block; margin-bottom: 8px; font-size: 0.9rem; color: var(--text-gray); }
.form-group input, .select-wrapper select {
  width: 100%;
  padding: 10px;
  background: rgba(0,0,0,0.3);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 6px;
  color: white;
  margin-bottom: 8px;
}
.form-group input:focus, .select-wrapper select:focus { border-color: var(--accent-primary); outline: none; }
.roster-selects { margin-bottom: 20px; }

/* STYLE ELEMENTS CARTE TEAM */
.card-header, .participant-header { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 15px; }
.avatar-large { width: 64px; height: 64px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; color: white; font-weight: bold; }
.avatar-medium { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; color: white; font-weight: bold;}
.identity h2 { font-size: 1.3rem; margin: 0; font-weight: 800; }
.tag { color: var(--accent-primary); font-weight: 700; font-size: 0.8rem; }
.country-flag { font-size: 0.9rem; color: var(--text-gray); }

.card-body, .participant-body { flex-grow: 1; margin-bottom: 20px; color: var(--text-gray); }
.info-badges { display: flex; gap: 10px; margin-top: 15px; }
.badge { font-size: 0.8rem; padding: 4px 10px; border-radius: 4px; background: rgba(255,255,255,0.05); }
.badge.game { background: rgba(155, 89, 182, 0.2); color: #d2b4de; border: 1px solid rgba(155, 89, 182, 0.3); }

/* BOUTONS */
.btn-sm { padding: 8px 16px; font-size: 0.9rem; }
.btn-primary { background: var(--accent-primary); color: #000; font-weight: bold; border: none; cursor: pointer; transition: 0.3s; padding: 12px; border-radius: 6px; }
.btn-primary:hover { filter: brightness(1.2); }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
</style>