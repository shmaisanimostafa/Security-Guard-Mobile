class Article {
  final String title;
  // final String description;
  final String body1;
  final String body2;
  // final String url;
  // final String urlToImage;
  // final String publishedAt;

  Article({required this.title, required this.body1, required this.body2});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      body1: json['body1'],
      body2: json['body2'],
      // urlToImage: json['urlToImage'],
      // publishedAt: json['publishedAt']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body1': body1,
      'body2': body2,
      // 'urlToImage': urlToImage,
      // 'publishedAt': publishedAt
    };
  }
}
