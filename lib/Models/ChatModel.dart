// import 'package:flutter/material.dart';

// class ChatModel extends ChangeNotifier {
//   List<String> messages = [];
//   final GeminiChatService _chatService = GeminiChatService("your_api_key_here");

//   void addMessage(String message) async {
//     messages.add(message);
//     notifyListeners();
//     try {
//       await _chatService.sendMessage(message,
//           "user_id_here"); // Assuming sendMessage takes these parameters
//     } catch (e) {
//       // Handle error if message could not be sent
//     }
//   }
// }
