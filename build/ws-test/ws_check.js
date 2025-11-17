const key = "6913c1c518443:c18133f0b7a313dd97be99819f2896e6";

const WebSocket = require("ws");
const ws = new WebSocket("wss://eurobeton.katren.org:1338/beton/"+key);
// const ws = new WebSocket("ws://192.168.1.3:1337/beton/68d9fb110fc69:56e0a7d0bc55ef29674d53ab9adf2478");

ws.on("open", () => {
	console.log("Connected");
	const q = '{"func":"Event.subscribe","argv":{"events":[{"id":"Graph.change"},{"id":"VehicleScheduleState.insert"},{"id":"VehicleScheduleState.update"},{"id":"VehicleScheduleState.delete"},{"id":"RAMaterialFact.change"}]}}';

    ws.send(q);
});

// Handle messages from the client (optional)
ws.on('message', message => {
	console.log(`Received message from client: ${message}`);
});

ws.on("close", () => console.log("Closed"));
ws.on("error", (err) => console.error("Error:", err));
