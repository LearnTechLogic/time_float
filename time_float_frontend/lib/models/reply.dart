class Reply {
  final int id;
  final int bottleId;
  final int fromUserId;
  final int toUserId;
  final String content;
  final DateTime createdAt;
  final String? fromUsername;
  final String? toUsername;

  Reply({
    required this.id,
    required this.bottleId,
    required this.fromUserId,
    required this.toUserId,
    required this.content,
    required this.createdAt,
    this.fromUsername,
    this.toUsername,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      bottleId: json['bottleId'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      fromUsername: json['fromUsername'],
      toUsername: json['toUsername'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bottleId': bottleId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'fromUsername': fromUsername,
      'toUsername': toUsername,
    };
  }
}
