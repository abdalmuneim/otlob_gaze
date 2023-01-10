import 'package:flutter/material.dart';
import 'package:otlob_gas/common/utils.dart';

class TextShimmer extends StatelessWidget {
  const TextShimmer({super.key, this.width = 100});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10, width: width, child: Utils.putShimmer),
      ],
    );
  }
}
