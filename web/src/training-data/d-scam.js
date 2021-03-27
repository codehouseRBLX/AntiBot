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
    input: "go to this link for R$",
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
    input: "i just got piles of robux from this link",
    output: {scam: 1}
  },
  {
    input: "i just got tons of R$ from this link",
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
  },
  {
    input: "i just won all the gamepasses of this game, all i had to do is to type this link in my web browser",
    output: {scam: 1}
  },
  {
    input: "{System} Your friend visited BLOX.PROMO and earned ROBUX",
    output: {scam: 1}
  },
  {
    input: "Your friend visited BLOX.PROMO and earned ROBUX",
    output: {scam: 1}
  },
  {
    input: "Your friend visited BLOX.PROMO and earned ROBUCKS",
    output: {scam: 1}
  },
  {
    input: "Your friend visited BLOX.PROMO and earned R$",
    output: {scam: 1}
  },
  {
    input: "{System} Visit BLOX.NAVY in browser for ROBUX reward!",
    output: {scam: 1}
  },
  {
    input: "{System} Visit BLOX.NAVY in browser for R$ reward!",
    output: {scam: 1}
  },
  {
    input: "Get a Robux reward for free",
    output: {scam: 1}
  },
  {
    input: "Get a rbx reward for free",
    output: {scam: 1}
  },
  {
    input: "BLOX.NAVY is real oh my god!",
    output: {scam: 1}
  },
  {
    input: "Visit bux.dev for rbx",
    output: {scam: 1}
  },
  {
    input: "Visit bux.dev for ROBUX!",
    output: {scam: 1}
  },
  {
    input: "Visit bux.dev for Robucks!",
    output: {scam: 1}
  },
  {
    input: "Visit bux.dev for R$",
    output: {scam: 1}
  },
  {
    input: "I just got TONS of ROBUX using gain blox.gg! Visit gain blox.gg on your browser to generate TONS of ROBUX instantly!",
    output: {scam: 1}
  },
  {
    input: "I just got TONS of ROBUX using rblx.gg! Visit rblx.gg on your browser to generate TONS of ROBUX instantly!",
    output: {scam: 1}
  },
  {
    input: "just got TONS of ROBUX using getbuckS.me! Visit getbuckS.me in your browser to generate ROBUX instantly!",
    output: {scam: 1}
  },
  {
    input: "Just got TONS of ROBUX using bux.today! Visit bux.today in your browser to get gamepasses instantly!",
    output: {scam: 1}
  },
  {
    input: "Today I got a ton of robux, if you want go to freebucs.club",
    output: {scam: 1}
  },
  {
    input: "visit freebucs.club to get free robux",
    output: {scam: 1}
  },
  {
    input: "Want R$ ? Goto Robuxgiver.tk <--",
    output: {scam: 1}
  },
  {
    input: "R$ ? Goto Robuxgiver.tk <--",
    output: {scam: 1}
  },
  {
    input: "get-bux.me",
    output: {scam: 1}
  },
  {
    input: "{System}",
    output: {scam: 1}
  },
  {
    input: "robux.me",
    output: {scam: 1}
  },
  {
    input: "freerobux.com",
    output: {scam: 1}
  },
  {
    input: "fastbucks.me",
    output: {scam: 1}
  },
  {
    input: "globux.me",
    output: {scam: 1}
  },
  {
    input: "robuxgiver.tk",
    output: {scam: 1}
  },
  {
    input: "freebux4u.com",
    output: {scam: 1}
  },
  {
    input: "roblox.news",
    output: {scam: 1}
  },
  {
    input: "roboxwin.com",
    output: {scam: 1}
  },
  {
    input: "rbxfree.com",
    output: {scam: 1}
  },
  {
    input: "boostmyrobux.info",
    output: {scam: 1}
  },
  {
    input: "get-bux .me",
    output: {scam: 1}
  },
  {
    input: "get-bux. me",
    output: {scam: 1}
  },
  {
    input: "get-bux . me",
    output: {scam: 1}
  },
  {
    input: "oprewards.me",
    output: {scam: 1}
  },
  {
    input: "bux.gg",
    output: {scam: 1}
  },
  {
    input: "generate ROBUX",
    output: {scam: 1}
  },
  {
    input: "gamepasses FREE",
    output: {scam: 1}
  },
  {
    input: "earnpoints.gg",
    output: {scam: 1}
  },
  {
    input: "bux.today",
    output: {scam: 1}
  },
  {
    input: "💰Want LOTS of ROBUX? Go to ➡️blox.page⬅️ in your browser?",
    output: {scam: 1}
  },
  {
    input: "yea, what's the point of buying ROBUX when you can get it off BLOX.NAVY for FREE!",
    output: {scam: 1}
  },
  {
    input: "I'm so thankful for BLOX.NAVY, I can buy all the items I want on the catalog for FREE using it!!",
    output: {scam: 1}
  },
  {
    input: "The site BLOX.ARMY is amazing, likve ive earned so much ROBUX from it idk what I would do withot it.",
    output: {scam: 1}
  },
  {
    input: "Get free neopets and free bucks.",
    output: {scam: 1}
  },
  {
    input: "[ROBLOX]: ",
    output: {scam: 1}
  },
  {
    input: "I just made TONS of ROBUX on the site blox.army!",
    output: {scam: 1}
  },
  {
    input: "Visit freeclaim.army in browser for ROBUX reward!",
    output: {scam: 1}
  },
  {
    input: "Visit freeclaim.army in browser for ROBUX gift!",
    output: {scam: 1}
  },
  {
    input: "Visit claimreward.club to redeem your ROBUX gift!",
    output: {scam: 1}
  },
  {
    input: "Visit claimreward.club to redeem your ROBUX reward!",
    output: {scam: 1}
  },
  {
    input: "Visit claimreward.club to get your ROBUX gift!",
    output: {scam: 1}
  },
  {
    input: "Visit claimreward.club to get your ROBUX reward!",
    output: {scam: 1}
  },
  {
    input: "get free redvalk",
    output: {scam: 1}
  }
]

module.exports = scam
