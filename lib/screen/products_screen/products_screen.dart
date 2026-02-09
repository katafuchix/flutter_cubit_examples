import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'model/product.dart';
import 'products_cubit.dart';
import 'repository/products_repository_impl.dart';
import 'state/products_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductsCubit(ProductsRepositoryImpl(Dio()))..fetchProducts(),
      child: const ProductsSearchPage(),
    );
  }
}

class ProductsSearchPage extends StatefulWidget {
  const ProductsSearchPage({super.key});

  @override
  State<ProductsSearchPage> createState() => ProductsSearchPageState();
}

class ProductsSearchPageState extends State<ProductsSearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: context.read<ProductsCubit>().fetchProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listenWhen: (previous, current) => previous.screen != current.screen,
        listener: (context, state) {
          // ローディング制御
          final isScreenLoading = state.screen is ScreenLoading;

          if (isScreenLoading) {
            SmartDialog.showLoading(msg: '検索中...');
          } else {
            SmartDialog.dismiss();
          }

          // 検索エラー処理
          state.screen.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('検索エラー: $message'),
                    backgroundColor: Colors.redAccent),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.screen.maybeWhen(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) => ProductWidget(data: data[i]),
            ),
            error: (message) => _errorWidget(message),
            orElse: () => _errorWidget('Unexpected error'),
          );
        },
      ),
    );
  }

  Widget _errorWidget(String error) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      );
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.data});

  final Product data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(data.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.category,
            style: const TextStyle(
                fontStyle: FontStyle.italic, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Text('${data.description.substring(0, 70)}...'),
        ],
      ),
      trailing: Text(
        '\$${data.price?.toStringAsFixed(2) ?? 'N/A'}',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
