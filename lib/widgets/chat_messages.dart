import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();
  // bool _didJumpToBottom = false;
  // String? _lastMessageId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _maybeJumpToBottomAfterFrame(List<QueryDocumentSnapshot> docs) {
  //   // Only jump the first time data arrives or when new messages are appended at
  //   // the end. We guard with _didJumpToBottom so we don't keep forcing scroll
  //   // on user interaction.
  //   // Only jump if new messages have arrived (i.e., the last doc has changed).
  //   if (docs.isNotEmpty) {
  //     final lastId = docs.last.id;
  //     if (_lastMessageId != lastId) {
  //       _didJumpToBottom = false;
  //       _lastMessageId = lastId;
  //     }
  //   }
  //   if (_didJumpToBottom) return;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     if (_scrollController.hasClients) {
  //       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //     }
  //     _didJumpToBottom = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet!'));
        }
        if (snapshot.hasError) {
          return Center(child: Text('An error occurred!'));
        }

        final chatDocs = snapshot.data!.docs;

        // Ensure we scroll to bottom when data first appears.

        //_maybeJumpToBottomAfterFrame(chatDocs);

        return MessageBubble(
          scrollController: _scrollController,
          chatDocs: chatDocs,
        );
      },
    );
  }
}
