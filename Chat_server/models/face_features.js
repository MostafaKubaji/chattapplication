const mongoose = require('mongoose');

// Define the schema for the Points model
const PointsSchema = new mongoose.Schema({
  x: {
    type: Number, // X coordinate
    required: true, // Make sure this field is required
    default: 0, // Default value
  },
  y: {
    type: Number, // Y coordinate
    required: true, // Make sure this field is required
    default: 0, // Default value
  },
});

// Define the schema for the FaceFeatures model
const FaceFeaturesSchema = new mongoose.Schema({
  rightEar: { type: PointsSchema },    // right ear point
  leftEar: { type: PointsSchema },     // left ear point
  rightEye: { type: PointsSchema },    // right eye point
  leftEye: { type: PointsSchema },     // left eye point
  rightCheek: { type: PointsSchema },  // right cheek point
  leftCheek: { type: PointsSchema },   // left cheek point
  rightMouth: { type: PointsSchema },  // right mouth corner point
  leftMouth: { type: PointsSchema },   // left mouth corner point
  noseBase: { type: PointsSchema },    // nose base point
  bottomMouth: { type: PointsSchema }, // bottom mouth point
});

// Create Mongoose models
const Points = mongoose.model('Points', PointsSchema);
const FaceFeatures = mongoose.model('FaceFeatures', FaceFeaturesSchema);

// Export the models to use them in other parts of your application
module.exports = { Points, FaceFeatures };
