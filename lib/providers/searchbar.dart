import 'package:flutter/cupertino.dart';

class SearchBarFunctions with ChangeNotifier {
  static const historyLength = 3;

  List<String> get searchHistory {
    return [..._searchHistory];
  }

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  late List<String> filteredSearchHistory;

  late String selectedTerm;

  List<String> filterSearchTerms(
    String? filter,
  ) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.where((term) => term.startsWith(filter)).toList();
    } else {
      return _searchHistory.toList();
    }
  }

  void addSearchTerm(String term) {
    //removes duplicates
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.insert(0, term);

    //reduces lenght of search history
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }
}
