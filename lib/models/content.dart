class Content {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String? backdropUrl;
  final String videoUrl;
  final String trailerUrl;
  final ContentType type;
  final String genre;
  final List<String> languages;
  final List<String> subtitles;
  final int duration; // in minutes
  final double rating;
  final int ratingCount;
  final DateTime releaseDate;
  final DateTime createdAt;
  final bool isPremium;
  final bool isFeatured;
  final bool isNewRelease;
  final List<String> cast;
  final List<String> directors;
  final String? ageRating;
  final String? quality;
  final Map<String, String> videoQualities; // quality -> url mapping
  final int viewCount;
  final int likeCount;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.backdropUrl,
    required this.videoUrl,
    required this.trailerUrl,
    required this.type,
    required this.genre,
    required this.languages,
    required this.subtitles,
    required this.duration,
    required this.rating,
    required this.ratingCount,
    required this.releaseDate,
    required this.createdAt,
    this.isPremium = false,
    this.isFeatured = false,
    this.isNewRelease = false,
    required this.cast,
    required this.directors,
    this.ageRating,
    this.quality,
    required this.videoQualities,
    this.viewCount = 0,
    this.likeCount = 0,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      backdropUrl: json['backdrop_url'],
      videoUrl: json['video_url'] ?? '',
      trailerUrl: json['trailer_url'] ?? '',
      type: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ContentType.movie,
      ),
      genre: json['genre'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      subtitles: List<String>.from(json['subtitles'] ?? []),
      duration: json['duration'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      releaseDate: DateTime.parse(json['release_date'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isPremium: json['is_premium'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      isNewRelease: json['is_new_release'] ?? false,
      cast: List<String>.from(json['cast'] ?? []),
      directors: List<String>.from(json['directors'] ?? []),
      ageRating: json['age_rating'],
      quality: json['quality'],
      videoQualities: Map<String, String>.from(json['video_qualities'] ?? {}),
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'poster_url': posterUrl,
      'backdrop_url': backdropUrl,
      'video_url': videoUrl,
      'trailer_url': trailerUrl,
      'type': type.toString().split('.').last,
      'genre': genre,
      'languages': languages,
      'subtitles': subtitles,
      'duration': duration,
      'rating': rating,
      'rating_count': ratingCount,
      'release_date': releaseDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_premium': isPremium,
      'is_featured': isFeatured,
      'is_new_release': isNewRelease,
      'cast': cast,
      'directors': directors,
      'age_rating': ageRating,
      'quality': quality,
      'video_qualities': videoQualities,
      'view_count': viewCount,
      'like_count': likeCount,
    };
  }

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedRating {
    return rating.toStringAsFixed(1);
  }

  bool get isMovie => type == ContentType.movie;
  bool get isSeries => type == ContentType.series;
  bool get isDocumentary => type == ContentType.documentary;
}

enum ContentType {
  movie,
  series,
  documentary,
  shortFilm,
  webSeries,
  musicVideo
}