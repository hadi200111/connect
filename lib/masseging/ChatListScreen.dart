import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/masseging/ChatProvider.dart';
import 'package:connect/masseging/ChatScreen.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  ChatListScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: chatProvider.getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          List<Chat> chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              Chat chat = chats[index];
              String chatPartner =
                  chat.users.firstWhere((user) => user != currentUserId);
              return ListTile(
                title: Text(chatPartner), // Display the chat partner
                subtitle:
                    Text('Last message at ${chat.lastMessageTime.toDate()}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chat.id, // Pass the chatId to the ChatScreen
                        currentUserId: currentUserId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
