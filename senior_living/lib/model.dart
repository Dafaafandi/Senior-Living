class Blog {
  final int id;
  final String title;
  final String email;

  Blog({
    required this.id,
    required this.title,
    required this.email,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      title: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
    );
  }
}
