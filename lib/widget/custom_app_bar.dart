import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/widget/back_button_widget.dart';
import 'package:otlob_gas/widget/notification_button_widget.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final double toolbarHeight;
  final Widget title;
  final bool centerTitle;
  final List<Widget>? actions;
  final List<Widget>? tabs;
  final Widget? bottomWidget;
  final Widget? leading;
  final bool isRootBack;

  CustomAppBar({
    Key? key,
    required this.title,
    this.bottomWidget,
    this.centerTitle = false,
    this.isRootBack = false,
    this.actions,
    this.tabs,
    this.toolbarHeight = 56,
    this.leading,
  })  : preferredSize = Size.fromHeight(toolbarHeight),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Widget> customActions = <Widget>[
      const NotificationButton(),
      const SizedBox(width: 10),
      BackButtonWidget(isRootBack: isRootBack),
      const SizedBox(width: 10),
    ];
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      actions: actions ?? customActions,
      leading: leading ?? const SizedBox(),
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, toolbarHeight),
        child: Material(
            color: Colors.white,
            child: bottomWidget ??
                (tabs == null
                    ? null
                    : Material(
                        color: Colors.white,
                        elevation: 1,
                        child: TabBar(
                            automaticIndicatorColorAdjustment: true,
                            unselectedLabelStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            unselectedLabelColor: Colors.grey,
                            labelColor: AppColors.mainApp,
                            indicatorColor: AppColors.mainApp,
                            tabs: tabs!),
                      ))),
      ),
    );
  }
}
