const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

app.post('/run_osint', (req, res) => {
    const { mobile, name, email, desc } = req.body;

    console.log('Starting OSINT Data Collection with Bash...');

    const bashProcess = spawn('bash', ['osint_collect.sh', mobile, name, email, desc]);

    bashProcess.stdout.on('data', (data) => {
        console.log(`Bash Output: ${data}`);
    });

    bashProcess.stderr.on('data', (data) => {
        console.error(`Bash Error: ${data}`);
    });

    bashProcess.on('close', (code) => {
        console.log(`Bash script exited with code ${code}`);

        console.log('Starting Python Gemini Analysis...');

        const pythonProcess = spawn('python', ['analyze_with_gemini.py']);

        pythonProcess.stdout.on('data', (data) => {
            console.log(`Python Output: ${data}`);
        });

        pythonProcess.stderr.on('data', (data) => {
            console.error(`Python Error: ${data}`);
        });

        pythonProcess.on('close', (code) => {
            console.log(`Python script exited with code ${code}`);
            res.send('OSINT Collection and Analysis Completed. PDF Report Generated.');
        });
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
