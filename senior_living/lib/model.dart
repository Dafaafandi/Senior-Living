class Blog {
  final String userId;
  final String id;
  final String title;

  Blog({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      userId: json['content'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }
}