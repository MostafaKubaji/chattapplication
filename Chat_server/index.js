const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const cors = require("cors");
const routes = require("./routes");
const winston = require('winston');

const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const io = socketIo(server);

// إنشاء مثيل من Winston Logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(), // تسجيل السجلات إلى وحدة التحكم
    new winston.transports.File({ filename: 'combined.log' }) // تسجيل السجلات إلى ملف
  ],
});

// Middleware
app.use(cors());
app.use(express.json());
app.use("/api", routes);

const clients = {};

app.route("/clients").get((req, res) => {
  logger.info(`Current clients: ${JSON.stringify(Object.keys(clients))}`);
  return res.json({ clients: Object.keys(clients) });
});

io.on("connection", (socket) => {
  logger.info(`A client connected: ${socket.id}`);
  
  // Handle signin event
  socket.on("signin", (id) => {
    logger.info(`Signin message: ${id}`);
    clients[id] = socket;
    logger.info(`Clients connected: ${Object.keys(clients)}`);
  });
  
  // Handle message event
  socket.on("message", (msg) => {
    logger.info(`Received message: ${JSON.stringify(msg)}`);
    const { targetId, message, sourceId } = msg;
    
    if (clients[targetId]) {
      clients[targetId].emit("message", { message, sourceId });
      logger.info(`Message sent to client ${targetId}`);
    } else {
      logger.warn(`Client with ID ${targetId} not found`);
    }
  });
  
  // Handle disconnect event
  socket.on("disconnect", () => {
    Object.keys(clients).forEach((id) => {
      if (clients[id] === socket) {
        delete clients[id];
        logger.info(`Client with ID ${id} disconnected`);
      }
    });
    logger.info(`A client disconnected: ${socket.id}`);
    logger.info(`Clients connected: ${Object.keys(clients)}`);
  });
});

app.route("/check").get((req, res) => {
  return res.json("Your App is working fine");
});

// Add new endpoint to handle text messages
app.route("/sendmessage").post((req, res) => {
  const { targetId, message, sourceId } = req.body;
  logger.info(`Received message: ${JSON.stringify({ targetId, message, sourceId })}`);
  
  if (clients[targetId]) {
    clients[targetId].emit("message", { message, sourceId });
    return res.json({ status: "Message sent" });
  } else {
    return res.status(404).json({ status: "Client not found" });
  }
});

server.listen(port, "0.0.0.0", () => {
  logger.info(`Server started on port ${port}`);
});

app.route("/clients").get((req, res) => {
  return res.json({ clients: Object.keys(clients) });
});
