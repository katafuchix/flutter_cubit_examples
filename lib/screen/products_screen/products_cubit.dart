import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_dart/result_dart.dart';
import 'repository/products_repository.dart';
import 'state/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(this._repository)
      : super(const ProductsState(
          screen: ScreenState.initial(),
          dialog: DialogState.idle(),
        ));

  // 検索実行
  Future<void> fetchProducts() async {
    // 画面（screen）だけをロード中に変更
    emit(state.copyWith(screen: const ScreenState.loading()));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));

    final result = await _repository.getProducts();

    // fold を使う場合（一番安全）
    result.fold(
      (successList) {
        // successList が直接 List<Product> として渡されます
        emit(state.copyWith(screen: ScreenState.success(results: successList)));
      },
      (exception) {
        emit(state.copyWith(
            screen: ScreenState.error(message: exception.toString())));
      },
    );
  }
}
