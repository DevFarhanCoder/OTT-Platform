import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/content_service.dart';

class ContentProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();
  
  List<Content> _featuredContent = [];
  List<Content> _newReleases = [];
  List<Content> _trendingContent = [];
  List<Content> _allContent = [];
  List<Content> _watchlist = [];
  List<Content> _watchHistory = [];
  List<Content> _searchResults = [];
  
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  Content? _selectedContent;

  // Getters
  List<Content> get featuredContent => _featuredContent;
  List<Content> get newReleases => _newReleases;
  List<Content> get trendingContent => _trendingContent;
  List<Content> get allContent => _allContent;
  List<Content> get watchlist => _watchlist;
  List<Content> get watchHistory => _watchHistory;
  List<Content> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  Content? get selectedContent => _selectedContent;

  Future<void> loadFeaturedContent() async {
    _setLoading(true);
    _clearError();
    
    try {
      _featuredContent = await _contentService.getFeaturedContent();
    } catch (e) {
      _setError('Failed to load featured content: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> loadNewReleases() async {
    _setLoading(true);
    _clearError();
    
    try {
      _newReleases = await _contentService.getNewReleases();
    } catch (e) {
      _setError('Failed to load new releases: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> loadTrendingContent() async {
    _setLoading(true);
    _clearError();
    
    try {
      _trendingContent = await _contentService.getTrendingContent();
    } catch (e) {
      _setError('Failed to load trending content: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> loadAllContent({String? genre, ContentType? type}) async {
    _setLoading(true);
    _clearError();
    
    try {
      _allContent = await _contentService.getAllContent(genre: genre, type: type);
    } catch (e) {
      _setError('Failed to load content: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> searchContent(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _clearError();
    notifyListeners();
    
    try {
      _searchResults = await _contentService.searchContent(query);
    } catch (e) {
      _setError('Search failed: ${e.toString()}');
    }
    
    _isSearching = false;
    notifyListeners();
  }

  Future<void> loadContentById(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      _selectedContent = await _contentService.getContentById(id);
    } catch (e) {
      _setError('Failed to load content: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> addToWatchlist(Content content) async {
    try {
      final success = await _contentService.addToWatchlist(content.id);
      if (success && !_watchlist.contains(content)) {
        _watchlist.add(content);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to add to watchlist: ${e.toString()}');
    }
  }

  Future<void> removeFromWatchlist(Content content) async {
    try {
      final success = await _contentService.removeFromWatchlist(content.id);
      if (success) {
        _watchlist.removeWhere((item) => item.id == content.id);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to remove from watchlist: ${e.toString()}');
    }
  }

  Future<void> loadWatchlist() async {
    _setLoading(true);
    _clearError();
    
    try {
      _watchlist = await _contentService.getWatchlist();
    } catch (e) {
      _setError('Failed to load watchlist: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> addToHistory(Content content) async {
    try {
      await _contentService.addToHistory(content.id);
      if (!_watchHistory.any((item) => item.id == content.id)) {
        _watchHistory.insert(0, content);
        // Keep only last 50 items
        if (_watchHistory.length > 50) {
          _watchHistory = _watchHistory.take(50).toList();
        }
        notifyListeners();
      }
    } catch (e) {
      // Silent fail for history
    }
  }

  Future<void> loadWatchHistory() async {
    try {
      _watchHistory = await _contentService.getWatchHistory();
      notifyListeners();
    } catch (e) {
      // Silent fail for history
    }
  }

  List<Content> getContentByGenre(String genre) {
    return _allContent.where((content) => 
        content.genre.toLowerCase().contains(genre.toLowerCase())).toList();
  }

  List<Content> getContentByType(ContentType type) {
    return _allContent.where((content) => content.type == type).toList();
  }

  List<String> getAvailableGenres() {
    final genres = <String>{};
    for (final content in _allContent) {
      genres.add(content.genre);
    }
    return genres.toList()..sort();
  }

  bool isInWatchlist(Content content) {
    return _watchlist.any((item) => item.id == content.id);
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}