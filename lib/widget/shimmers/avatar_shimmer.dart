import 'package:flutter/material.dart';
import 'package:otlob_gas/common/utils.dart';

class AvatarShimmer extends StatelessWidget {
  const AvatarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25), child: Utils.putShimmer),
    );
  }
}
