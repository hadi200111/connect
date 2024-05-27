import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:connect/masseging/ChatProvider.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String currentUserId;

  ChatScreen({
    required this.chatId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Messages>>(
              stream: chatProvider.getChatMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Messages> messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Messages message = messages[index];
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.senderId),
                      trailing: message.senderId == currentUserId
                          ? Icon(Icons.check)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String text = messageController.text.trim();
                    if (text.isNotEmpty) {
                      Messages message = Messages(
                        senderId: currentUserId,
                        text: text,
                        timestamp: Timestamp.now(),
                        id: '2',
                      );
                      chatProvider.sendMessage(chatId, message);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
