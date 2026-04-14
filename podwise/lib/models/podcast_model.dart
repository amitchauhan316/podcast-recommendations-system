class Podcast {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String audioUrl;

  final String description;
  final String duration; // e.g. "3h 12m"
  final int durationMinutes;

  final String category;
  final double rating;

  Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.audioUrl,
    this.description = "",
    this.duration = "",
    this.durationMinutes = 0,
    this.category = "",
    this.rating = 0.0,
  });
}