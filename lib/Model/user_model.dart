
import 'face_features.dart';

class UserModel {
  String? id;
  String? name;
  String? image;
  FaceFeatures? faceFeatures;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.faceFeatures,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(

      id: json['id'],
      name: json['name'],
      image: json['image'],
      faceFeatures: FaceFeatures.fromJson(json["faceFeatures"]),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'faceFeatures': faceFeatures?.toJson() ?? {},

    };
  }
}
