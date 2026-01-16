<template>
  <div class="tournament-detail">
    <h1>Détails du Tournoi</h1>
    <p>ID du tournoi: {{ $route.params.id }}</p>
    <!-- Ajoutez ici le contenu détaillé du tournoi -->
  </div>
</template>

<script setup>
// Logique pour récupérer les détails du tournoi
</script>

<style scoped>
.tournament-detail {
  padding: 20px;
}
</style>