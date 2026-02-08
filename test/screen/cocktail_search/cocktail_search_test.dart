import 'package:flutter_cubit_examples/screen/cocktail_search/state/cocktail_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_cubit_examples/screen/cocktail_search/cocktail_search_cubit.dart';
import 'package:flutter_cubit_examples/screen/cocktail_search/model/drink.dart';
import 'package:flutter_cubit_examples/screen/cocktail_search/repository/cocktail_repository.dart';

class MockCocktailRepository extends Mock implements CocktailRepository {}

void main() {
  late CocktailSearchCubit cubit;
  late MockCocktailRepository mockRepository;

  late Drink drink;
  late List<Drink> drinks;

  setUp(() {
    mockRepository = MockCocktailRepository();
    cubit = CocktailSearchCubit(mockRepository);
    drink = const Drink(
        idDrink: "17222",
        strDrink: "A1",
        strDrinkThumb:
            "https://www.thecocktaildb.com/images/media/drink/2x8thr1504816928.jpg");
    drinks = [drink];
  });

  tearDown(() {
    cubit.close();
  });

  group('CocktailSearchCubit', () {
    test('初期状態が正しいこと', () {
      expect(
          cubit.state,
          const CocktailState(
            // 初期状態：Screenはinitial、Dialogはidle
            screen: ScreenState.initial(''),
            dialog: DialogState.idle(),
          ));
    });

    blocTest<CocktailSearchCubit, CocktailState>(
      'setSearchWordを呼んだとき、searchWordのみが更新されること',
      build: () => cubit,
      act: (cubit) => cubit.setSearchWord('ねこ'),
      expect: () => [
        const CocktailState(
            screen: ScreenState.initial('ねこ'), dialog: DialogState.idle()),
      ],
    );

    blocTest<CocktailSearchCubit, CocktailState>(
      '検索ワードが1文字未満の場合、検索を実行しないこと',
      build: () => cubit,
      act: (cubit) async {
        cubit.setSearchWord('');
        await cubit.searchCocktail();
      },
      expect: () => [
        const CocktailState(
            screen: ScreenState.initial(''), dialog: DialogState.idle())
        // searchを呼んでも Loading 状態は emit されない
      ],
      verify: (_) {
        // リポジトリが呼ばれていないことを確認
        verifyNever(() => mockRepository.searchCocktail(searchWord: ''));
      },
    );

    blocTest<CocktailSearchCubit, CocktailState>(
      '正常系：ロード成功時にLoading状態を経て、ScreenSuccessが発行されること',
      build: () {
        when(() => mockRepository.searchCocktail(searchWord: 'Flutter'))
            .thenAnswer((_) async => drinks);
        return cubit;
      },
      act: (cubit) async {
        cubit.setSearchWord('Flutter');
        await cubit.searchCocktail();
      },
      expect: () => [
        const CocktailState(
            screen: ScreenState.initial('Flutter'), dialog: DialogState.idle()),
        const CocktailState(
            screen: ScreenState.loading('Flutter'), dialog: DialogState.idle()),
        CocktailState(
            screen: ScreenState.success(results: drinks, word: 'Flutter'),
            dialog: const DialogState.idle()),
      ],
    );
  });

  blocTest<CocktailSearchCubit, CocktailState>(
    '検索失敗時：Loading状態を経て、エラーメッセージが格納されること',
    build: () {
      when(() => mockRepository.searchCocktail(searchWord: "ErrorWord"))
          .thenThrow(Exception('Network Error'));
      return cubit;
    },
    act: (cubit) async {
      cubit.setSearchWord('ErrorWord');
      await cubit.searchCocktail();
    },
    expect: () => [
      const CocktailState(
          screen: ScreenState.initial('ErrorWord'), dialog: DialogState.idle()),
      const CocktailState(
          screen: ScreenState.loading('ErrorWord'), dialog: DialogState.idle()),
      const CocktailState(
          screen: ScreenError(
              message: 'Exception: Network Error', word: 'ErrorWord'),
          dialog: DialogState.idle())
    ],
  );
}
