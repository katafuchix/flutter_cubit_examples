import 'package:result_dart/result_dart.dart';

import '../model/product.dart';

abstract class ProductsRepository {
  Future<Result<List<Product>>> getProducts();
}
