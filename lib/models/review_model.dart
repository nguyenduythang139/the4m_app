class Review {
  final String title;
  final String date;
  final int rating;
  final String size;
  final String color;
  final String content;
  final String userName;
  final String avatarUrl;

  Review({
    required this.title,
    required this.date,
    required this.rating,
    required this.size,
    required this.color,
    required this.content,
    required this.userName,
    required this.avatarUrl,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      rating: data['rating'] ?? 0,
      size: data['size'] ?? '',
      color: data['color'] ?? '',
      content: data['content'] ?? '',
      userName: data['userName'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }
}
