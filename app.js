const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send(`
        <h1>POC-18 AWS ECS Fargate Deployment</h1>
        <h2>Application Running Successfully </h2>
    `);
});

app.listen(3000, '0.0.0.0', () => {
    console.log('Server running on port 3000');
});
