import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart'
    as n;
import 'package:otlob_gas/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {Key? key, required this.notification, required this.isTodayNotification})
      : super(key: key);
  final n.Notification notification;
  final bool isTodayNotification;

  String getIcon(int status) {
    switch (status) {
      case 0:
        return Assets.bottPersonIC;
      case 1:
      case 5:
        return Assets.warning;
      case 2:
        return Assets.infoYellowIC;
      case 6:
        return Assets.messagesIC;

      default:
        return Assets.carBlueIC;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          SvgPicture.asset(
            getIcon(notification.status!),
            height: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomText(
              notification.message,
            ),
          ),
          const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () => context
                    .read<NotificationsProvider>()
                    .deleteNotification(notification.id!, isTodayNotification),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(Assets.closeIC),
                )),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
