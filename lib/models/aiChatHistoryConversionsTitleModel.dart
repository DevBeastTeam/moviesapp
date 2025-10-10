class AiChatHistoryConversionsTitleModel {
  final List<Chat> chats;
  final String userName;

  AiChatHistoryConversionsTitleModel({
    required this.chats,
    required this.userName,
  });

  factory AiChatHistoryConversionsTitleModel.fromJson(Map<String, dynamic> json) {
    return AiChatHistoryConversionsTitleModel(
      chats: (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
      userName: json['userName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((e) => e.toJson()).toList(),
      'userName': userName,
    };
  }
}

class Chat {
  final String id;
  final String user;
  final List<Message> messages;
  final String title;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Chat({
    required this.id,
    required this.user,
    required this.messages,
    required this.title,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] as String? ?? json['id'] as String,
      user: json['User'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      isPinned: json['isPinned'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'User': user,
      'messages': messages.map((e) => e.toJson()).toList(),
      'title': title,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'id': id,
    };
  }
}

class Message {
  final String type;
  final String content;
  final String id;
  final DateTime timestamp;

  Message({
    required this.type,
    required this.content,
    required this.id,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
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