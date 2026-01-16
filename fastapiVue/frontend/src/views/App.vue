<script setup>
// Plus de logique de films ici ! 
// Juste le squelette.
</script>

<template>
  <header>
    <nav>
      <RouterLink to="/">Accueil</RouterLink> | 
      <RouterLink to="/a-propos">À Propos</RouterLink> 
    </nav>
  </header>

  <main>
    <RouterView />
  </main>
</template>