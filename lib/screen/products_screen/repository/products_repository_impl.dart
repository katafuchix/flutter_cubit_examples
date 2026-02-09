import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import '../model/product.dart';
import 'products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      List<Product> products = [];

      final res = await _dio.get('https://fakestoreapi.com/products');
      final mapProducts = List.of(res.data);
      mapProducts.map((e) => products.add(Product.fromJson(e))).toList();

      return products.toSuccess();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }
}
