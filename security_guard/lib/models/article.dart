class Article {
  final String title;
  final int id;

  final String body1;
  final String body2;

  Article({
    required this.id,
    required this.title,
    required this.body1,
    required this.body2,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      body1: json['body1'],
      body2: json['body2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body1': body1,
      'body2': body2,
    };
  }
}
