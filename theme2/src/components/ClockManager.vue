<template>
  <div class="clock-manager-wrapper">
    <Clock :userId="targetUserId" />
  </div>
</template>

<script>
import Clock from "./Clock.vue";

export default {
  name: "ClockManager",

  components: {
    Clock
  },

  props: {
    userId: {
      type: [Number, String],
      default: null
    }
  },

  computed: {
    targetUserId() {
      const u = this.userId;
      if (u !== null && u !== undefined && u !== 'null' && u !== 'undefined' && u !== '') {
        return u;
      }
      return (this.$route && this.$route.params) ? (this.$route.params.userid || this.$route.params.userID || 1) : 1;
    }
  }
};
</script>
