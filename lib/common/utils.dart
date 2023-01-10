import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Utils {
  static void showToast(String text,
          {Color? backgroundColor, Color? textColor, int? duration}) =>
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(_context).size.width - 50,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration ?? 4),
          content: CustomText(text,
              style: Theme.of(_context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: textColor ?? Colors.white, fontSize: 22)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: backgroundColor ?? Colors.green.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      );

  static void showErrorToast(String text, {int? duration}) =>
      showToast(text, backgroundColor: Colors.red.withOpacity(0.7));

  static AppLocalizations? get localization => AppLocalizations.of(_context);
  static bool get isRTL {
    final bool isRTL = (localization?.localeName ?? 'ar') == 'ar';
    return isRTL;
  }

  static BuildContext get _context => NavigationService.context;

// stack of dialogs to know if there is a dialog with the same title or not
  static final _allDialogs = <dynamic>[];
// add dialog to _allDialog to know if there is a dialog with the same title or not
  static showEnhancedDialog(
      {required String dialogName, required Function dialog}) {
    if (_allDialogs.isNotEmpty && _allDialogs.last == dialogName) {
      Navigator.pop(_context);
    } else {
      _allDialogs.add(dialogName);
    }
    dialog();
  }

// remove dialog from _allDialog
  static removeEnhancedDialog({required String dialogName}) {
    if (_allDialogs.contains(dialogName)) {
      _allDialogs.remove(dialogName);
      Navigator.pop(_context);
    }
  }

// clear all dialogs from _allDialog
  static clearDialogs() {
    _allDialogs.clear();
  }

// custom Network dialog
  static showNetworkDialog(
      {required String lottie, required String text, bool isLoading = false}) {
    ScaffoldMessenger.of(_context).clearSnackBars();
    showDialog(
      context: _context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieBuilder.asset(lottie),
                  const SizedBox(height: 10.0),
                  CustomText(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
        );
      },
    );
  }

//show Custom Dialogs
  static showCustomDialog(
      {required Widget content,
      List<Widget>? actions,
      required String name,
      bool showClose = false,
      BorderRadiusGeometry? borderRadius}) {
    showEnhancedDialog(
      dialogName: name,
      dialog: () => showDialog(
        context: _context,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async {
              if (showClose) {
                hideCustomDialog(name: name);
              }
              return false;
            },
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titlePadding: EdgeInsets.zero,
              title: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: MediaQuery.of(_context).size.width,
                    child: Material(
                      elevation: 24,
                      borderRadius: borderRadius ?? BorderRadius.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 24),
                        child: content,
                      ),
                    ),
                  ),
                  if (showClose)
                    Positioned(
                      top: -15,
                      right: -15,
                      child: GestureDetector(
                        onTap: () => hideCustomDialog(name: name),
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 16,
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              actions: actions,
            ),
          );
        },
      ),
    );
  }

//hide Custom Dialogs
  static hideCustomDialog({required String name}) {
    removeEnhancedDialog(dialogName: name);
  }

// data sources failures handler
  static void handleFailures(Failure failure) {
    switch (failure.runtimeType) {
      case ExceptionFailure:
        showErrorToast(localization?.somethingWentWrong ?? '');

        break;
      case ConnectionFailure:
        showEnhancedDialog(
            dialogName: localization?.networkFailure ?? '',
            dialog: () => showNetworkDialog(
                lottie: Assets.noInternet,
                text: localization?.networkFailure ?? ''));
        break;
      case UnAuthorizedFailure:
        _context.goNamed(RouteStrings.loginPage);
        _context.read<AuthProvider>().resetUser();
        showErrorToast(localization?.unAuthMessage ?? '');
        break;
      case UnVerifiedFailure:
        // failure.message is the phone number in this case
        NavigatorUtils.goToOTPPage(
            phoneNumber: failure.message, isVerifyAction: true);

        break;
      case DatabaseFailure:
        showErrorToast(localization?.user_not_found ?? '');
        break;
      default:
        showErrorToast(failure.message);
        break;
    }
  }

// method for hide loading
  static void hideLoading() {
    removeEnhancedDialog(dialogName: 'loading');
  }

// method for show loading
  static void showLoading({String? message}) {
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();
    showEnhancedDialog(
        dialogName: 'loading',
        dialog: () => showDialog(
            context: _context,
            barrierDismissible: false,
            builder: (ctx) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  contentPadding: EdgeInsets.zero,
                  content: SizedBox(
                    height: 350,
                    child: LoadingWidget(
                      description: message,
                    ),
                  ),
                ),
              );
            }));
  }

  //   method to get Images by specific size
  static Future<Uint8List> getBytesFromAsset(String path,
      {required int width, required int height}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //   method to get text directionality
  static TextDirection getDirection(String text) {
    final string = text.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  //   getter to show facebook shimmer effect
  static Shimmer get putShimmer {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Container(
        color: Colors.grey.shade300,
      ),
    );
  }
}
