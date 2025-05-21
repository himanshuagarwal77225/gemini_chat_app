import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Chat
  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      sendMessage: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      apiKey: AppConfig.geminiApiKey,
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
