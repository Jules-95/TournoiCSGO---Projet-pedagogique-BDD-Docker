<script setup>
import { ref } from "vue";

const pseudo = ref("");
const date_naissance = ref("");
const mail = ref("");
const pays = ref("");

async function submit() {
  const res = await fetch("/api/participant", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      pseudo: pseudo.value,
      date_naissance: date_naissance.value,
      mail: mail.value,
      pays: pays.value,
    }),
  });

  const data = await res.json();
  message.value = data.status;
}
</script>

<template>
  <main>
    <section class="hero">
      <div class="hero-content">
        <h1>Tu souhaites rejoindre <br />le tournoi ?</h1>
        <h3>
          Alors inscris toi juste en dessous en rentrant toutes les informations
          nécessaires et participe au prochain tournoi !
        </h3>
      </div>
    </section>
    <section class="formulaire">
      <form @submit.prevent="submit">
        <input v-model="pseudo" placeholder="Pseudo" />
        <input v-model="date_naissance" placeholder="Date de Naissance" />
        <input v-model.number="mail" placeholder="Mail" />
        <input v-model.number="pays" placeholder="Pays" />
        <button class="btn btn-primary size-lg">S'inscrire</button>
      </form>
      <p>{{ message }}</p>
    </section>
  </main>
</template>

<style>
/* CSS spécifique à cette page */
</style>
