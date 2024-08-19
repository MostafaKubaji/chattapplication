const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const conversationSchema = new Schema({
    participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }], // المشاركون في المحادثة
    messages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Message' }], // الرسائل ضمن المحادثة
    lastMessageAt: { type: Date, default: Date.now }, // توقيت آخر رسالة
});

module.exports = mongoose.model('Conversation', conversationSchema);
