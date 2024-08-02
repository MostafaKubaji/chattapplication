const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const cors = require("cors");
const routes = require("./routes");

const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const io = socketIo(server);

// Middleware
app.use(cors());
app.use(express.json());
app.use("/api", routes);

const clients = {};

io.on("connection", (socket) => {
  console.log("A client connected: ", socket.id);

  // Handle signin event
  socket.on("signin", (id) => {
    console.log("Signin message: ", id);
    clients[id] = socket;
    console.log("Clients connected:", Object.keys(clients));
  });

  // Handle message event
  socket.on("message", (msg) => {
    console.log("Received message:", msg);
    const { targetId, message, sourceId } = msg;

    if (clients[targetId]) {
      clients[targetId].emit("message", { message, sourceId });
      console.log(`Message sent to client ${targetId}`);
    } else {
      console.log(`Client with ID ${targetId} not found`);
    }
  });

  // Handle disconnect event
  socket.on("disconnect", () => {
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
