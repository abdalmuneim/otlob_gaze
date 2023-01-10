import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
    required this.isRootBack,
  }) : super(key: key);

  final bool isRootBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isRootBack) {
          Navigator.pop(context);
        } else {
          context.pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.white)),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
