<template>
  <div>
    <h2>User</h2>

    <h3>Find User</h3>

    <input
      v-model="searchEmail"
      type="email"
      placeholder="Enter user email"
    >

    <button @click="getUser">
      Find User
    </button>

    <div v-if="user">
      <p>Username: {{ user.username }}</p>
      <p>Email: {{ user.email }}</p>

      <h3>Update User</h3>

      <input
        v-model="editUsername"
        type="text"
        placeholder="Username"
      >

      <input
        v-model="editEmail"
        type="email"
        placeholder="Email"
      >

      <button @click="updateUser">
        Update User
      </button>

      <button @click="deleteUser">
        Delete User
      </button>
    </div>

    <hr>

    <h3>Create User</h3>

    <input
      v-model="newUsername"
      type="text"
      placeholder="Username"
    >

    <input
      v-model="newEmail"
      type="email"
      placeholder="Email"
    >

    <button @click="createUser">
      Create User
    </button>
  </div>
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