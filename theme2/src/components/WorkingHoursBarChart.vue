<template>
  <div class="chart-content">
    <h2>Working Hours per Day</h2>

    <Bar
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
  BarElement,
  CategoryScale,
  LinearScale
} from "chart.js";

import { Bar } from "vue-chartjs";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

export default {
  components: {
    Bar
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
        const durationHours = durationMilliseconds / (1000 * 60 * 60);

        return durationHours;
      });

      return {
        labels: labels,

        datasets: [
          {
            label: "Working Hours",
            data: hours,
            backgroundColor: "#df7959",
            borderColor: "#b75c43",
            borderWidth: 1,
            borderRadius: 5
          }
        ]
      };
    },

    chartOptions() {
      return {
        responsive: true,

        plugins: {
          legend: {
            display: true
          }
        },

        scales: {
          y: {
            beginAtZero: true,
            grid: {
              color: "#eadfd3"
            },
            title: {
              display: true,
              text: "Hours",
              color: "#71807a"
            }
          },

          x: {
            grid: {
              color: "#f0e7dc"
            },
            title: {
              display: true,
              text: "Date",
              color: "#71807a"
            }
          }
        }
      };
    }
  }
};
</script>