const mongoose = require("mongoose");
const express = require("express");
const http = require("http");
const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const io = require("socket.io")(server);
const cors = require("cors");
const bodyParser = require("body-parser");
const routes = require('./routes');

// Models
const Message = require('./models/Message');
const Conversation = require('./models/Conversation');

// Middleware
app.use(cors());
app.use(bodyParser.json({ limit: '10mb' }));
app.use(express.json());

// Connect to MongoDB
mongoose.connect("mongodb://localhost:27017/chat_DB", { // استخدم عنوان الـ MongoDB المناسب
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
    .then(() => console.log("Connected to MongoDB"))
    .catch((err) => console.error("Could not connect to MongoDB", err));

// Socket.io setup
const clients = {}; // Store connected clients

io.on("connection", (socket) => {
    console.log("-"*100)
    console.log("A client connected: ", socket);
    console.log("-"*100)

    socket.on("signin", (id) => {
        console.log({
            id:id,
            socket:socket
        })
        // console.log({id:id,clients:clients});
        clients[socket.handshake.query.id] = socket;
        console.log("Clients connected:", Object.keys( clients));
    });
    socket.on("message", async (msg) => {
        
        console.log("Received message:", msg);
        const { targetId, message, sourceId, isImage,isFile } = msg;

        try {
            // const sourceObjectId = new mongoose.Types.ObjectId(sourceId);
            // const targetObjectId = new mongoose.Types.ObjectId(targetId);

            // let conversation = await Conversation.findOne({
            //     participants: { $all: [sourceObjectId, targetObjectId] }
            // });

            // if (!conversation) {
            //     conversation = new Conversation({
            //         participants: [sourceObjectId, targetObjectId],
            //         messages: [],
            //     });
            // }

            const newMessage = new Message({
                sourceId: sourceId,
                targetId: targetId,
                message,
                isImage,
                isFile,
            });

            await newMessage.save();

            // conversation.messages.push(newMessage._id);
            // conversation.lastMessageAt = new Date();
            // await conversation.save();

            console.log("Message saved:", message);

            if (clients[targetId]) {
                clients[targetId].emit("message", {
                    _id: newMessage._id,
                    message: newMessage.message,
                    sourceId: newMessage.sourceId,
                    isImage: newMessage.isImage,
                    isFile: newMessage.isFile,
                    createdAt: newMessage.createdAt
                });
                console.log(`Message sent to user ${targetId} with socket ID: ${clients[targetId].id}`);
            } else {
                console.log(`Target client ${targetId} is not connected.`);
            }
        } catch (error) {
            console.error("Error handling message:", error);
        }
    });

    socket.on("disconnect", () => {
        for (const id in clients) {
            if (clients[id] === socket) {
                delete clients[id];
                console.log(`Client with ID ${id} disconnected`);
                break;
            }
        }
        console.log("A client disconnected:", socket.id);
    });
});

// Use routes
app.use('/', routes);

// Start the server
server.listen(port, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${port}`);
});
