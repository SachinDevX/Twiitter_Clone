import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComposeTweetPage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  ComposeTweetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tweetController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Tweet'),
        actions: [
          TextButton(
            onPressed: () {
              String tweetText = tweetController.text.trim();
              if (tweetText.isNotEmpty) {
                final tweet = {
                  'text': tweetText,
                  'userId': currentUser?.uid,
                  'userEmail': currentUser?.email,
                  'timestamp': DateTime.now().toIso8601String(),
                };
                Navigator.pop(context, tweet);
              }
            },
            child: const Text(
              'Tweet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Text(
                    currentUser?.email?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  currentUser?.email ?? 'Anonymous',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tweetController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
