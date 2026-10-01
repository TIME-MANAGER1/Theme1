# TIME MANAGER - User APIs
 
This project provides REST APIs for managing users for the **TIME MANAGER** project.
 
## Run Locally vs. Production

| | Local (dev) | Production |
|---|---|---|
| Compose file | `compose.dev.yaml` (database only) | `compose.yaml` (db + backend + frontend images) |
| Backend config | `config/dev.exs` | `config/runtime.exs` (reads env vars) |
| Database | `localhost:5433`, `postgres/postgres`, `theme1_dev` | `DATABASE_URL` from `.env` |

### Local

```bash
# 1. Start the dev database (from the repo root)
docker compose -f compose.dev.yaml up -d

# 2. Backend (from theme1/)
mix deps.get
mix ecto.setup        # or: mix ecto.create && mix ecto.migrate
mix phx.server        # http://localhost:4000

# 3. Frontend (from theme2/)
npm install
npm run dev           # proxies /api to http://localhost:4000
```

If port 4000 is already taken (e.g. the production stack is running locally with `docker compose up`), either stop it with `docker compose down` or use another port:

```bash
PORT=4001 mix phx.server
API_URL=http://localhost:4001 npm run dev
```

To use a different database, set `DATABASE_URL=ecto://USER:PASS@HOST:PORT/DB`.

### Production

Travis builds and pushes the images on `main`, copies `compose.yaml` to the server and runs `docker compose pull && docker compose up -d`. Required variables in the server's `.env`: `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `SECRET_KEY_BASE`.

## Setup for Team Members
 
After cloning the project or pulling the latest changes from the `dev` branch, run the database migrations **before starting the server**.
 
From the project directory:
 
```bash
mix ecto.migrate
```
 
This creates/updates the required database tables and constraints.
 
> **Important:** Every team member should run `mix ecto.migrate` after pulling the latest backend changes, especially when new migration files have been added.
 
After the migrations are complete, start the Phoenix server:
 
```bash
mix phx.server
```
 
The API will be available at:
 
```
http://localhost:4000
```
 
## User API Flow
 
The User component supports the following CRUD operations:
 
```
Create User
    |
    v
POST /api/users
    |
    v
User is stored in the database
    |
    v
Find User by Email
    |
    v
GET /api/users?email=...
    |
    v
User is selected
    |
    +------------------+
    |                  |
    v                  v
Update User        Delete User
    |                  |
    v                  v
PUT /api/users/:id  DELETE /api/users/:id
```
 
## Important User Flow
 
The user's email is unique in the database.
 
The frontend allows the user to enter an email to find the user:
 
```
GET /api/users?email=ahmed@example.com
```
 
Once the user is found, the returned user's `id` is used for updating or deleting that user.
 
For example:
 
**Find:**
```
GET /api/users?email=ahmed@example.com
```
 
⬇
 
**User:**
```json
{
  "id": 1,
  "username": "ahmed",
  "email": "ahmed@example.com"
}
```
 
⬇
 
**Update:**
```
PUT /api/users/1
```
 
or
 
**Delete:**
```
DELETE /api/users/1
```
 
Because email is unique, an email should identify only one user.
 
## User APIs
 
### 1. Get All Users
 
`GET /api/users`
 
```bash
curl.exe http://localhost:4000/api/users
```
 
You can also filter by email and/or username:
 
```bash
curl.exe "http://localhost:4000/api/users?email=ahmed@example.com&username=ahmed"
```
 
### 2. Get User by ID
 
`GET /api/users/:userID`
 
```bash
curl.exe http://localhost:4000/api/users/1
```
 
If the user does not exist, the API returns:
 
```
HTTP/1.1 404 Not Found
```
 
### 3. Create User
 
`POST /api/users`
 
Create a `user.json` file:
 
```json
{
  "username": "ahmed",
  "email": "ahmed@example.com"
}
```
 
Then run:
 
```bash
curl.exe -X POST "http://localhost:4000/api/users" -H "Content-Type: application/json" --data-binary "@user.json"
```
 
A successful creation returns:
 
```
HTTP/1.1 201 Created
```
 
The email must be unique. If the email already exists, the API returns:
 
```
HTTP/1.1 422 Unprocessable Content
```
 
with an error such as:
 
```json
{
  "errors": {
    "email": [
      "has already been taken"
    ]
  }
}
```
 
### 4. Update User
 
`PUT /api/users/:userID`
 
Create an `update-user.json` file:
 
```json
{
  "username": "ahmed_updated",
  "email": "ahmed.new@example.com"
}
```
 
Then run:
 
```bash
curl.exe -X PUT "http://localhost:4000/api/users/1" -H "Content-Type: application/json" --data-binary "@update-user.json"
```
 
The user ID comes from the user found through the email search.
 
For example:
 
```
GET /api/users?email=ahmed@example.com
        ↓
User ID = 1
        ↓
PUT /api/users/1
```
 
The email must remain unique when updating the user.
 
### 5. Delete User
 
`DELETE /api/users/:userID`
 
```bash
curl.exe -i -X DELETE "http://localhost:4000/api/users/1"
```
 
A successful delete returns:
 
```
HTTP/1.1 204 No Content
```
 
If the user does not exist:
 
```
HTTP/1.1 404 Not Found
```
 
## User Fields
 
| Field    | Type   | Required | Description             |
|----------|--------|----------|--------------------------|
| username | string | Yes      | User's username          |
| email    | string | Yes      | User's unique email address |
 
The email must have a valid format such as:
 
```
ahmed@example.com
```
 
The email address is also unique in the database.
 
## Database Migrations
 
The project uses Ecto migrations to create and update the database structure.
 
Before running the server, run:
 
```bash
mix ecto.migrate
```
 
To check the migration status:
 
```bash
mix ecto.migrations
```
 
If another team member has added new migrations and you have pulled those changes, run:
 
```bash
mix ecto.migrate
```
 
again.
 
> **Important for the team:** Do not skip migrations after pulling backend changes. The application may not work correctly if your local database is missing the latest migrations.
 
## Run the Server
 
From the project directory:
 
```bash
mix phx.server
```
 
The API will be available at:
 
```
http://localhost:4000
```
 
## Typical Development Flow
 
For a new team member:
 
1. Clone the repository
2. Checkout the `dev` branch
3. Install dependencies
4. Run database migrations
5. Start Phoenix server
6. Run/test the required APIs
7. Make changes
8. Commit changes
9. Push to `dev`
## After Pulling New Backend Changes
 
Always check whether there are new migrations:
 
```bash
git pull
mix ecto.migrate
```
 
Then start the server:
 
```bash
mix phx.server
```
 
## One Important Change I Made
 
I specifically added this part:
 
```
GET /api/users?email=...
        ↓
Find the unique user
        ↓
Get user's ID
        ↓
PUT /api/users/:id
or
DELETE /api/users/:id
```