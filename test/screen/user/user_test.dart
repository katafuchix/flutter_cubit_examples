import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_cubit_examples/screen/user/repository/user_repository.dart';
import 'package:flutter_cubit_examples/screen/user/model/user.dart';
import 'package:flutter_cubit_examples/screen/user/state/user_state.dart';
import 'package:flutter_cubit_examples/screen/user/user_cubit.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserCubit cubit;
  late MockUserRepository mockRepository;

  late User user;
  late List<User> users;

  setUp(() {
    mockRepository = MockUserRepository();
    cubit = UserCubit(mockRepository);
    user = User(
        id: 1,
        name: "alice",
        username: "alice",
        email: "",
        phone: "",
        website: "");
    users = [user];
  });

  tearDown(() {
    cubit.close();
  });

  group('UserCubit', () {
    test('初期状態が正しいこと', () {
      expect(
          cubit.state,
          const UserState(
            // 初期状態：Screenはinitial、Dialogはidle
            screen: ScreenState.initial(),
            dialog: DialogState.idle(),
          ));
    });

    blocTest<UserCubit, UserState>(
      '正常系：ロード成功時にLoading状態を経て、ScreenSuccessが発行されること',
      build: () {
        when(() => mockRepository.getUsers()).thenAnswer((_) async => users);
        return cubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const UserState(
            screen: ScreenState.loading(), dialog: DialogState.idle()),
        UserState(
            screen: ScreenState.success(results: users),
            dialog: const DialogState.idle()),
      ],
    );

    blocTest<UserCubit, UserState>(
      '検索失敗時：Loading状態を経て、エラーメッセージが格納されること',
      build: () {
        when(() => mockRepository.getUsers())
            .thenThrow(Exception('Network Error'));
        return cubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const UserState(
            screen: ScreenState.loading(), dialog: DialogState.idle()),
        const UserState(
            screen: ScreenError(message: 'Exception: Network Error'),
            dialog: DialogState.idle())
      ],
    );
  });
}