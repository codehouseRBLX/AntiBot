const scam = [
  {
    input: "go to bux.gg for a prize",
    output: {scam: 1}
  },
  {
    input: "go to this link for robux",
    output: {scam: 1}
  },
  {
    input: "free prize from this link",
    output: {scam: 1}
  },
  {
    input: "get free gamepasses from this link",
    output: {scam: 1}
  },
  {
    input: "i just got tons of robux from this link",
    output: {scam: 1}
  },
  {
    input: "bux.gg",
    output: {scam: 1}
  },
  {
    input: "go to (DOT)gg",
    output: {scam: 1}
  },
  {
    input: "i got tons of robux from this website",
    output: {scam: 1}
  },
  {
    input: "i just got so many robux from this website for free its not a scam bux.gg",
    output: {scam: 1}
  }
]

module.exports = scam
