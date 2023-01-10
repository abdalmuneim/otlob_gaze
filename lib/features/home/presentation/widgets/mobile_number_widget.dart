import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class MobileNumberWidget extends StatelessWidget {
  const MobileNumberWidget({
    Key? key,
    required this.mobile,
    this.color = Colors.white,
  }) : super(key: key);

  final String? mobile;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.phoneActive,
          color: color,
        ) /*  Icon(
          Icons.phone_android,
          color: color ?? Colors.white,
          size: 15,
        ) */
        ,
        const SizedBox(
          width: 10,
        ),
        CustomText(
          mobile,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: color),
        ),
      ],
    );
  }
}
