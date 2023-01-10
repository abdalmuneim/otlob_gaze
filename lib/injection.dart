import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/common/services/location_services.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:otlob_gas/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/change_password_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/edit_account_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/is_logged_in_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/log_out_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/recover_account_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/save_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/sign_in_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/sign_up_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/verify_account_use_case.dart';
import 'package:otlob_gas/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:otlob_gas/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/assign_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/cancel_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/create_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/delivered_check_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/delivered_un_check_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/disconnect_checkout_pusher_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/get_orders_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/init_checkout_pusher_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/listen_to_checkout_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/order_delivered_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/datasources/communicate_remote_data_source.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/repositories/communication_repository_impl.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/disconnect_chat_pusher_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/get_chat_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/init_chat_pusher_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/listen_to_chat_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/send_message_use_case.dart';
import 'package:otlob_gas/features/home/data/datasources/home_data_source.dart';
import 'package:otlob_gas/features/home/data/repositories/home_repository_impl.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';
import 'package:otlob_gas/features/home/domain/usecases/add_my_location_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/change_user_activity_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/charge_balance_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/edit_my_location_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_ads_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_my_locations_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_nearest_drivers_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_order_status_use_case.dart';
import 'package:otlob_gas/features/notifications/data/datasources/notifications_data_source.dart';
import 'package:otlob_gas/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:otlob_gas/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/delete_all_notifications_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/delete_notification_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/get_today_notifications_use_case.dart';
import 'package:otlob_gas/features/on_boarding/data/datasources/on_boarding_data_source.dart';
import 'package:otlob_gas/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_language_use_case.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/save_language_use_case.dart';
import 'package:otlob_gas/features/rate_service/data/datasources/rate_service_data_source.dart';
import 'package:otlob_gas/features/rate_service/data/repositories/rate_service_repository_imp.dart';
import 'package:otlob_gas/features/rate_service/domain/repositories/rate_service_repository.dart';
import 'package:otlob_gas/features/rate_service/domain/usecases/add_rate_service_use_case.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> init() async {
  final SharedPreferences sharedInstance =
      await SharedPreferences.getInstance();

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => const FlutterSecureStorage());
  locator.registerLazySingleton(() => InternetConnectionCheckerPlus());
  locator.registerLazySingleton(() => sharedInstance);
  locator.registerLazySingleton(() => LocationServices());
  locator.registerLazySingleton(() => PusherChannelsFlutter.getInstance());
  //end external

  // usecases
  locator.registerLazySingleton(() => GetCurrentUserUseCase(locator()));
  locator.registerLazySingleton(() => VerifyAccountUseCase(locator()));
  locator.registerLazySingleton(() => GetAdsUseCase(locator()));
  locator.registerLazySingleton(() => GetMyLocationsUseCase(locator()));
  locator.registerLazySingleton(() => ChangePasswordUseCase(locator()));
  locator.registerLazySingleton(() => SignInUserUseCase(locator()));
  locator.registerLazySingleton(() => GetNearestDriversUseCase(locator()));
  locator.registerLazySingleton(() => SignUpUserUseCase(locator()));
  locator.registerLazySingleton(() => RecoverAccountUserUseCase(locator()));
  locator.registerLazySingleton(() => LogOutUseCase(locator()));
  locator.registerLazySingleton(() => IsLoggedInUseCase(locator()));
  locator.registerLazySingleton(() => SaveLanguageUseCase(locator()));
  locator.registerLazySingleton(() => GetLanguageUseCase(locator()));
  locator.registerLazySingleton(() => ChangeUserActivityUseCase(locator()));
  locator.registerLazySingleton(() => EditAccountUseCase(locator()));
  locator.registerLazySingleton(() => AddMyLocationUseCase(locator()));
  locator.registerLazySingleton(() => EditMyLocationUseCase(locator()));
  locator.registerLazySingleton(() => CreateOrderUseCase(locator()));
  locator.registerLazySingleton(() => SaveUserUseCase(locator()));
  locator.registerLazySingleton(() => SendMessageUseCase(locator()));
  locator.registerLazySingleton(() => AddRatingUseCase(locator()));
  locator.registerLazySingleton(() => GetChatUseCase(locator()));
  locator.registerLazySingleton(() => InitChatPusherUseCase(locator()));
  locator.registerLazySingleton(() => DisconnectChatPusherUseCase(locator()));
  locator.registerLazySingleton(() => ListenToChatUseCase(locator()));
  locator.registerLazySingleton(() => InitCheckoutPusherUseCase(locator()));
  locator
      .registerLazySingleton(() => DisconnectCheckoutPusherUseCase(locator()));
  locator.registerLazySingleton(() => ListenToCheckoutUseCase(locator()));
  locator.registerLazySingleton(() => ChargeBalanceUseCase(locator()));
  locator.registerLazySingleton(() => GetOrdersUseCase(locator()));
  locator.registerLazySingleton(() => AssignOrderUseCase(locator()));
  locator.registerLazySingleton(() => DeliveredCheckedUseCase(locator()));
  locator.registerLazySingleton(() => OrderDeliveredUseCase(locator()));
  locator.registerLazySingleton(() => DeliveredUnCheckedUseCase(locator()));
  locator.registerLazySingleton(() => CancelOrderUseCase(locator()));
  locator.registerLazySingleton(() => GetOrderStatusUseCase(locator()));

  // notifications
  locator.registerLazySingleton(() => DeleteNotificationUseCase(locator()));
  locator.registerLazySingleton(() => DeleteAllNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => GetAllNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => GetTodayNotificationsUseCase(locator()));

  //end usecases

  // repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
      getLanguageUseCase: locator(),
    ),
  );
  locator.registerLazySingleton<RateServiceRepository>(
    () => RateServiceRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<CommunicationRepository>(
    () => CommunicationRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnectionChecker: locator(),
    ),
  );
  locator.registerLazySingleton<OnBoardingRepository>(
    () => OnBoardingRepositoryImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      dataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  //end repository

  //remote data source
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<RateServiceDataSource>(
    () => RateServiceDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(
      client: locator(),
      pusher: locator(),
    ),
  );
  locator.registerLazySingleton<CommunicationRemoteDataSource>(
    () => CommunicationRemoteDataSourceImpl(
      client: locator(),
      pusher: locator(),
    ),
  );
  locator.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  //end remote data source

  //local data source
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      flutterSecureStorage: locator(),
      sharedPreferences: locator(),
    ),
  );
  locator.registerLazySingleton<OnBoardingDataSource>(
    () => OnBoardingDataSourceImpl(
      sharedPreferences: locator(),
      client: locator(),
    ),
  );
  //end local data source
}
