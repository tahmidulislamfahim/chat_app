import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required ScrollController scrollController,
    required this.chatDocs,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<QueryDocumentSnapshot<Object?>> chatDocs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: chatDocs.length,
      reverse: true,
      itemBuilder: (context, index) {
        // Because we ordered by createdAt ascending, index 0 is the oldest.
        final message = chatDocs[index];
        final isMe =
            message['userId'] == FirebaseAuth.instance.currentUser!.uid;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message['text'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      child: Text(message['username'][0].toUpperCase()),
                    ),
                    SizedBox(width: 6),
                    Text(
                      message['username'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    SizedBox(width: 6),
                    Text(
                      (message['createdAt'] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                          .substring(11, 16),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
