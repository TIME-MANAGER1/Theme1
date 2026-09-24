<template>
  <main class="page-shell">
    <header class="topbar">
      <a class="brand" href="#" aria-label="Time Manager home"><span class="brand-mark">T</span><span>Time Manager</span></a>
      <span class="workspace-label">Time Manager <span class="status-dot"></span></span>
    </header>

    <section class="hero">
      <p class="eyebrow">Account workspace</p>
      <h1>Make time for<br><em>the right people.</em></h1>
      <p class="hero-copy">Keep your team directory clear, current, and easy to find.</p>
    </section>

    <div class="content-grid">
      <aside class="search-panel">
        <div class="panel-heading"><span class="step-number">01</span><div><p class="eyebrow">Directory</p><h2>Find a person</h2></div></div>
        <form class="search-form" @submit.prevent="getUser">
          <label for="search-email">Email address</label>
          <div class="input-with-icon"><span aria-hidden="true">@</span><input id="search-email" v-model="searchEmail" type="email" placeholder="name@company.com" required></div>
          <button class="button button-primary" type="submit"><span>Search directory</span><span class="button-arrow" aria-hidden="true">&#8599;</span></button>
        </form>
        <p class="helper-text">Search by the email address attached to the account.</p>
      </aside>

      <section class="main-panel" aria-live="polite">
        <div v-if="user" class="profile-view">
          <div class="profile-header"><div class="avatar">TM</div><div><p class="eyebrow">Selected account</p><h2>{{ user.username }}</h2><p class="muted">{{ user.email }}</p></div><span class="member-tag">Active</span></div>
          <form class="editor" @submit.prevent="updateUser">
            <div class="section-title"><span class="step-number">02</span><div><p class="eyebrow">Profile details</p><h3>Edit account</h3></div></div>
            <div class="form-grid"><label>Full name<input v-model="editUsername" type="text" placeholder="Full name" required></label><label>Email address<input v-model="editEmail" type="email" placeholder="name@company.com" required></label></div>
            <div class="editor-actions"><button class="button button-primary" type="submit">Save changes<span class="button-arrow" aria-hidden="true">&#8599;</span></button><RouterLink class="chart-link" :to="`/chartManager/${user.id}#charts`">View working-time charts <span aria-hidden="true">&#8599;</span></RouterLink><button class="text-button" type="button" @click="deleteUser">Remove account</button></div>
          </form>
        </div>

        <div v-else class="empty-state"><div class="empty-orbit"><span></span></div><p class="eyebrow">Your directory awaits</p><h2>Search for an account<br>to get started.</h2><p class="muted">The person’s profile and editing tools will appear here.</p></div>

        <div class="create-panel"><div class="section-title"><span class="step-number">03</span><div><p class="eyebrow">New entry</p><h3>Add someone</h3></div></div><form class="create-form" @submit.prevent="createUser"><input v-model="newUsername" type="text" placeholder="Full name" aria-label="New user name" required><input v-model="newEmail" type="email" placeholder="Email address" aria-label="New user email" required><button class="button button-secondary" type="submit">Add person <span aria-hidden="true">+</span></button></form></div>
      </section>
    </div>
    <footer class="footer"><span>Time Manager directory</span><span>Made for focused teams · 2026</span></footer>
  </main>
</template>

<script>
export default {
  name: "User",

  data() {
    return {
        user: null,
        searchEmail: "",
        newUsername: "",
        newEmail: "",
        editUsername: "",
        editEmail: "",
        
    };
  },

  methods: {
    async createUser() {
      const response = await fetch("/api/users", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          username: this.newUsername,
          email: this.newEmail
        })
      });

      if (!response.ok) {
        throw new Error("Failed to create user");
      }

      const createdUser = await response.json();

      console.log("Created user:", createdUser);

      this.newUsername = "";
      this.newEmail = "";
    },

    async updateUser() {
        const response = await fetch(`/api/users/${this.user.id}`, {
            method: "PUT",
            headers: {
            "Content-Type": "application/json"
            },
            body: JSON.stringify({
            username: this.editUsername,
            email: this.editEmail
            })
        });

        if (!response.ok) {
            throw new Error("Failed to update user");
        }

        this.user = await response.json();

        this.editUsername = this.user.username;
        this.editEmail = this.user.email;
    },

    async getUser() {
        const response = await fetch(
            `/api/users?email=${encodeURIComponent(this.searchEmail)}`
        );

        if (!response.ok) {
            throw new Error("Failed to find user");
        }

        const users = await response.json();

        if (users.length === 0) {
            this.user = null;
            alert("User not found");
            return;
        }

        this.user = users[0];

        this.editUsername = this.user.username;
        this.editEmail = this.user.email;
    },

    async deleteUser() {
        const response = await fetch(`/api/users/${this.user.id}`, {
            method: "DELETE"
        });

        if (!response.ok) {
            throw new Error("Failed to delete user");
        }

        this.user = null;
        this.searchEmail = "";
        this.editUsername = "";
        this.editEmail = "";
    },
  }
};
</script>

<style src="./User.css"></style>