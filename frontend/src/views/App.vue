<script setup>
import { ref } from "vue";

// Données du menu de navigation mises à jour
const navLinks = ref([
  { text: "Accueil", url: "/" },
  { text: "Match", url: "/match" },
  { text: "Equipes", url: "/equipes" }, // Lien mis à jour
  { text: "Classements", url: "/classements" }, // Lien mis à jour
]);
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
      <router-link to="/dashboard" class="btn btn-outline"
        >Mon Espace</router-link
      >
      <a href="/rejoindre" class="btn btn-primary">Rejoindre</a>
    </div>
  </header>

  <main>
    <RouterView />
  </main>

  <footer>
    <p>© 2024 Nexus Arena - Simulation Front-Only.</p>
  </footer>
</template>
