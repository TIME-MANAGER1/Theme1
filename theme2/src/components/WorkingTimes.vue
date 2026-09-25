<template>
  <div class="working-times-container p-6 bg-white rounded-xl shadow-sm">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-lg font-bold text-gray-800">Historique des Working Times</h3>
      <button @click="getWorkingTimes" class="text-sm text-blue-600 hover:underline">Actualiser</button>
    </div>

    <!-- Messages de chargement ou d'erreur -->
    <div v-if="loading" class="text-gray-500 py-4">Chargement des horaires...</div>
    <div v-if="error" class="text-red-500 py-4">Erreur : {{ error }}</div>

    <!-- Tableau récapitulatif -->
    <table v-if="!loading && workingTimes.length > 0" class="w-full text-left border-collapse">
      <thead>
        <tr class="border-b text-gray-600 text-sm">
          <th class="py-3 px-2">Début</th>
          <th class="py-3 px-2">Fin</th>
          <th class="py-3 px-2 text-right">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="wt in workingTimes" :key="wt.id" class="border-b hover:bg-gray-50 text-sm">
          <td class="py-3 px-2 text-gray-700">{{ wt.start }}</td>
          <td class="py-3 px-2 text-gray-700">{{ wt.end }}</td>
          <td class="py-3 px-2 text-right">
            <!-- Tu pourras lier ces boutons aux actions de modification/suppression -->
            <button class="text-blue-500 hover:underline mr-3">Éditer</button>
            <button class="text-red-500 hover:underline">Supprimer</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Si la liste est vide -->
    <p v-else-if="!loading" class="text-gray-400 py-4 text-center">Aucun horaire enregistré pour cet utilisateur.</p>
  </div>
</template>

<script setup>
import {ref, onMounted} from 'vue';
const props = defineProps ({
    userId : {
        type: Number,
        required: true,
    }
});
const workingTimes = ref([]);
const loading = ref(false);
const error = ref(null);

const getWorkingTimes = async () => {
  loading.value = true;
  error.value = null;
  try {
    // On appelle ta route API Phoenix
    const response = await fetch(`http://localhost:4000/api/workingtime/${props.userId}`);
    
    if (!response.ok) {
      throw new Error('Erreur lors de la récupération des données');
    }
    
    const result = await response.json();
    // On stocke le tableau "data" renvoyé par Phoenix
    workingTimes.value = result.data;
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};
onMounted(() => {
    getWorkingTimes();
});
</script>
