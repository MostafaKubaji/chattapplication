const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const messageSchema = new Schema({
    sourceId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // مرسل الرسالة
    targetId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // مستقبل الرسالة
    message: { type: String, required: true }, // محتوى الرسالة
    isImage: { type: Boolean, default: false }, // تحديد ما إذا كانت الرسالة صورة
    createdAt: { type: Date, default: Date.now }, // وقت إرسال الرسالة
});

module.exports = mongoose.model('Message', messageSchema);
