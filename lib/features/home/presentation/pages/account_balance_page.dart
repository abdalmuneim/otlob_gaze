import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/home/presentation/provider/account_balance_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/profile_page_provider.dart';
import 'package:otlob_gas/features/home/presentation/widgets/profile_app_bar.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';

class AccountBalance extends StatefulWidget {
  const AccountBalance({Key? key}) : super(key: key);

  @override
  State<AccountBalance> createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalance> {
  late final AccountBalanceProvider accountBalanceProvider =
      context.read<AccountBalanceProvider>();

  late final ProfilePageProvider profilePageProvider =
      context.read<ProfilePageProvider>();
  bool isLoading = true;
  init() async {
    if (!isLoading) {
      return;
    }
    await accountBalanceProvider.initPage();
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    accountBalanceProvider.disposePage();
    super.dispose();
  }

  void showChargeBalance() {
    accountBalanceProvider.cardNumberController.clear();
    Utils.showCustomDialog(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      name: AccountBalanceProvider.chargeBalanceDialogName,
      showClose: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// balance_charge_window
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                Utils.localization?.billing_card,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 25),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// text name
          CustomText(Utils.localization?.recharge_card_number),
          const SizedBox(height: 10),

          /// form name
          Form(
            key: accountBalanceProvider.formKey,
            child: CustomTextField(
              prefixText: '     ',
              prefixIcon: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.credit_card,
                  color: Colors.grey.shade800,
                ),
              ),
              textEditingController:
                  accountBalanceProvider.cardNumberController,
              isNumberOnly: true,
              validator: (value) => AppValidator.validateFields(
                  value, ValidationType.cardNumber, context),
              hintText: '123456789413126',
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              accountBalanceProvider.chargeBalance();
            },
            width: double.infinity,
            color: AppColors.mainApp,
            borderRadius: 50,
            child: CustomText(Utils.localization?.recharge_the_balance,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white, fontSize: 20)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        CustomText(Utils.localization?.in_the_wallet,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeightManger.regular,
                                  fontSize: 25,
                                )),
                        Selector<AccountBalanceProvider, double>(
                          selector: (_, provider) => provider.currentBalance,
                          builder: (_, currentBalance, __) {
                            return CustomText(currentBalance.toPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeightManger.bold,
                                        color: AppColors.mainApp,
                                        fontSize: 30));
                          },
                        )
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      onPressed: () {
                        showChargeBalance();
                      },
                      height: 60,
                      width: 160,
                      color: AppColors.mainApp,
                      borderRadius: 5,
                      child: CustomText(
                          Utils.localization?.recharge_the_balance,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontWeight: FontWeightManger.regular,
                                  color: Colors.white,
                                  fontSize: 30)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Material(
                borderRadius: BorderRadius.circular(5),
                elevation: 2,
                color: Colors.white,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(
                      enabled: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: bottomTitles,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: 40,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      // checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xffe7e8ec),
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    groupsSpace: 20,
                    barGroups: getData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      color: Color(
        0xff939393,
      ),
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  LinearGradient get barsGradient => const LinearGradient(
        colors: [
          AppColors.chartLineFirstGradientColor,
          AppColors.chartLineLastGradientColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 10,
            gradient: barsGradient,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 20,
            gradient: barsGradient,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 30,
            gradient: barsGradient,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 15,
            gradient: barsGradient,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
    ];
  }
}
