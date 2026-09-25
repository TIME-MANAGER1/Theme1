<template>
  <main class="wt-wrapper">
    <header class="wt-header">
      <div class="wt-title-group">
        <p class="wt-eyebrow">Utilisateur ID: {{ currentUserId }}</p>
        <h1>Pointeuse & <em>Horloge</em></h1>
      </div>
      <div class="wt-actions">
        <RouterLink :to="`/workingTimes/${currentUserId}`" class="btn-wt btn-outline">
          <span>&larr; Historique des temps</span>
        </RouterLink>
        <RouterLink :to="`/chartManager/${currentUserId}#charts`" class="btn-wt btn-outline">
          <span>&rarr; Graphiques</span>
        </RouterLink>
      </div>
    </header>

    <!-- Feedback Alerts -->
    <div v-if="error" class="wt-alert wt-alert-error">
      <span>Erreur : {{ error }}</span>
      <button class="btn-link" @click="error = ''">Fermer</button>
    </div>

    <div v-if="successMessage" class="wt-alert wt-alert-success">
      <span>{{ successMessage }}</span>
      <button class="btn-link" @click="successMessage = ''">Fermer</button>
    </div>

    <!-- Clocking Status Card -->
    <section class="wt-form-card" style="text-align: center; max-width: 580px;">
      <div class="wt-eyebrow" style="margin-bottom: 12px;">Statut actuel</div>
      
      <div style="margin: 20px 0;">
        <span 
          class="wt-badge" 
          :style="{ 
            background: clockIn ? '#deead9' : '#f8e4e1', 
            color: clockIn ? '#2c592e' : '#8f2d24',
            padding: '8px 18px',
            fontSize: '14px'
          }"
        >
          {{ clockIn ? '? PERIODE DE TRAVAIL EN COURS' : '? INACTIF / NON POINTE' }}
        </span>
      </div>

      <div v-if="clockIn && startDateTime" class="wt-preview-box" style="margin: 20px 0;">
        Travail d&eacute;marr&eacute; le : <strong>{{ formatDate(startDateTime) }}</strong>
        <div style="font-size: 18px; font-weight: 700; margin-top: 6px; color: #263836;">
          Dur&eacute;e &eacute;goul&eacute;e : {{ activeDuration }}
        </div>
      </div>

      <div v-else class="wt-helper-text" style="margin: 16px 0; color: #71807a; font-size: 13px;">
        Cliquez sur le bouton ci-dessous pour d&eacute;marrer ou terminer votre session de travail.
      </div>

      <div style="margin-top: 28px; display: flex; gap: 16px; justify-content: center;">
        <button 
          class="btn-wt" 
          :class="clockIn ? 'btn-danger' : 'btn-primary'"
          style="padding: 14px 28px; font-size: 15px;"
          :disabled="loading"
          @click="clock"
        >
          <span>{{ clockIn ? '? Arrimer / Terminer le travail' : '? Pointer / D&eacute;marrer le travail' }}</span>
        </button>

        <button class="btn-wt btn-outline" @click="refresh" :disabled="loading">
          <span>Rafra&icirc;chir</span>
        </button>
      </div>
    </section>

    <!-- Recent Clock Logs -->
    <section v-if="clocks.length > 0" class="wt-table-card" style="margin-top: 32px;">
      <h3 style="padding: 16px 18px 0; margin: 0; font-size: 16px;">Historique des pointages</h3>
      <table class="wt-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Date &amp; Heure</th>
            <th>Statut</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="c in clocks" :key="c.id">
            <td>#{{ c.id }}</td>
            <td><span class="wt-time-code">{{ formatDate(c.time) }}</span></td>
            <td>
              <span class="wt-badge" :style="{ background: c.status ? '#deead9' : '#f8e4e1', color: c.status ? '#2c592e' : '#8f2d24' }">
                {{ c.status ? 'Arriv&eacute;e (In)' : 'D&eacute;part (Out)' }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </section>
  </main>
</template>

<script>
import "./WorkingTime.css";

export default {
  name: "ClockManager",

  props: {
    userId: {
      type: [Number, String],
      default: null
    }
  },

  data() {
    return {
      clockIn: false,
      startDateTime: null,
      clocks: [],
      loading: false,
      error: "",
      successMessage: "",
      timer: null,
      now: new Date()
    };
  },

  computed: {
    currentUserId() {
      if (this.userId) return this.userId;
      return this.$route.params.userid || this.$route.params.userID || 1;
    },

    activeDuration() {
      if (!this.startDateTime) return '0h 00m';
      const start = new Date(this.startDateTime.replace(' ', 'T'));
      const diffMs = this.now - start;
      if (isNaN(diffMs) || diffMs < 0) return '0h 00m';
      const mins = Math.floor(diffMs / 60000);
      const hrs = Math.floor(mins / 60);
      const remMins = mins % 60;
      return `${hrs}h ${remMins < 10 ? '0' + remMins : remMins}m`;
    }
  },

  watch: {
    '$route.params.userid': {
      immediate: true,
      handler() {
        this.refresh();
      }
    }
  },

  mounted() {
    this.refresh();
    this.timer = setInterval(() => {
      this.now = new Date();
    }, 1000);
  },

  beforeUnmount() {
    if (this.timer) clearInterval(this.timer);
  },

  methods: {
    formatDate(dateStr) {
      if (!dateStr) return '';
      const formatted = dateStr.replace('T', ' ').substring(0, 19);
      if (formatted.length === 16) return formatted + ':00';
      return formatted;
    },

    formatNowToApi() {
      const d = new Date();
      const pad = (n) => String(n).padStart(2, '0');
      return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
    },

    async refresh() {
      this.loading = true;
      this.error = "";

      try {
        const response = await fetch(`/api/clocks/${this.currentUserId}`);
        if (!response.ok) {
          throw new Error("Impossible de récupérer l'historique des pointages.");
        }

        const data = await response.json();
        const list = Array.isArray(data) ? data : (data.data || []);
        this.clocks = list;

        if (list.length > 0) {
          const last = list[list.length - 1];
          this.clockIn = !!last.status;
          this.startDateTime = last.status ? last.time : null;
        } else {
          this.clockIn = false;
          this.startDateTime = null;
        }
      } catch (err) {
        console.error(err);
        this.error = err.message || "Erreur de rafraîchissement.";
      } finally {
        this.loading = false;
      }
    },

    async clock() {
      this.loading = true;
      this.error = "";
      this.successMessage = "";

      const newStatus = !this.clockIn;
      const currentTime = this.formatNowToApi();

      try {
        const response = await fetch(`/api/clocks/${this.currentUserId}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            time: currentTime,
            status: newStatus
          })
        });

        if (!response.ok) {
          throw new Error("Erreur lors de l'enregistrement du pointage.");
        }

        if (newStatus) {
          // Clocking In
          this.clockIn = true;
          this.startDateTime = currentTime;
          this.successMessage = "Pointage d'arrivée enregistré avec succès !";
        } else {
          // Clocking Out -> Auto create WorkingTime
          if (this.startDateTime) {
            await fetch(`/api/workingtime/${this.currentUserId}`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({
                workingtime: {
                  start: this.startDateTime,
                  end: currentTime
                }
              })
            });
          }
          this.clockIn = false;
          this.startDateTime = null;
          this.successMessage = "Pointage de départ enregistré et créneau archivé !";
        }

        await this.refresh();
      } catch (err) {
        console.error(err);
        this.error = err.message || "Erreur lors du pointage.";
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>