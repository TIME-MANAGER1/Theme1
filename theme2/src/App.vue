<!-- <script setup>
import { useRoute } from 'vue-router';
import WorkingTimes from '@/components/WorkingTimes.vue';
import WorkingTimeForm from '@/components/WorkingTime.vue';

const route = useRoute();
const userId = Number(route.params.userid || route.params.id || 1);
</script>

<template>
  <div class="space-y-8 p-6">
    <h2 class="text-2xl font-bold">Espace de gestion des horaires (Utilisateur ID: {{ userId }})</h2>

    <WorkingTimes :userId="userId" />

    <hr class="my-6" />

    <WorkingTimeForm :userId="userId" />
  </div>
</template> -->

<script>
import User from "./components/User.vue";

export default {
  components: {
    User
  }
};
</script>

<template>
  <User />

  <hr>

  <RouterView />
</template>