const scam = require('./d-scam')
const notscam   = require('./d-notscam')

const datas = [
  ...scam,
  ...notscam
];

module.exports = datas
