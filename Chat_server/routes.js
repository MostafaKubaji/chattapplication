const express = require("express");
const router = express.Router();

const multer = require("multer");

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

router.route("/addimage").post(upload.single("img"), (req, res) => {
  try {
    return res.json({ path: req.file.filename });
  } catch (e) {
    return res.json({ error: e });
  }
});

module.exports = router;
