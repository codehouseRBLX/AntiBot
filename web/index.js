const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const brain      = require('brain.js');
const trainData  = require('./src/training-data');
const serializer = require('./src/serializer');
const net        = new brain.NeuralNetwork();

const app = express();
net.train(serializer.serialize(trainData));

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

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

let msg;

if (req.body.chats) {
if (req.body.chats[0].length < 50) {
  msg = req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0];
} else {
  msg = req.body.chats[0] + " " + req.body.chats[0] + " " + req.body.chats[0];
}

let out = net.run(serializer.encode(msg));

res.status(200).json({message: "success", data: [out]});
}
});

// REPORT @POST
app.post('/report', (req, res) => {
res.sendStatus(200);
});

app.listen(8080, () => console.log(`im not dead`));
