import 'package:edutainment/helpers/forstrings.dart';

class AiChatModel {
  final String id;
  final String timestamp;
  final String content;
  final String title;
  final bool isPinned;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String userName;

  AiChatModel({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.title,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.userName,
  });

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    return AiChatModel(
      id: json['_id'].toString().toNullString(),
      timestamp: json['timestamp'].toString().toNullString(),
      content: json['content'].toString().toNullString(),
      title: json['title'].toString().toNullString(),
      isPinned: json['isPinned'].toString().toNullString() == true,
      createdAt: json['createdAt'].toString().toNullString(),
      updatedAt: json['updatedAt'].toString().toNullString(),
      version: json['__v'],
      userName: json['userName'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'timestamp': timestamp,
      'content': content,
      'title': title,
      'isPinned': isPinned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'userName': userName,
    };
  }
}



// {
//   "_id": "685e569b2b9e816f85909b0b",
//   "timestamp": "2025-06-27T08:30:19.470Z",
//   "content": "* Some viewers might find the pacing and tone of the movie too intense or emotional, particularly in its depiction of war atrocities.\n\nIf you do decide to watch \"1917,\" here are a few tips:\n\n1. Be prepared for a challenging viewing experience: The film's non-linear structure and limited dialogue may require some patience and attention.\n2. Take breaks if needed: If you find it difficult to follow the story, take a break from the movie or come back to it later when you're feeling more focused.\n3. Pay attention to cultural references: \"1917\" is deeply rooted in British culture and history, so be sure to pay attention to these references to fully appreciate the film.\n\nUltimately, whether or not you should watch \"1917\" to progress in English depends on your individual interests and language skills. If you're interested in learning more about World War I or are a fan of innovative filmmaking techniques, you might find this movie to be a rewarding experience. However, if you're short on time or prefer more straightforward storytelling, you may want to consider other options.",
//   "title": "give me some in...",
//   "isPinned": false,
//   "createdAt": "2025-06-27T08:29:59.270Z",
//   "updatedAt": "2025-06-27T08:30:19.471Z",
//   "__v": 1,
//   "id": "685e5687e5321f58458a7404",
//   "userName": "Tom"
// }