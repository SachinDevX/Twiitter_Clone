import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tweet_model.dart';

class TweetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTweet(Tweet tweet) async {
    await _firestore.collection('tweets').add(tweet.toJson());
  }

  Stream<List<Tweet>> getTweets() {
    return _firestore
        .collection('tweets')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Tweet.fromJson(data);
      }).toList();
    });
  }
} 
