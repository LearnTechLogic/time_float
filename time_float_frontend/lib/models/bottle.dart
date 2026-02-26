class Bottle {
  final int id;
  final int userId;
  final String content;
  final String? imageUrl;
  final bool isPicked;
  final int? pickedUserId;
  final DateTime? pickedAt;
  final DateTime createdAt;
  final String? username;
  final String? pickedUsername;

  Bottle({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.isPicked,
    this.pickedUserId,
    this.pickedAt,
    required this.createdAt,
    this.username,
    this.pickedUsername,
  });

  factory Bottle.fromJson(Map<String, dynamic> json) {
    return Bottle(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      isPicked: json['isPicked'],
      pickedUserId: json['pickedUserId'],
      pickedAt: json['pickedAt'] != null ? DateTime.parse(json['pickedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      username: json['username'],
      pickedUsername: json['pickedUsername'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'isPicked': isPicked,
      'pickedUserId': pickedUserId,
      'pickedAt': pickedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'username': username,
      'pickedUsername': pickedUsername,
    };
  }
}
