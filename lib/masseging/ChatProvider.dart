import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList());
  }

  Stream<List<Messages>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Messages.fromDocument(doc)).toList());
  }

  Future<void> sendMessage(String chatId, Messages message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());

    await _firestore
        .collection('chats')
        .doc(chatId)
        .update({'lastMessageTime': message.timestamp});
  }

  Future<String> createChat(List<String> users) async {
    DocumentReference chatRef = await _firestore.collection('chats').add({
      'users': users,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
    return chatRef.id;
  }
}

class Messages {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;

  Messages(
      {required this.id,
      required this.senderId,
      required this.text,
      required this.timestamp});

  factory Messages.fromDocument(DocumentSnapshot doc) {
    return Messages(
      id: doc.id,
      senderId: doc['senderId'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

class Chat {
  final String id;
  final List<String> users;
  final Timestamp lastMessageTime;

  Chat({required this.id, required this.users, required this.lastMessageTime});

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      users: List<String>.from(doc['users']),
      lastMessageTime: doc['lastMessageTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'lastMessageTime': lastMessageTime,
    };
  }
}
