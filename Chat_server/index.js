const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server);

// Middleware
app.use(express.json());

io.on("connection", (socket) => {
    console.log("A client connected: ", socket.id);
    socket.on("signin", (msg) => {
        console.log("Signin message: ", msg); 
    });

    // Handle disconnect event
    socket.on("disconnect", () => {
        console.log("A client disconnected: ", socket.id);
    });
});

server.listen(port, '0.0.0.0', () => {
    console.log("Server started on port ", port);
});
