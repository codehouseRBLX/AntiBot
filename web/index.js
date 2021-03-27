const express = require('express');
const bodyParser = require('body-parser');
const brain      = require('brain.js')
const trainData  = require('./src/training-data')
const serializer = require('./src/serializer')
const net        = new brain.NeuralNetwork()

const app = express();

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// HOME @GET
app.get('/', (req, res) => {
  res.send("AntiBot API up and running");
});

// PING @GET
app.get('/ping', (req, res) => {
  res.send("Pong! I'm awake!");
});

// NEW @POST
app.post('/new', (req, res) => {
net.train(serializer.serialize(trainData))

var outputs = []
for (let i = 0; i < req.body.chats.length; i++) {
  let out = net.run(serializer.encode(req.body.chats[i]))
  outputs.push(out)
}

res.status(200).json({message: "success", data: outputs})
});

// REPORT @POST
app.post('/report', (req, res) => {
res.sendStatus(200)
});

app.listen(8080, () => console.log(`im not dead`));
