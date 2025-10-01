import '../models/content.dart';

class ContentService {
  static const String _baseUrl = 'https://api.emmarott.com';

  // Mock data for demonstration
  final List<Content> _mockContent = [
    Content(
      id: '1',
      title: 'The Epic Adventure',
      description: 'An epic journey through mystical lands filled with adventure, magic, and unforgettable characters.',
      posterUrl: 'https://picsum.photos/300/450?random=1',
      backdropUrl: 'https://picsum.photos/800/450?random=1',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      type: ContentType.movie,
      genre: 'Adventure',
      languages: ['English', 'Hindi', 'Spanish'],
      subtitles: ['English', 'Hindi', 'Spanish', 'French'],
      duration: 142,
      rating: 8.5,
      ratingCount: 1250,
      releaseDate: DateTime(2024, 1, 15),
      createdAt: DateTime.now(),
      isPremium: true,
      isFeatured: true,
      isNewRelease: true,
      cast: ['John Doe', 'Jane Smith', 'Bob Johnson'],
      directors: ['Christopher Director'],
      ageRating: 'PG-13',
      quality: '4K UHD',
      videoQualities: {
        '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        '4K': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      },
      viewCount: 125000,
      likeCount: 9500,
    ),
    Content(
      id: '2',
      title: 'Bollywood Dreams',
      description: 'A heartwarming story of dreams, love, and the pursuit of happiness in the world of Bollywood.',
      posterUrl: 'https://picsum.photos/300/450?random=2',
      backdropUrl: 'https://picsum.photos/800/450?random=2',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      type: ContentType.movie,
      genre: 'Drama',
      languages: ['Hindi', 'English'],
      subtitles: ['English', 'Hindi', 'Urdu'],
      duration: 168,
      rating: 7.8,
      ratingCount: 890,
      releaseDate: DateTime(2023, 12, 20),
      createdAt: DateTime.now(),
      isPremium: false,
      isFeatured: true,
      isNewRelease: false,
      cast: ['Raj Kumar', 'Priya Sharma', 'Amit Singh'],
      directors: ['Bollywood Director'],
      ageRating: 'U',
      quality: 'HD',
      videoQualities: {
        '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      },
      viewCount: 78000,
      likeCount: 6200,
    ),
    Content(
      id: '3',
      title: 'Music Legends',
      description: 'A documentary series exploring the lives and careers of legendary musicians who shaped the industry.',
      posterUrl: 'https://picsum.photos/300/450?random=3',
      backdropUrl: 'https://picsum.photos/800/450?random=3',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      type: ContentType.documentary,
      genre: 'Music',
      languages: ['English'],
      subtitles: ['English', 'Spanish', 'French'],
      duration: 95,
      rating: 9.2,
      ratingCount: 2100,
      releaseDate: DateTime(2024, 2, 10),
      createdAt: DateTime.now(),
      isPremium: true,
      isFeatured: false,
      isNewRelease: true,
      cast: ['Various Artists'],
      directors: ['Documentary Team'],
      ageRating: 'U',
      quality: '4K UHD',
      videoQualities: {
        '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        '4K': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      },
      viewCount: 45000,
      likeCount: 4100,
    ),
    Content(
      id: '4',
      title: 'Comedy Central',
      description: 'A hilarious comedy special featuring the best stand-up comedians from around the world.',
      posterUrl: 'https://picsum.photos/300/450?random=4',
      backdropUrl: 'https://picsum.photos/800/450?random=4',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      type: ContentType.movie,
      genre: 'Comedy',
      languages: ['English', 'Hindi'],
      subtitles: ['English', 'Hindi'],
      duration: 75,
      rating: 6.9,
      ratingCount: 456,
      releaseDate: DateTime(2024, 3, 5),
      createdAt: DateTime.now(),
      isPremium: false,
      isFeatured: false,
      isNewRelease: true,
      cast: ['Comedy Stars'],
      directors: ['Comedy Director'],
      ageRating: 'A',
      quality: 'HD',
      videoQualities: {
        '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      },
      viewCount: 23000,
      likeCount: 1800,
    ),
    Content(
      id: '5',
      title: 'Sci-Fi Chronicles',
      description: 'A futuristic series exploring the possibilities of technology and space exploration.',
      posterUrl: 'https://picsum.photos/300/450?random=5',
      backdropUrl: 'https://picsum.photos/800/450?random=5',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      type: ContentType.series,
      genre: 'Sci-Fi',
      languages: ['English'],
      subtitles: ['English', 'Spanish', 'German'],
      duration: 45,
      rating: 8.7,
      ratingCount: 1780,
      releaseDate: DateTime(2023, 11, 18),
      createdAt: DateTime.now(),
      isPremium: true,
      isFeatured: true,
      isNewRelease: false,
      cast: ['Future Stars'],
      directors: ['Sci-Fi Director'],
      ageRating: 'PG-13',
      quality: '4K UHD',
      videoQualities: {
        '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        '4K': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      },
      viewCount: 89000,
      likeCount: 7650,
    ),
  ];

  Future<List<Content>> getFeaturedContent() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContent.where((content) => content.isFeatured).toList();
  }

  Future<List<Content>> getNewReleases() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockContent.where((content) => content.isNewRelease).toList();
  }

  Future<List<Content>> getTrendingContent() async {
    await Future.delayed(const Duration(seconds: 1));
    final trending = List<Content>.from(_mockContent);
    trending.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return trending.take(10).toList();
  }

  Future<List<Content>> getAllContent({String? genre, ContentType? type}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    var content = List<Content>.from(_mockContent);
    
    if (genre != null && genre.isNotEmpty) {
      content = content.where((c) => 
          c.genre.toLowerCase().contains(genre.toLowerCase())).toList();
    }
    
    if (type != null) {
      content = content.where((c) => c.type == type).toList();
    }
    
    return content;
  }

  Future<List<Content>> searchContent(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _mockContent.where((content) =>
        content.title.toLowerCase().contains(lowerQuery) ||
        content.description.toLowerCase().contains(lowerQuery) ||
        content.genre.toLowerCase().contains(lowerQuery) ||
        content.cast.any((actor) => actor.toLowerCase().contains(lowerQuery)) ||
        content.directors.any((director) => director.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  Future<Content?> getContentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mockContent.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addToWatchlist(String contentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success
    return true;
  }

  Future<bool> removeFromWatchlist(String contentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success
    return true;
  }

  Future<List<Content>> getWatchlist() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock watchlist with first 2 items
    return _mockContent.take(2).toList();
  }

  Future<bool> addToHistory(String contentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock success
    return true;
  }

  Future<List<Content>> getWatchHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock history with last 3 items
    return _mockContent.take(3).toList();
  }

  Future<bool> rateContent(String contentId, double rating) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success
    return true;
  }

  Future<bool> likeContent(String contentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success
    return true;
  }

  Future<bool> unlikeContent(String contentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success
    return true;
  }
}