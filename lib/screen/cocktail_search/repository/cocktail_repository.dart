
import '../model/drink.dart';

abstract class CocktailRepository {
  Future<List<Drink>> searchCocktail(
      {required String searchWord,});
}
