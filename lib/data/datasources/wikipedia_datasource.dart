import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:petit_bac/core/errors/app_exceptions.dart';

class WikipediaDataSource {
  WikipediaDataSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _host = 'fr.wikipedia.org';

  /// Returns the title of the top Wikipedia search hit, or null if none.
  Future<String?> fetchTopSearchTitle(String searchTerm) async {
    final uri = Uri.https(
      _host,
      '/w/api.php',
      {
        'action': 'query',
        'format': 'json',
        'list': 'search',
        'srsearch': searchTerm,
        'srlimit': '1',
      },
    );

    try {
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw NetworkException(
          'Wikipedia API returned status ${response.statusCode}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final query = data['query'] as Map<String, dynamic>?;
      final searchResults = query?['search'] as List?;

      if (searchResults == null || searchResults.isEmpty) return null;

      return searchResults[0]['title']?.toString();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Wikipedia search failed: $e');
    }
  }
}
