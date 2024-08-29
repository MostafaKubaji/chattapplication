const mongoose = require('mongoose');

// تعريف مخطط Points الذي يمثل نقطة ثنائية الأبعاد
const pointsSchema = new mongoose.Schema({
    x: { type: Number, required: true, default: 0 }, // إحداثي X مع قيمة افتراضية
    y: { type: Number, required: true, default: 0 }, // إحداثي Y مع قيمة افتراضية
});

// تعريف مخطط FaceFeatures الذي يمثل ملامح الوجه
const faceFeaturesSchema = new mongoose.Schema({
    rightEar: { type: pointsSchema, required: false },    // الأذن اليمنى
    leftEar: { type: pointsSchema, required: false },     // الأذن اليسرى
    rightEye: { type: pointsSchema, required: false },    // العين اليمنى
    leftEye: { type: pointsSchema, required: false },     // العين اليسرى
    rightCheek: { type: pointsSchema, required: false },  // الخد الأيمن
    leftCheek: { type: pointsSchema, required: false },   // الخد الأيسر
    rightMouth: { type: pointsSchema, required: false },  // زاوية الفم اليمنى
    leftMouth: { type: pointsSchema, required: false },   // زاوية الفم اليسرى
    noseBase: { type: pointsSchema, required: false },    // قاعدة الأنف
    bottomMouth: { type: pointsSchema, required: false }, // الجزء السفلي من الفم
});

// تعريف مخطط UserModel الذي يمثل المستخدم
const userSchema = new mongoose.Schema({
    id: { type: String, required: true }, // معرف المستخدم
    name: { type: String, required: true }, // اسم المستخدم
    image: { type: String, required: true }, // صورة المستخدم
    faceFeatures: { type: faceFeaturesSchema, required: true }, // ملامح الوجه
    registeredOn: { type: Date, default: Date.now }, // تاريخ التسجيل
});

// تحويل المخطط إلى نموذج
const UserModel = mongoose.model('User', userSchema);

module.exports = UserModel;
