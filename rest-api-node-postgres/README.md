# Task API

A small REST API for managing a task list, built with Express and PostgreSQL.

## Setup

1. Create a database and load the schema:
   ```
   createdb tasks
   psql tasks -f schema.sql
   ```
2. Install dependencies:
   ```
   npm install
   ```
3. Set your database credentials as environment variables, or edit `db.js`.
4. Start the server:
   ```
   npm start
   ```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/tasks` | List all tasks |
| GET | `/tasks/:id` | Get a single task |
| POST | `/tasks` | Create a task — body `{ "title": "..." }` |
| PUT | `/tasks/:id` | Update a task |
| DELETE | `/tasks/:id` | Delete a task |

## Example

```
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Write project README"}'
```
