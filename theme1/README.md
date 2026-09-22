# TIME MANAGER - User APIs

This project provides REST APIs for managing users.

## User APIs

### 1. Get All Users

**GET** `/api/users`

```bash
curl.exe http://localhost:4000/api/users
```

You can also filter by email and/or username:

```bash
curl.exe "http://localhost:4000/api/users?email=ahmed@example.com&username=ahmed"
```

### 2. Get User by ID

**GET** `/api/users/:userID`

```bash
curl.exe http://localhost:4000/api/users/1
```

### 3. Create User

**POST** `/api/users`

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

### 4. Update User

**PUT** `/api/users/:userID`

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

### 5. Delete User

**DELETE** `/api/users/:userID`

```bash
curl.exe -i -X DELETE "http://localhost:4000/api/users/1"
```

A successful delete returns:

```text
HTTP/1.1 204 No Content
```

## User Fields

| Field | Type | Required |
|---|---|---|
| username | string | Yes |
| email | string | Yes |

The email must have a valid format such as:

```text
ahmed@example.com
```

## Run the Server

From the project directory:

```bash
mix phx.server
```

The API will be available at:

```text
http://localhost:4000
```
