import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    this.height,
    required this.onPressed,
    required this.icon,
    this.elevation,
    this.textColor,
    required this.text,
    this.width,
    this.color = AppColors.mainApp,
    Key? key,
    this.borderRadius = 30,
    this.borderColor,
  }) : super(key: key);
  final VoidCallback onPressed;
  final double? height;
  final double borderRadius;
  final double? width;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? elevation;
  final Icon icon;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
        borderColor: borderColor,
        color: color,
        borderRadius: borderRadius,
        elevation: elevation,
        height: height,
        width: width,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 5.0),
            CustomText(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textColor ?? AppColors.lightRed),
            ),
          ],
        ));
  }
}
