import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/orders_list_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/widgets/completed_order_card.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:otlob_gas/widget/notification_button_widget.dart';
import 'package:provider/provider.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({Key? key}) : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  late final OrdersListProvider ordersListProvider =
      context.read<OrdersListProvider>();

  @override
  void initState() {
    ordersListProvider.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ordersListProvider.init(),
      child: Scaffold(
        appBar: CustomAppBar(
          toolbarHeight: 65,
          actions: const [
            NotificationButton(),
            SizedBox(width: 10),
          ],
          title: CustomText(
            Utils.localization?.completed_orders,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 25),
          ),
        ),
        body: Consumer<OrdersListProvider>(
          builder: (_, ordersListProvider, __) {
            if (ordersListProvider.isLoading) {
              return const LoadingWidget();
            }
            if (ordersListProvider.orders.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(Assets.emptyList),
                  const SizedBox(height: 10.0),
                  CustomText(Utils.localization?.your_orders_list_is_empty)
                ],
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final order = ordersListProvider.orders[index];
                return CompletedOrderCard(order: order);
              },
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              itemCount: ordersListProvider.orders.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.grey[300],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
