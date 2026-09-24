<template>
  <div class="chart-content">
    <h2>Working Hours Distribution</h2>

    <Pie
      v-if="chartData.labels.length > 0"
      :data="chartData"
      :options="chartOptions"
    />

    <p v-else>No working time data available.</p>
  </div>
</template>

<script>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  ArcElement
} from "chart.js";

import { Pie } from "vue-chartjs";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  ArcElement
);

export default {
  components: {
    Pie
  },

  props: {
    workingTimes: {
      type: Array,
      required: true
    }
  },

  computed: {
    chartData() {
      const labels = this.workingTimes.map((workingTime) => {
        return new Date(workingTime.start).toLocaleDateString();
      });

      const hours = this.workingTimes.map((workingTime) => {
        const start = new Date(workingTime.start);
        const end = new Date(workingTime.end);

        const durationMilliseconds = end - start;
        const durationHours =
          durationMilliseconds / (1000 * 60 * 60);

        return durationHours;
      });

      return {
        labels: labels,

        datasets: [
          {
            label: "Working Hours",
            data: hours,
            backgroundColor: [
              "#df7959",
              "#287c78",
              "#e5a35a",
              "#7ba6a0",
              "#c77a68",
              "#8b9c68"
            ],
            borderColor: "#fffdf7",
            borderWidth: 3,
            hoverOffset: 8
          }
        ]
      };
    },

    chartOptions() {
      return {
        responsive: true,

        plugins: {
          legend: {
            display: true,
            position: "right",
            labels: {
              color: "#52645f",
              padding: 14,
              usePointStyle: true
            }
          }
        }
      };
    }
  }
};
</script>