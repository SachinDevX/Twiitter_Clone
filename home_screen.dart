import 'package:flutter/material.dart';
import '../../auth/screens/new_tweet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/tweet/services/tweet_service.dart';
import '../../../features/tweet/models/tweet_model.dart';

class HomeScreen extends StatelessWidget {
  final TweetService _tweetService = TweetService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome To Twitter'),
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _tweetService.getTweets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tweets = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              final tweet = tweets[index];
              final isCurrentUser = tweet.userId == currentUser?.uid;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Text(
                              tweet.userEmail.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  tweet.userEmail,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isCurrentUser)
                                  const Text(' • You',
                                      style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(tweet.text),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComposeTweetPage()),
          );

          if (result != null && result is Map<String, dynamic>) {
            final tweet = Tweet(
              id: DateTime.now().toString(), // This will be replaced by Firestore
              text: result['text'],
              userId: result['userId'],
              userEmail: result['userEmail'],
              timestamp: DateTime.parse(result['timestamp']),
            );
            await _tweetService.createTweet(tweet);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
