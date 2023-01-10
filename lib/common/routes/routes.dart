import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/stored_keys.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/authentication/presentation/pages/change_password_page.dart';
import 'package:otlob_gas/features/authentication/presentation/pages/otp_page.dart';
import 'package:otlob_gas/features/authentication/presentation/pages/recover_account_page.dart';
import 'package:otlob_gas/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:otlob_gas/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:otlob_gas/features/checkout/presentation/pages/confirm_address_page.dart';
import 'package:otlob_gas/features/checkout/presentation/pages/orders_list_page.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/pages/communication_with_the_driver.dart';
import 'package:otlob_gas/features/home/presentation/pages/pages_handler.dart';
import 'package:otlob_gas/features/notifications/presentation/pages/notifications_page.dart';
import 'package:otlob_gas/features/on_boarding/presentation/pages/about_app_page.dart';
import 'package:otlob_gas/features/on_boarding/presentation/pages/privacy_page.dart';
import 'package:otlob_gas/features/on_boarding/presentation/pages/splash_page.dart';
import 'package:otlob_gas/features/on_boarding/presentation/pages/terms_page.dart';
import 'package:otlob_gas/features/rate_service/presentation/pages/rate_service_page.dart';

import '../../features/checkout/presentation/pages/create_order_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class Routes {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: RouteStrings.splashPage,
        path: RouteStrings.splashPage,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        name: RouteStrings.loginPage,
        path: RouteStrings.loginPage,
        builder: (BuildContext context, GoRouterState state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        name: RouteStrings.signUpPage,
        path: RouteStrings.signUpPage,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        name: RouteStrings.editAccountPage,
        path: RouteStrings.editAccountPage,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage(
            isEdit: true,
          );
        },
      ),
      GoRoute(
        name: RouteStrings.communicationWithTheDriver,
        path: RouteStrings.communicationWithTheDriver,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> query = state.queryParams;
          return CommunicationWithTheDriver(orderId: query[StoredKeys.orderId]);
        },
      ),
      GoRoute(
        name: RouteStrings.pagesHandler,
        path: RouteStrings.pagesHandler,
        builder: (BuildContext context, GoRouterState state) {
          return const PagesHandler();
        },
      ),
      GoRoute(
          name: RouteStrings.rateService,
          path: RouteStrings.rateService,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> query = state.queryParams;
            return RateServicePage(orderId: query[StoredKeys.orderId]);
          }),
      GoRoute(
        name: RouteStrings.notificationPage,
        path: RouteStrings.notificationPage,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        name: RouteStrings.orderListPage,
        path: RouteStrings.orderListPage,
        builder: (BuildContext context, GoRouterState state) {
          return const OrdersListPage();
        },
      ),
      GoRoute(
        name: RouteStrings.homePage,
        path: RouteStrings.homePage,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        name: RouteStrings.createOrderPage,
        path: RouteStrings.createOrderPage,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> query = state.queryParams;
          return CreateOrderPage(
            driverNotes: query[StoredKeys.driverNotes],
            quantity: query[StoredKeys.quantity] == null
                ? null
                : int.tryParse(query[StoredKeys.quantity]),
            location: query[StoredKeys.myLocation] == null
                ? null
                : UserLocationModel.fromJson(query[StoredKeys.myLocation])
                    as UserLocation,
          );
        },
      ),
      GoRoute(
        name: RouteStrings.confirmAddress,
        path: RouteStrings.confirmAddress,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> query = state.queryParams;
          return ConfirmAddressPage(
            myLocation:
                UserLocationModel.fromJson(query[StoredKeys.myLocation]),
          );
        },
      ),
      GoRoute(
        name: RouteStrings.recoverAccount,
        path: RouteStrings.recoverAccount,
        builder: (BuildContext context, GoRouterState state) {
          return const RecoverAccountPage();
        },
      ),
      GoRoute(
        name: RouteStrings.changePasswordPage,
        path: RouteStrings.changePasswordPage,
        builder: (BuildContext context, GoRouterState state) {
          return ChangePasswordPage(
            mobile: state.queryParams[StoredKeys.phoneNumber]!,
          );
        },
      ),
      GoRoute(
        name: RouteStrings.otpPage,
        path: RouteStrings.otpPage,
        builder: (BuildContext context, GoRouterState state) {
          final String phoneNumber = state.queryParams[StoredKeys.phoneNumber]!;
          final bool isVerifyAction = bool.fromEnvironment(
              state.queryParams[StoredKeys.isVerifyAction]!);
          return OTPPage(
            phoneNumber: phoneNumber,
            isVerifyAction: isVerifyAction,
          );
        },
      ),
      GoRoute(
        name: RouteStrings.privacy,
        path: RouteStrings.privacy,
        builder: (BuildContext context, GoRouterState state) {
          return const PrivacyPage();
        },
      ),
      GoRoute(
        name: RouteStrings.terms,
        path: RouteStrings.terms,
        builder: (BuildContext context, GoRouterState state) {
          return const TermsPage();
        },
      ),
      GoRoute(
        name: RouteStrings.aboutApp,
        path: RouteStrings.aboutApp,
        builder: (BuildContext context, GoRouterState state) {
          return const AboutAppPage();
        },
      ),
    ],
  );
}
