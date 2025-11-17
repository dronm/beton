const WebSocket = require("ws");

// const url = "wss://eurobeton.katren.org:1338/beton/68d4bc36359cb%3Aedc312a5e3f60f794ba9032a11b75377"; // adjust path if needed
const url = "ws://192.168.1.3:1337/beton/68d5ba766d80f:18d755d0fcb2130071a58c646cb373be";

const ws = new WebSocket(url, {
  headers: {
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Accept-Language": "ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive, Upgrade",
    "Cookie": "token=68d4bc36359cb%3Aedc312a5e3f60f794ba9032a11b75377; _s=c8mjs7vi7k838dq4n3v95mbevr; eventServerEmitterId=PpzoDzGLtrlaUEHm9AFXL0wTPBd2z9R1",
    "Host": "eurobeton.katren.org:1338",
    "Origin": "https://eurobeton.katren.org",
    "Pragma": "no-cache",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "websocket",
    "Sec-Fetch-Site": "same-site",
    "Sec-WebSocket-Extensions": "permessage-deflate",
    "Sec-WebSocket-Key": "1AqJscxuppbLe1SZd+xjiA==",
    "Sec-WebSocket-Version": "13",
    "Upgrade": "websocket",
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0",
  },
});

ws.on("open", () => console.log("✅ Connected"));
ws.on("close", () => console.log("❌ Closed"));
ws.on("error", (err) => console.error("⚠️ Error:", err));
ws.on("message", (msg) => console.log("📩 Message:", msg.toString()));

