import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(this.text,
      {this.decoration,
      this.max,
      this.overflow,
      this.textAlign,
      this.style,
      Key? key})
      : super(key: key);

  final String? text;
  final TextDecoration? decoration;
  final int? max;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: max,
      overflow: overflow,
      textAlign: textAlign,
      style: style ?? Theme.of(context).textTheme.bodySmall,
    );
  }
}
