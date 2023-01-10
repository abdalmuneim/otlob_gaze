import 'package:flutter/material.dart';

class ShowWidgetDialog extends StatelessWidget {
  const ShowWidgetDialog(
      {Key? key, required this.child, this.backgroundColor, this.elevation})
      : super(key: key);
  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: AlertDialog(
        backgroundColor: backgroundColor,
        elevation: elevation,
        content: child,
      ),
    );
  }
}
