<script setup>
import { ref } from "vue";

const pseudo = ref("");
const date_naissance = ref("");
const mail = ref("");
const pays = ref("");

async function submit() {
  const formData = new FormData();
  formData.append("pseudo", pseudo.value);
  formData.append("date_naissance", date_naissance.value);
  formData.append("mail", mail.value);
  formData.append("pays", pays.value);

  const res = await fetch("http://localhost:8000/participants", {
    method: "POST",
    body: formData,
  });

  const data = await res.json();
  message.value = data.status;
}


const participants = ref([]);
const message = ref("");

async function getParticipants() {
  const res = await fetch("http://localhost:8000/participants", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await res.json();
  console.log(data)
  participants.value = data;
  message.value = data.status ?? "Données récupérées ✅";
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
    <button @click="getParticipants">Afficher les participants</button>
    <section class="formulaire">
      <form @submit.prevent="submit" class="formContainer">
        <div class="grid">
          <div class="form-group">
            <label for="">Pseudo</label>
            <input v-model="pseudo" placeholder="Pseudo" />
          </div>
          <div class="form-group">
            <label for="">Date de Naissance</label>
            <input v-model="date_naissance" placeholder="Date de Naissance" />
          </div>
          <div class="form-group">
            <label for="">Mail</label>
            <input v-model.number="mail" placeholder="Mail" />
          </div>
          <div class="form-group">
            <label for="">Pays</label>
            <input v-model.number="pays" placeholder="Pays" />
          </div>
        </div>
        <button class="btn btn-primary size-lg">S'inscrire</button>
      </form>
      <p>{{ message }}</p>
    </section>
  </main>
</template>

<style>
/* CSS spécifique à cette page */
</style>
