<script setup>
import { ref } from 'vue'

// Données du menu de navigation (Accessibles sur toutes les pages)
const navLinks = ref([
  { text: 'Accueil', url: '/' },
  { text: 'Tournois', url: '#' },
  { text: 'Equipes', url: '#' },
  { text: 'Classements', url: '#' }
])
</script>

<template>
  <header class="main-header">
      <router-link to="/" class="logo-container">
          <div class="logo-icon"></div>
          NEXUS ARENA
      </router-link>

      <nav>
          <ul class="nav-links">
              <li v-for="(link, index) in navLinks" :key="index">
                <a :href="link.url">{{ link.text }}</a>
              </li>
          </ul>
      </nav>

      <div class="auth-buttons">
          <button class="btn btn-outline">Connexion</button>
          <button class="btn btn-primary">S'inscrire</button>
      </div>
  </header>

  <main>
    <RouterView />
  </main>

  <footer>
      <p>© 2024 Nexus Arena - Simulation Front-Only.</p>
  </footer>
</template>