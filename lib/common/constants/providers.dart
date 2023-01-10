import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/change_password_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/otp_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/recover_account_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/sign_in_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/sign_up_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/confirm_address_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/orders_list_provider.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/providers/communication_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/account_balance_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/home_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/manage_address_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/pages_handler_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/profile_page_provider.dart';
import 'package:otlob_gas/features/home/presentation/widgets/select_location_on_map/select_location_on_map_provider.dart';
import 'package:otlob_gas/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/about_app_provider.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/privacy_provider.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/splash_provider.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/terms_provider.dart';
import 'package:otlob_gas/features/rate_service/presentation/provider/rate_service_provider.dart';
import 'package:otlob_gas/injection.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static List<SingleChildWidget> providers = [
    ..._independentServices,
    ..._dependentServices,
    // ..._uiConsumableProviders,
  ];

  static final List<SingleChildWidget> _independentServices = [
    ChangeNotifierProvider(
        create: (_) => PagesHandlerProvider(locator(), locator())),
    ChangeNotifierProvider(
        create: (_) => AuthProvider(locator(), locator(), locator())),
    Provider(create: (_) => RecoverAccountProvider(locator())),
    Provider(create: (_) => ChangePasswordProvider(locator())),
    Provider(create: (_) => SignInProvider(locator(), locator())),
    ChangeNotifierProvider(
      create: (_) => NotificationsProvider(
        locator(),
        locator(),
        locator(),
        locator(),
      ),
    ),
    ChangeNotifierProvider(create: (_) => RateServiceProvider(locator())),
    ChangeNotifierProvider(
        create: (_) => CommunicationProvider(
            locator(), locator(), locator(), locator(), locator())),
    ChangeNotifierProvider(
        create: (_) =>
            SplashProvider(locator(), locator(), locator(), locator())),
    ChangeNotifierProvider(
        create: (_) => SelectLocationOnMapProvider(locator())),
    ChangeNotifierProvider(
        create: (_) => ManageAddressProvider(locator(), locator(), locator())),
    ChangeNotifierProvider(create: (_) => ConfirmAddressProvider()),
    ChangeNotifierProvider(create: (_) => OrdersListProvider(locator())),
    ChangeNotifierProvider(create: (_) => OTPProvider(locator())),
    ChangeNotifierProvider(create: (_) => PrivacyProvider(locator())),
    ChangeNotifierProvider(create: (_) => AboutAppProvider(locator())),
    ChangeNotifierProvider(create: (_) => TermsProvider(locator())),
  ];

  static final List<SingleChildWidget> _dependentServices = [
    ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
        update: (__, authProvider, homeProvider) {
          return homeProvider!..location = authProvider.currentUser?.location;
        },
        create: (_) => HomeProvider(
              locator(),
              locator(),
              locator(),
            )),
    ChangeNotifierProxyProvider<AuthProvider, SignUpProvider>(
        update: (__, authProvider, signUpProvider) =>
            signUpProvider!..currentUser = authProvider.currentUser,
        create: (_) => SignUpProvider(locator(), locator(), locator())),
    ChangeNotifierProxyProvider<AuthProvider, ProfilePageProvider>(
        update: (__, authProvider, profilePageProvider) =>
            profilePageProvider!..setUser = authProvider.currentUser,
        create: (_) => ProfilePageProvider(locator())),
    ChangeNotifierProxyProvider<AuthProvider, AccountBalanceProvider>(
        update: (__, authProvider, profilePageProvider) => profilePageProvider!
          ..currentBalance = authProvider.currentUser?.wallet ?? 0,
        create: (_) => AccountBalanceProvider(locator())),
    ChangeNotifierProxyProvider<AuthProvider, CreateOrderProvider>(
        update: (__, authProvider, createOrderProvider) {
          return createOrderProvider!
            ..wallet = authProvider.currentUser?.wallet;
        },
        create: (_) => CreateOrderProvider(
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
            )),
  ];

  // static final List<SingleChildWidget> _uiConsumableProviders = [];
}
