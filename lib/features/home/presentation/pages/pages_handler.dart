import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/presentation/pages/orders_list_page.dart';
import 'package:otlob_gas/features/home/presentation/pages/account_balance_page.dart';
import 'package:otlob_gas/features/home/presentation/pages/home_page.dart';
import 'package:otlob_gas/features/home/presentation/pages/profile_page.dart';
import 'package:otlob_gas/features/home/presentation/provider/pages_handler_provider.dart';
import 'package:otlob_gas/features/home/presentation/widgets/drawer_widget.dart';
import 'package:otlob_gas/widget/close_app_dialog_widget.dart';
import 'package:provider/provider.dart';

class PagesHandler extends StatefulWidget {
  const PagesHandler({Key? key}) : super(key: key);

  @override
  State<PagesHandler> createState() => _PagesHandlerState();
}

class _PagesHandlerState extends State<PagesHandler>
    with WidgetsBindingObserver {
  late final PagesHandlerProvider pagesHandlerProvider =
      context.read<PagesHandlerProvider>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pagesHandlerProvider.listenToNetwork();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    pagesHandlerProvider.handleAppLifeCycleChanges(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Utils.showCustomDialog(
          showClose: true,
          borderRadius: BorderRadius.circular(20),
          content:
              CloseAppDialogWidget(pagesHandlerProvider: pagesHandlerProvider),
          name: CloseAppDialogWidget.dialogName,
        );
        return false;
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        key: pagesHandlerProvider.scaffoldKey,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Consumer<PagesHandlerProvider>(
              builder: (_, pagesHandlerProvider, __) {
                return Stack(
                  children: [
                    IndexedStack(
                      index: pagesHandlerProvider.currentIndex,
                      children: const [
                        HomePage(),
                        OrdersListPage(),
                        // SizedBox can't be changed if you want to get the empty space in the middle of the bottom nav bar
                        SizedBox(),
                        ProfilePage(),
                        AccountBalance(),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              //bottom navigation bar on scaffold
                              selectedItemColor: AppColors.mainApp,
                              unselectedItemColor: Colors.black,
                              currentIndex: pagesHandlerProvider.currentIndex,
                              onTap: (value) =>
                                  pagesHandlerProvider.setIndex = value,
                              backgroundColor: Colors.white,
                              // shape: const CircularNotchedRectangle(), //shape of notch
                              // notchMargin:
                              //     5, //notche margin between floating button and bottom appbar
                              selectedLabelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 16.0),
                              unselectedLabelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 16.0),
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  label: Utils.localization?.askForGas,
                                  icon: SvgPicture.asset(
                                    Assets.botCarIC,
                                    color:
                                        pagesHandlerProvider.getCurrentColor(0),
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  label: Utils.localization?.my_orders,
                                  icon: SvgPicture.asset(
                                    Assets.botMyOrderIC,
                                    color:
                                        pagesHandlerProvider.getCurrentColor(1),
                                  ),
                                ),
                                const BottomNavigationBarItem(
                                  label: '',
                                  icon: IgnorePointer(child: SizedBox()),
                                ),
                                BottomNavigationBarItem(
                                  label: Utils.localization?.account,
                                  icon: SvgPicture.asset(
                                    Assets.bottPersonIC,
                                    color:
                                        pagesHandlerProvider.getCurrentColor(3),
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  label: Utils.localization?.wallet,
                                  icon: SvgPicture.asset(
                                    Assets.dollar,
                                    color:
                                        pagesHandlerProvider.getCurrentColor(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
