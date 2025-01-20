class Author {
  final String name;
  final bool isVerified;
  final String firstName;
  final String lastName;
  final String imageURL;

  Author({
    required this.name,
    required this.isVerified,
    required this.firstName,
    required this.lastName,
    required this.imageURL,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      isVerified: json['isVerified'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageURL: json['imageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isVerified': isVerified,
      'firstName': firstName,
      'lastName': lastName,
      'imageURL': imageURL,
    };
  }
}