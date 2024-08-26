const mongoose = require("mongoose");
const express = require("express");
const http = require("http");
const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const io = require("socket.io")(server);
const Message = require('./models/Message');
const cors = require('cors');
const Conversation = require('./models/Conversation');

// الاتصال بقاعدة البيانات
mongoose.connect("mongodb://192.168.84.119:27017/mydb", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
    .then(() => console.log("Connected to MongoDB"))
    .catch((err) => console.error("Could not connect to MongoDB", err));

// Middleware
app.use(express.json());
app.use(cors());

const clients = {}; // تخزين العملاء المتصلين

io.on("connection", (socket) => {
    console.log("A client connected: ", socket.id);

    // استقبال حدث تسجيل الدخول وتخزين الـ socket الخاص بالمستخدم
    socket.on("signin", (id) => {
        clients[id] = socket;
        console.log("Clients connected:", Object.keys(clients));
    });

    // استقبال حدث إرسال رسالة
    socket.on("message", async (msg) => {
        console.log("Received message:", msg);
        const { targetId, message, sourceId, isImage } = msg;

        try {
            // تحويل sourceId و targetId إلى ObjectId بشكل صحيح
            const sourceObjectId = new mongoose.Types.ObjectId(sourceId);
            const targetObjectId = new mongoose.Types.ObjectId(targetId);

            // البحث عن المحادثة الموجودة بين المستخدمين
            let conversation = await Conversation.findOne({
                participants: { $all: [sourceObjectId, targetObjectId] }
            });

            // إنشاء محادثة جديدة إذا لم تكن موجودة
            if (!conversation) {
                conversation = new Conversation({
                    participants: [sourceObjectId, targetObjectId],
                    messages: [],
                });
            }

            // إنشاء الرسالة الجديدة
            const newMessage = new Message({
                sourceId: sourceObjectId,
                targetId: targetObjectId,
                message,
                isImage,
            });

            // حفظ الرسالة في قاعدة البيانات
            await newMessage.save();

            // إضافة الرسالة إلى المحادثة وتحديث تاريخ آخر رسالة
            conversation.messages.push(newMessage._id);
            conversation.lastMessageAt = new Date();
            await conversation.save();

            console.log("Message saved:", message);

            // إرسال الرسالة إلى المستخدم المستهدف إذا كان متصلاً
            if (clients[targetId]) {
                clients[targetId].emit("message", {
                    _id: newMessage._id, // أضف المعرف الجديد للرسالة
                    message: newMessage.message,
                    sourceId: newMessage.sourceId,
                    isImage: newMessage.isImage,
                    createdAt: newMessage.createdAt // أضف تاريخ الإنشاء إذا كان مطلوبًا
                });
                console.log(`Message sent to user ${targetId} with socket ID: ${clients[targetId].id}`);
            } else {
                console.log(`Target client ${targetId} is not connected.`);
            }
        } catch (error) {
            console.error("Error handling message:", error);
        }
    });

    // استقبال حدث انقطاع الاتصال
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

server.listen(port, "0.0.0.0", () => {
    console.log("Server started on port", port);
});