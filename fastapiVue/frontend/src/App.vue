<script setup>
import { ref, onMounted } from 'vue'
import DataTable from './components/DataTable.vue'

const rows = ref([])
const loading = ref(true)
const error = ref(null)

onMounted(async () => {
  try {
    const res = await fetch('/api/films')
    rows.value = await res.json()
  } catch (e) {
    error.value = 'Erreur API'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <h1>Liste des films</h1>

  <p v-if="loading">Chargement...</p>
  <p v-else-if="error">{{ error }}</p>
  <DataTable v-else :rows="rows" />

</template>
