class AiChatModel {
  final String id;
  final String user;
  final List<Msgs> messages;
  final String title;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  AiChatModel({
    required this.id,
    required this.user,
    required this.messages,
    required this.title,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    return AiChatModel(
      id: json['_id'].toSafeString(),
      user: json['User'].toSafeString(),
      messages: (json['messages'] as List)
          .map((msg) => Msgs.fromJson(msg as Map<String, dynamic>))
          .toList(),
      title: json['title'].toSafeString(),
      isPinned: json['isPinned'] as bool,
      createdAt: DateTime.parse(json['createdAt'].toSafeString()),
      updatedAt: DateTime.parse(json['updatedAt'].toSafeString()),
      version: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'User': user,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'title': title,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}

class Msgs {
  final String type;
  final String content;
  final String id;
  final DateTime timestamp;

  Msgs({
    required this.type,
    required this.content,
    required this.id,
    required this.timestamp,
  });

  factory Msgs.fromJson(Map<String, dynamic> json) {
    return Msgs(
      type: json['type'] as String,
      content: json['content'] as String,
      id: json['_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      '_id': id,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
