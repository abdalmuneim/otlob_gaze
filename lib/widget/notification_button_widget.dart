import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name !=
            RouteStrings.notificationPage) {
          context.pushNamed(RouteStrings.notificationPage);
        }
      },
      child: SizedBox(
        width: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
              )),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
