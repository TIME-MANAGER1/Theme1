<script setup lang="ts">
  import moment from "moment";
  import { onMounted, ref } from "vue";

  const props = defineProps<{
    userId: number;
  }>();

  const current_time = ref(moment().format("HH:mm:ss"));

  setInterval(() => {
    current_time.value = moment().format("HH:mm:ss");
  }, 1000);

  const clockedIn = ref(false);
  const loading = ref(false);

  async function loadClockStatus() {
    const response = await fetch(`/api/clocks/${props.userId}`);

    if (!response.ok) {
      throw new Error("Failed to load clock status");
    }

    const clocks = await response.json();
    const latestClock = clocks.at(-1);

    clockedIn.value = latestClock?.status ?? false;
  }

  async function handleButtonClick() {
    loading.value = true;

    const response = await fetch(`/api/clocks/${props.userId}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          time: new Date().toISOString(),
          status: !clockedIn.value
        })
    })

    if (!response.ok) {
        loading.value = false;
        throw new Error("Failed to clock in");
    }

    const data = await response.json();
    clockedIn.value = data.status;
    loading.value = false;
  }

  onMounted(loadClockStatus);
</script>

<template>
  <div class="current-time">
    <p>{{ current_time }}</p>
  </div>
  <div class="clock_in_clock_out">
    <button :disabled="loading" @click="handleButtonClick">
      {{ loading ? "Loading..." : clockedIn ? "Clock Out" : "Clock In" }}
    </button>
  </div>
</template>



<style scoped>
.current-time {
  font-size: 2rem;
  font-weight: bold;
  color: #333;
  text-align: center;
  margin-top: 20px;
}
</style>