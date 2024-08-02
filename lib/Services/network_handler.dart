// import 'package:http/http.dart' as http;

// class NetworkHandler {
//   static Future<bool> testConnection() async {
//     try {
//       print("Attempting to connect to the server...");
//       final response = await http.get(
//         Uri.parse("https://chat-server-theta-five.vercel.app/check"),
//       );
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//       if (response.statusCode == 200) {
//         print("Connection successful: ${response.body}");
//         return true;
//       } else {
//         print("Failed to connect: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return false;
//     }
//   }
// }


import 'package:http/http.dart' as http;

class NetworkHandler {
  static Future<bool> testConnection() async {
    try {
      print("Attempting to connect to the server...");
      final response = await http.get(
        Uri.parse("https://chat-server-theta-five.vercel.app/check"),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        print("Connection successful: ${response.body}");
        return true;
      } else {
        print("Failed to connect: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}

