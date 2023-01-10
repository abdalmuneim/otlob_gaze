import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<SplashProvider>().startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splash,
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Spacer(),
        Image.asset(
          Assets.splashTop,
          height: 200,
        ),
        const Spacer(),
        Image.asset(
          Assets.splashCenter,
          height: 250,
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        const Spacer(),
        Image.asset(
          Assets.splashBottom,
        ),
      ]),
    );
  }
}
