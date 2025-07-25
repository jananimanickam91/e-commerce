class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final Set<int> _favoriteIds = <int>{};
  final List<Function()> _listeners = [];

  Set<int> get favoriteIds => Set.from(_favoriteIds);

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    _notifyListeners();
  }

  void addToFavorites(int productId) {
    _favoriteIds.add(productId);
    _notifyListeners();
  }

  void removeFromFavorites(int productId) {
    _favoriteIds.remove(productId);
    _notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    _notifyListeners();
  }

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}
