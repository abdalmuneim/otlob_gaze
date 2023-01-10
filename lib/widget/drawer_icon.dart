import 'package:flutter/material.dart';
import 'package:otlob_gas/features/home/presentation/provider/pages_handler_provider.dart';
import 'package:provider/provider.dart';

class DrawerIcon extends StatelessWidget {
  const DrawerIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.white)),
      child: GestureDetector(
          onTap: () => context
              .read<PagesHandlerProvider>()
              .scaffoldKey
              .currentState!
              .openDrawer(),
          child: const Icon(Icons.list)),
    );
  }
}
