 class Tweet {
  final String id;
  final String text;
  final String userId;
  final String userEmail;
  final DateTime timestamp;

  Tweet({
    required this.id,
    required this.text,
    required this.userId,
    required this.userEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'userEmail': userEmail,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      userId: json['userId'] ?? '',
      userEmail: json['userEmail'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
} 
