<script setup>
defineProps({
  rows: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <table v-if="rows.length">
    <thead>
      <tr>
        <th v-for="key in Object.keys(rows[0])" :key="key">
          {{ key }}
        </th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(row, i) in rows" :key="i">
        <td v-for="(value, key) in row" :key="key">
          {{ value }}
        </td>
      </tr>
    </tbody>
  </table>

  <p v-else>Aucune donnée</p>
</template>

<style scoped>
table {
  border-collapse: collapse;
}
th, td {
  border: 1px solid #ccc;
  padding: 0.5rem;
}
th {
  background: #666666;
}
</style>
