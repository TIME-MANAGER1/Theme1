<template>
  <div class="p-4 border rounded shadow-sm">
    <h2>Formulaire de gestion unitaire</h2>
    
    <!-- Formulaire de saisie -->
    <div class="mb-3">
      <label>Start Date/Time:</label>
      <input type="datetime-local" v-model="start" class="form-control" />
    </div>

    <div class="mb-3">
      <label>End Date/Time:</label>
      <input type="datetime-local" v-model="end" class="form-control" />
    </div>

    <!-- Boutons d'action -->
    <div class="flex gap-2">
      <button @click="createWorkingTime" class="btn btn-primary">Créer</button>
      
      <!-- Si on modifie un élément existant dont on a l'ID -->
      <button v-if="props.workingTimeData?.id" @click="updateWorkingTime(props.workingTimeData.id)" class="btn btn-warning">
        Modifier
      </button>
      
      <button v-if="props.workingTimeData?.id" @click="deleteWorkingTime(props.workingTimeData.id)" class="btn btn-danger">
        Supprimer
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';

// On définit les propriétés reçues par le composant
const props = defineProps({
  userId: { type: Number, required: true },
  workingTimeData: { type: Object, default: null } // Si on veut modifier un élément existant
});

// Variables réactives pour le formulaire
const start = ref('');
const end = ref('');

// Si on passe un objet existant (pour modification), on pré-remplit les champs
watch(() => props.workingTimeData, (newVal) => {
  if (newVal) {
    // Formatage pour input datetime-local (YYYY-MM-DDThh:mm)
    start.value = newVal.start ? newVal.start.slice(0, 16) : '';
    end.value = newVal.end ? newVal.end.slice(0, 16) : '';
  }
}, { immediate: true });

// 1. Créer un Working Time (POST)
const createWorkingTime = async () => {
  try {
    const response = await fetch(`http://localhost:4000/api/workingtime/${props.userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        workingtime: {
          start: new Date(start.value).toISOString(),
          end: new Date(end.value).toISOString()
        }
      })
    });
    if (!response.ok) throw new Error("Erreur lors de la création");
    alert("Working time créé avec succès !");
  } catch (err) {
    console.error(err);
  }
};

// 2. Modifier un Working Time (PUT)
const updateWorkingTime = async (id) => {
  try {
    const response = await fetch(`http://localhost:4000/api/workingtime/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        workingtime: {
          start: new Date(start.value).toISOString(),
          end: new Date(end.value).toISOString()
        }
      })
    });
    if (!response.ok) throw new Error("Erreur lors de la modification");
    alert("Working time mis à jour !");
  } catch (err) {
    console.error(err);
  }
};

// 3. Supprimer un Working Time (DELETE)
const deleteWorkingTime = async (id) => {
  try {
    const response = await fetch(`http://localhost:4000/api/workingtime/${id}`, {
      method: 'DELETE'
    });
    if (!response.ok) throw new Error("Erreur lors de la suppression");
    alert("Working time supprimé !");
  } catch (err) {
    console.error(err);
  }
};
</script>