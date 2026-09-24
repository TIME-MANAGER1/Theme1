<template>
  <main id="charts" class="chart-page">
    <header class="chart-hero">
      <div>
        <p class="chart-kicker">Time Manager / Insights</p>
        <h1>See how your<br><em>time moves.</em></h1>
      </div>
      <p class="chart-subtitle">A clear view of your working rhythm, day by day and over time.</p>
    </header>

    <section class="date-toolbar" aria-label="Filter working times">
      <label class="date-field">
        From
        <input v-model="startDate" type="date">
      </label>
      <label class="date-field">
        To
        <input v-model="endDate" type="date">
      </label>
      <button class="clear-dates" type="button" @click="startDate = ''; endDate = ''">Clear dates</button>
    </section>

    <p v-if="loading" class="chart-status">Loading working times...</p>
    <p v-if="error" class="chart-status chart-status-error">{{ error }}</p>

    <section v-if="!loading && !error" class="chart-grid" aria-label="Working time charts">
      <article class="chart-card chart-card-wide"><WorkingHoursBarChart :workingTimes="filteredWorkingTimes" /></article>
      <article class="chart-card"><WorkingHoursLineChart :workingTimes="filteredWorkingTimes" /></article>
      <article class="chart-card chart-card-pie"><WorkingHoursPieChart :workingTimes="filteredWorkingTimes" /></article>
    </section>
  </main>
</template>

<script>
import WorkingHoursBarChart from "./WorkingHoursBarChart.vue";
import WorkingHoursLineChart from "./WorkingHoursLineChart.vue";
import WorkingHoursPieChart from "./WorkingHoursPieChart.vue";

export default {
  components: {
    WorkingHoursBarChart,
    WorkingHoursLineChart,
    WorkingHoursPieChart
  },

  data() {
    return {
        workingTimes: [],
        startDate: "",
        endDate: "",
        loading: false,
        error: ""
    };
  },

  computed: {
    userId() {
      return this.$route.params.userid;
    },

    filteredWorkingTimes() {
        return this.workingTimes.filter((workingTime) => {
            const workingDate = workingTime.start.substring(0, 10);

            if (this.startDate && workingDate < this.startDate) {
            return false;
            }

            if (this.endDate && workingDate > this.endDate) {
            return false;
            }

            return true;
        });
    },
  },

  watch: {
    userId: {
      immediate: true,
      handler() {
        this.getWorkingTimes();
      }
    }
  },

  methods: {
    async getWorkingTimes() {
      const requestedUserId = this.userId;
      this.loading = true;
      this.error = "";
      this.workingTimes = [];
      this.startDate = "";
      this.endDate = "";

      try {
        const response = await fetch(
          `/api/workingtime/${requestedUserId}`
        );

        if (!response.ok) {
          throw new Error("Failed to get working times");
        }

        const result = await response.json();

        if (this.userId === requestedUserId) {
          this.workingTimes = result.data;
        }
      } catch (error) {
        console.error(error);
        this.error = "Could not load working times.";
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style src="./ChartManager.css"></style>