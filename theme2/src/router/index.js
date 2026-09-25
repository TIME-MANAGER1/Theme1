import { createRouter, createWebHistory } from "vue-router";
import ChartManager from "../components/ChartManager.vue";
import UserWorkingTimeView from '../components/WorkingTime.vue';

const router = createRouter({
  history: createWebHistory(),

  scrollBehavior(to) {
    if (to.hash) {
      return {
        el: to.hash,
        behavior: "smooth"
      };
    }

    return { top: 0 };
  },

  routes: [
    {
      path: '/',
      redirect: '/working-times/1' // Redirige la racine vers l'utilisateur 1 par défaut
    },
    {
      path: "/chartManager/:userid",
      name: "ChartManager",
      component: ChartManager
    },
    {
      path: '/working-times/:userid',
      name: 'WorkingTimesView',
      component: UserWorkingTimeView
    }
  ]
});

export default router;