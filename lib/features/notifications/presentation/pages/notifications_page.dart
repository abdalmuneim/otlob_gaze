import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart'
    as n;
import 'package:otlob_gas/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:otlob_gas/features/notifications/presentation/widgets/notification_card.dart';
import 'package:otlob_gas/widget/back_button_widget.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsProvider _notificationsProvider =
      context.read<NotificationsProvider>();

  @override
  void initState() {
    _notificationsProvider.initPage();
    super.initState();
  }

  @override
  void dispose() {
    _notificationsProvider.disposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          toolbarHeight: 106,
          title: Text(Utils.localization!.notification),
          actions: [
            GestureDetector(
              onTap: () {
                const String dialogName = 'delete-all-notifications';
                Utils.showCustomDialog(
                    borderRadius: BorderRadius.circular(20),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          Utils.localization
                              ?.do_you_want_to_delete_all_notification,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.black, fontSize: 22),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              onPressed: () {
                                Utils.hideCustomDialog(name: dialogName);
                                _notificationsProvider.deleteAllNotifications();
                              },
                              color: Colors.red,
                              child: CustomText(
                                Utils.localization?.yes,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            CustomButton(
                              onPressed: () {
                                Utils.hideCustomDialog(name: dialogName);
                              },
                              color: AppColors.mainApp,
                              child: CustomText(
                                Utils.localization?.no,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    name: dialogName);
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: const Icon(Icons.delete_outline),
              ),
            ),
            const SizedBox(width: 10.0),
            const BackButtonWidget(isRootBack: false),
            const SizedBox(width: 10.0),
          ],

          /// Tabs bar
          tabs: [
            Tab(
                child: Text(
              Utils.localization?.todays_alerts ?? "",
            )),
            Tab(
                child: Text(
              Utils.localization?.previous_alerts ?? "",
            )),
            /*   Tab(
                child: Row(
              children: [
                SvgPicture.asset(Assets.readActiveIC),
                const SizedBox(width: 10),
                Text(
                  Utils.localization?.read_all ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: AppColors.mainApp),
                ),
              ],
            )), */
          ],
        ),
        body: Selector<NotificationsProvider, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (_, isLoading, __) {
              if (isLoading) {
                return const LoadingWidget();
              }
              return Consumer<NotificationsProvider>(
                  builder: (_, notificationsProvider, __) {
                return TabBarView(
                  children: [
                    /// today notify
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final n.Notification notification =
                            notificationsProvider.todayNotifications[index];
                        return NotificationCard(
                          notification: notification,
                          isTodayNotification: true,
                        );
                      },
                      itemCount:
                          notificationsProvider.todayNotifications.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,

                          // decoration: BoxDecoration(
                          color: Colors.grey[300],
                          // ),
                        );
                      },
                    ),

                    /// pervious notify
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final n.Notification notification =
                            notificationsProvider.allNotifications[index];
                        return NotificationCard(
                          notification: notification,
                          isTodayNotification: false,
                        );
                      },
                      itemCount: notificationsProvider.allNotifications.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,

                          // decoration: BoxDecoration(
                          color: Colors.grey[300],
                          // ),
                        );
                      },
                    )

                    /*    /// reade notify
                ListView.separated(
                  itemBuilder: (context, index) {
                    return const NotificationCard();
                  },
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    );
                  },
                ),
             */
                  ],
                );
              });
            }),
      ),
    );
  }
}
