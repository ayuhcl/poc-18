const express = require('express');
const { Client } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: 5432
});

client.connect()
    .then(() => console.log('Connected to Aurora PostgreSQL'))
    .catch(err => console.error('Database connection error:', err));

app.get('/', async (req, res) => {
    try {
        const result = await client.query('SELECT NOW()');

        res.send(`
            <h1>POC-18 AWS ECS Fargate + Aurora PostgreSQL</h1>
            <h2>Database Connected Successfully </h2>
            <p>Current DB Time: ${result.rows[0].now}</p>
        `);
    } catch (err) {
        res.send(`Database Connection Error: ${err.message}`);
    }
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
