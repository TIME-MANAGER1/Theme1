<template>
  <div class="chart-content">
    <h2>Working Hours Trend</h2>

    <Line
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
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale
} from "chart.js";

import { Line } from "vue-chartjs";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale
);

export default {
  components: {
    Line
  },

  props: {
    workingTimes: {
      type: Array,
      required: true
    }
  },

  computed: {
    chartData() {
      const labels = this.workingTimes
        .slice()
        .reverse()
        .map((workingTime) => {
          return new Date(workingTime.start).toLocaleDateString();
        });

      const hours = this.workingTimes
        .slice()
        .reverse()
        .map((workingTime) => {
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
            tension: 0.3,
            borderColor: "#287c78",
            backgroundColor: "rgba(40, 124, 120, .14)",
            pointBackgroundColor: "#df7959",
            pointBorderColor: "#fffdf7",
            pointBorderWidth: 2,
            pointRadius: 5,
            fill: true
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