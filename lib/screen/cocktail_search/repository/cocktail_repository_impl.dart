import 'package:dio/dio.dart';
import 'package:flutter_cubit_examples/screen/cocktail_search/model/drink.dart';
import 'package:flutter_cubit_examples/screen/cocktail_search/model/search_result.dart';

import '../model/search_result_error.dart';
import 'cocktail_repository.dart';

class CocktailRepositoryImpl implements CocktailRepository {
  final Dio _dio;

  CocktailRepositoryImpl(this._dio);

  @override
  Future<List<Drink>> searchCocktail({required String searchWord}) async {
    final keyword = Uri.encodeComponent(searchWord);

    final url =
        "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$keyword";

    final response = await _dio.get(url, options: Options(headers: {}));

    if (response.statusCode != 200) throw Exception('HTTP Error');

    // 1. Dioの場合、response.data は既に Map になっていることが多いです
    // 2. もし response.data が String なら decode が必要ですが、通常はそのままキャストできます
    final data = response.data;

    /*
    if (response.statusCode == 200) {
      return SearchResult.fromJson(data).drinks;
    } else {
      throw SearchResultError.fromJson(data);
    }*/

    if (data is Map<String, dynamic>) {
      return SearchResult.fromJson(data).drinks;
    } else {
      throw SearchResultError.fromJson(data);
    }
  }
}
