// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class CompletedOrderCard extends StatelessWidget {
  const CompletedOrderCard({Key? key, required this.order}) : super(key: key);
  final OrderEntity order;
  SvgPicture get currentIcon {
    switch (order.status) {
      case 2:
        return SvgPicture.asset(
          Assets.orderDoneIC,
          height: 20,
        );
      case 0:
        return SvgPicture.asset(
          Assets.clockBlueIC,
          height: 20,
        );
      default:
        return SvgPicture.asset(
          Assets.warning,
          height: 20,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: ListTile(
          leading: Image.asset(Assets.ambobaIC, width: 40, height: 40),
          title: CustomText(
              "${Utils.localization?.number_of_cylinders ?? ''} ${order.quantity}"),
          subtitle: CustomText(
            order.date?.appDateFormat,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              currentIcon,
              const SizedBox(
                width: 5,
              ),
              CustomText(
                order.statusName,
              ),
            ],
          ),
        ));
  }
}
