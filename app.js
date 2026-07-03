const express = require('express');
const mysql = require('mysql2');
const app = express();

const PORT = process.env.PORT || 3000;

const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

app.get('/', (req, res) => {
    connection.query('SELECT NOW() AS current_time', (err, results) => {
        if (err) {
            return res.send(`Database Connection Error: ${err.message}`);
        }

        res.send(`
            <h1>POC-18 AWS ECS Fargate + Aurora DB</h1>
            <h2>Database Connected Successfully ✅</h2>
            <p>Current DB Time: ${results[0].current_time}</p>
        `);
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
