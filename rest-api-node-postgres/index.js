const express = require('express');
const pool = require('./db');

const app = express();
app.use(express.json());

app.get('/tasks', async (req, res) => {
  const result = await pool.query('select * from tasks order by id');
  res.json(result.rows);
});

app.get('/tasks/:id', async (req, res) => {
  const result = await pool.query('select * from tasks where id = $1', [req.params.id]);
  if (result.rows.length === 0) {
    return res.status(404).json({ error: 'Task not found' });
  }
  res.json(result.rows[0]);
});

app.post('/tasks', async (req, res) => {
  const { title } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }
  const result = await pool.query(
    'insert into tasks (title) values ($1) returning *',
    [title]
  );
  res.status(201).json(result.rows[0]);
});

app.put('/tasks/:id', async (req, res) => {
  const { title, done } = req.body;
  const result = await pool.query(
    'update tasks set title = $1, done = $2 where id = $3 returning *',
    [title, done, req.params.id]
  );
  if (result.rows.length === 0) {
    return res.status(404).json({ error: 'Task not found' });
  }
  res.json(result.rows[0]);
});

app.delete('/tasks/:id', async (req, res) => {
  await pool.query('delete from tasks where id = $1', [req.params.id]);
  res.status(204).end();
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
