class Chat {
  final String documentId;
  final String message;
  final bool isSender;
  final DateTime createdAt;

  Chat({
    required this.documentId,
    required this.message,
    required this.isSender,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      documentId: json['documentId'],
      message: json['message'],
      isSender: json['isSender'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'message': message,
      'isSender': isSender,
      'createdAt': createdAt,
    };
  }
}