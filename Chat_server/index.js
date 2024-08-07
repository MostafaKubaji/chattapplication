const express = require("express");
const http = require("http");
const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const io = require("socket.io")(server);
const routes = require("./routes");

// Middleware
app.use(express.json());
app.use("/routes", routes); // استخدم مسار مناسب مثل /api بدلاً من /routes.js

const clients = {}; // Store connected clients

io.on("connection", (socket) => {
  console.log("A client connected: ", socket.id);

  // Handle signin event
  socket.on("signin", (id) => {
    console.log("Signin message: ", id);
    // Register client by their unique id
    clients[id] = socket;
    console.log("Clients connected:", Object.keys(clients));
  });

  // Handle message event
  socket.on("message", (msg) => {
    console.log("Received message:", msg);
    const { targetId, message, sourceId } = msg; // Changed targetID to targetId

    if (clients[targetId]) {
      // Send message to the target client
      clients[targetId].emit("message", { message, sourceId });
      
    } else {
      console.log(`Client with ID ${targetId} not found`);
    }
  });

  // Handle disconnect event
  socket.on("disconnect", () => {
    // Remove client from the clients list
    Object.keys(clients).forEach((id) => {
      if (clients[id] === socket) {
        delete clients[id];
        console.log(`Client with ID ${id} disconnected`);
      }
    });
    console.log("A client disconnected: ", socket.id);
    console.log("Clients connected:", Object.keys(clients));
  });
});

app.route("/check").get((req, res) => {
  return res.json("Your App is working fine");
});

server.listen(port, "0.0.0.0", () => {
  console.log("Server started on port ", port);
});
