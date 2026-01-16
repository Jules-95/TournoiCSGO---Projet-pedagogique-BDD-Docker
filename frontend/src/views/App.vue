<script setup>
import { ref } from 'vue'
import { RouterLink, RouterView } from 'vue-router'

const navLinks = ref([
  { text: 'Accueil', url: '/' },
  { text: 'Matchs', url: '/matchs' },
  { text: 'Équipes et participants', url: '/equipes' },
  { text: 'Classements', url: '/classements' },
  { text: 'À propos', url: '/a-propos' }
])
</script>

<template>
  <div class="app-layout">
    <header class="main-header">
        <router-link to="/" class="logo-container">
            <div class="logo-icon"></div>
            TOURNOI BAGARRE
        </router-link>

        <nav>
            <ul class="nav-links">
                <li v-for="(link, index) in navLinks" :key="index">
                  <router-link :to="link.url" active-class="active-link">
                    {{ link.text }}
                  </router-link>
                </li>
            </ul>
        </nav>

        <div class="auth-buttons">
            <router-link to="/dashboard" class="btn btn-outline">Mon Espace</router-link>
            <router-link to="/rejoindre" class="btn btn-outline">S'inscrire</router-link>
        </div>
    </header>

    <main>
      <RouterView />
    </main>

    <footer>
        <p>© 2026 Tournoi Bagarre - Projet Esport.</p>
        <div class="footer-links">
           <router-link to="/a-propos">À propos</router-link>
           <a href="#">Mentions Légales</a>
        </div>
    </footer>
  </div>
</template>

<style>
.nav-links a.active-link { color: var(--accent-primary); position: relative; }
.nav-links a.active-link::after { content: ''; position: absolute; bottom: -5px; left: 0; width: 100%; height: 2px; background-color: var(--accent-primary); }
.footer-links { margin-top: 10px; display: flex; justify-content: center; gap: 20px; font-size: 0.9rem; }
.footer-links a { color: var(--text-gray); text-decoration: none; }
.footer-links a:hover { color: var(--text-light); }
</style>
