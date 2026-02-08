import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'model/drink.dart';
import 'repository/cocktail_repository_impl.dart';

import 'cocktail_search_cubit.dart';
import 'state/cocktail_state.dart';

class CocktailSearchScreen extends StatelessWidget {
  const CocktailSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CocktailSearchCubit(CocktailRepositoryImpl(Dio())),
      child: const CocktailSearchPage(),
    );
  }
}

class CocktailSearchPage extends StatefulWidget {
  const CocktailSearchPage({super.key});

  @override
  State<CocktailSearchPage> createState() => CocktailSearchPageState();
}

class CocktailSearchPageState extends State<CocktailSearchPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.canRequestFocus = false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 通知（Dialog/SnackBar）のみを監視する Listener
    return BlocConsumer<CocktailSearchCubit, CocktailState>(
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
            error: (message, _) {
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
          // 2. 描画（UI作成）を担当する領域
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cocktail Search'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _searchTextField(),
                            const SizedBox(height: 10),
                            _searchButton(state),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: state.screen.when(
                          initial: (_) =>
                              const Center(child: Text('キーワードを入力してください')),
                          loading: (_) => const SizedBox.shrink(),
                          // Listener が Loading を出すので空でOK
                          error: (message, _) => Center(
                            child: Text(message,
                                style: const TextStyle(color: Colors.red)),
                          ),
                          // 【ここがポイント】success と loading_more で同じ GridView を呼び出す
                          success: (results, word) =>
                              _buildListView(context, results, false),
                        ),
                      ))
                    ],
                  );
                },
              ),
            ),
          );
        });
  }

  // 入力欄
  Widget _searchTextField() {
    final cubit = context.read<CocktailSearchCubit>();
    return TextField(
      focusNode: _focusNode,
      onTap: () {
        setState(() => _focusNode.canRequestFocus = true);
        _focusNode.requestFocus();
      },
      onTapOutside: (_) {
        _focusNode.unfocus();
        setState(() => _focusNode.canRequestFocus = false);
      },
      onChanged: (value) => cubit.setSearchWord(value),
      decoration: const InputDecoration(
        labelText: '検索キーワード',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  // 検索ボタン
  Widget _searchButton(CocktailState state) {
    final cubit = context.read<CocktailSearchCubit>();
    return ElevatedButton(
      onPressed: cubit.isSearchButtonEnabled && state.screen is! ScreenLoading
          ? () {
              FocusScope.of(context).unfocus();
              cubit.searchCocktail();
            }
          : null,
      child: state.screen.maybeWhen(
        loading: (_) => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        orElse: () => const Text('検索'),
      ),
    );
  }

  // カクテルのリスト表示
  Widget _buildListView(
      BuildContext context, List<Drink> results, bool isLoadingMore) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: CircleAvatar(
              child: CachedNetworkImage(
            imageUrl: item.strDrinkThumb,
            fit: BoxFit.cover,
            // ロード中はこの Widget を「出し続ける」
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(
                  child: const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              )),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )),
          title: Text(item.strDrink),
        );
      },
    );
  }
}
