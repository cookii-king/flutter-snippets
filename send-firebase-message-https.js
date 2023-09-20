async function generateAccessToken() {
  return new Promise((resolve, reject) => {
    const key = require("./File.json");
    const jwtClient = new google.auth.JWT(
        key.client_email,
        null,
        key.private_key,
        SCOPES,
        null,
    );
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens.access_token);
    });
  });
}

generateAccessToken().then((token) => {
  console.log("Generated Access Token:", token); // Log the token
  const accessToken = token;
  async function sendDirectMessage() {
    const url = `${base}/v1/projects/your-project/messages:send`;
    const payload = {
      message: {
        token: "fcm-token",
        notification: {
          title: "Hello World!",
          body: "This is a test to see if notifications are working...",
          image: null,
        },
        data: {

        },
      },
    };

    const response = await fetch(url, {
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      },
      method: "POST",
      body: JSON.stringify(payload),
    });
    const responseData = await response.json(); // Get the response data
    console.log("Direct Message Response:", responseData); // Log the response data
  }
  sendDirectMessage();
}).catch(console.error);
