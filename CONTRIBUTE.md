# Contribution Guide

## Overview

Thanks so much for deciding to add to AntiBot! With your help, we can make this project awesome! Before you begin, please read over the info below, so we can keep AntiBot going strong!

## Guide

**Before you start adding some awesome things, please make sure to read over all of the code to make sure that you are not adding an existing feature.**

If you didn't find your idea in your code, then let's get started:

- **BY ADDING YOUR CONTRIBUTION TO THIS PROJECT YOU UNDERSTAND THAT YOUR CODE WILL BE PUBLISHED UNDER THE MIT LICENSE (which can be found [here](https://github.com/codehouserblx/antibot/license))

---

### Adding training data

If you are adding training data to make the AI run faster, better, and stronger, please follow these steps:

- Open the folders:

**web -> src -> training-data

- From here, you should see 2 folders. If you are adding training data that counts as a scam, open the **"d-scam.js"** file. If you are adding training data that counts as not scam, open the **"d-notscam.js"** file.
- Add your data in the following format:

```javascript
{
  input: "<your scam message or your not scam message>",
  output: {<scam or notscam>: 1}
},
```
#### Examples:
```javascript
{
  input: "go to bux.gg for free robux!",
  output: {scam: 1}
}
// THIS IS A SCAM MESSAGE, SO IT WOULD GO IN THE **d-scam.js** file
```

```javascript
{
  input: "free robux aren't real!",
  output: {notscam: 1}
}
// THIS IS A NON SCAM MESSAGE, SO IT WOULD GO IN THE **d-notscam.js** file
```
---

Thanks for adding to AntiBot!
