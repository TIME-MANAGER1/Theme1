import { createRouter, createWebHistory } from "vue-router";
import ChartManager from "../components/ChartManager.vue";

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
      path: "/chartManager/:userid",
      name: "ChartManager",
      component: ChartManager
    }
  ]
});

export default router;