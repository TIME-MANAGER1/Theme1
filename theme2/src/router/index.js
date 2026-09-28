import { createRouter, createWebHistory } from "vue-router";
import ChartManager from "../components/ChartManager.vue";
import WorkingTimes from "../components/WorkingTimes.vue";
import WorkingTime from "../components/WorkingTime.vue";
import ClockManager from "../components/ClockManager.vue";

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
      name: 'Home',
      component: { template: '<div></div>' }
    },
    {
      path: '/workingTimes/:userID',
      alias: ['/workingTimes/:userid', '/working-times/:userid', '/working-times/:userID'],
      name: 'WorkingTimes',
      component: WorkingTimes,
      props: true
    },
    {
      path: '/workingTime/:userid/:workingtimeid',
      name: 'WorkingTimeEdit',
      component: WorkingTime,
      props: true
    },
    {
      path: '/workingTime/:userid',
      name: 'WorkingTimeCreate',
      component: WorkingTime,
      props: true
    },
    {
      path: '/clock/:userid',
      alias: ['/clock/:userID'],
      name: 'ClockManager',
      component: ClockManager,
      props: true
    },
    {
      path: "/chartManager/:userid",
      name: "ChartManager",
      component: ChartManager
    }
  ]
});

export default router;