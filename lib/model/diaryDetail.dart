class DiaryDetail{
  final String documentId;
  final String title;
  final String content;
  final DateTime createDate;
  final int score;

  DiaryDetail({
    required this.documentId,
    required this.title,
    required this.content,
    required this.createDate,
    required this.score,
  });

  factory DiaryDetail.fromMap(Map<String, dynamic> map, String documentId) {
    return DiaryDetail(
      documentId: documentId,
      title: map['title'],
      content: map['content'],
      createDate: map['createDate'],
      score: map['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createDate': createDate,
      'score': score,
    };
  }

}