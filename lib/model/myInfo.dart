class MyInfo{
  final String documentId;
  final String name;
  final int sex;
  final int age;
  final String birthDate;
  final int gadScore;
  final int phqScore;
  final List<int> lastMood;
  final int randomGroup;

  MyInfo({
    required this.documentId,
    required this.name,
    required this.sex,
    required this.age,
    required this.birthDate,
    required this.gadScore,
    required this.phqScore,
    required this.lastMood,
    required this.randomGroup,
  });

  factory MyInfo.fromMap(Map<String, dynamic> data) {
    return MyInfo(
      documentId: data['documentId'],
      name: data['name'],
      sex: data['sex'],
      age: data['age'],
      birthDate: data['birthDate'],
      gadScore: data['gadScore'],
      phqScore: data['phqScore'],
      lastMood: data['lastMood'],
      randomGroup: data['randomGroup'],
    );
  }

  Map<String, dynamic> toMap() {
    int weekday = DateTime.now().weekday;
    int weekend = DateTime.now().weekday == 6 || DateTime.now().weekday == 7 ? 1 : 0;
    return {
      'pid': documentId,
      'sex': sex,
      'age': age,
      'gadScore': gadScore,
      'phqScore': phqScore,
      "well1": lastMood[0],
      "well2": lastMood[1],
      "well3": lastMood[2],
      "well4": lastMood[3],
      "well5": lastMood[4],
      "well6": lastMood[5],
      "well7": lastMood[6],
      'weekday': weekday,
      'weekend': weekend,
    };
  }
}