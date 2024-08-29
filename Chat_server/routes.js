const express = require("express");
const router = express.Router();
const multer = require("multer");
const UserModel = require('./models/user_model'); // Ensure this path is correct

// Set up multer storage
const storage = multer.diskStorage({
    destination: (req, file, callback) => {
        callback(null, "./uploads");
    },
    filename: (req, file, callback) => {
        callback(null, Date.now() + ".jpg");
    },
});

const upload = multer({
    storage: storage,
});

// Route to add an image
router.post("/addimage", upload.single("img"), (req, res) => {
    try {
        return res.json({ path: req.file.filename });
    } catch (e) {
        return res.json({ error: e });
    }
});

/// مسار لتسجيل مستخدم جديد
 router.post('/register', async (req, res) => {
     const { id, name, image, faceFeatures } = req.body;

     try {
         if (!id || !name || !image || !faceFeatures) {
             return res.status(400).send({ message: 'Missing required fields' });
         }

         const user = new UserModel({ id, name, image, faceFeatures });
         await user.save();
         res.status(201).send({ message: 'Registered successfully' });
     } catch (error) {
         console.error('Error during registration:', error);
         res.status(500).send({ message: 'Registration Failed', error });
     }
 });

 // مسار لجلب جميع المستخدمين
 router.get('/users', async (req, res) => {
   try {
     const users = await UserModel.find(); // جلب جميع المستخدمين من MongoDB
     res.status(200).json(users); // إرسال البيانات إلى العميل (تطبيق Flutter)
   } catch (err) {
     res.status(500).json({ error: 'Error fetching users' });
   }
 });

 module.exports = router;