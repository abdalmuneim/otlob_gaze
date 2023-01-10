import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/rate_service/presentation/provider/rate_service_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:otlob_gas/widget/notification_button_widget.dart';
import 'package:provider/provider.dart';

class RateServicePage extends StatefulWidget {
  const RateServicePage({super.key, required this.orderId});
  final String orderId;
  @override
  State<RateServicePage> createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  late final RateServiceProvider _rateServiceProvider =
      context.read<RateServiceProvider>();
  @override
  void initState() {
    _rateServiceProvider.initRateServicePage(widget.orderId);
    super.initState();
  }

  @override
  void dispose() {
    _rateServiceProvider.disposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.mainApp,
        title: Text(
          Utils.localization?.delivery_service_rating ?? "",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeightManger.bold),
        ),
        centerTitle: false,
        actions: const [
          NotificationButton(),
          SizedBox(width: 10.0),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 70),

            /// head image review
            Image.asset(Assets.rate),
            const SizedBox(height: 50.0),

            /// rating builder
            Consumer<RateServiceProvider>(
              builder: (_, provider, __) => RatingBar(
                initialRating: provider.rating,
                minRating: 1,
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                ratingWidget: RatingWidget(
                    empty: SvgPicture.asset(
                      Assets.starOutlined,
                    ),
                    full: SvgPicture.asset(
                      Assets.starFilled,
                    ),
                    half: const SizedBox()),
                unratedColor: Colors.grey,
                onRatingUpdate: (rating) {
                  provider.setRating = rating;
                },
              ),
            ),
            // rating text
            const SizedBox(height: 10.0),
            CustomText(
              Utils.localization?.delivery_service_rating ?? '',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeightManger.bold,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 10.0),

            /// review form filed
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 140,
                child: CustomTextField(
                  isMultiLine: true,
                  textEditingController:
                      context.read<RateServiceProvider>().commentController,
                  hintText: Utils.localization?.your_review_for_evaluation,
                  hintStyle:
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeightManger.regular,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                ),
              ),
            ),

            /// confirm review button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomButton(
                  height: 45,
                  width: double.infinity,
                  onPressed: () =>
                      context.read<RateServiceProvider>().addRating(),
                  color: AppColors.mainApp,
                  child: Text(
                    Utils.localization?.confirm_rating ?? "",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeightManger.regular,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                  )),
            ),
            const SizedBox(height: 8.0),

            // rating anther time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomButton(
                  height: 45,
                  width: double.infinity,
                  onPressed: () {
                    context.pop();
                  },
                  color: Colors.white,
                  borderColor: AppColors.mainApp,
                  child: Text(
                    Utils.localization?.rate_later ?? "",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeightManger.regular,
                          color: AppColors.mainApp,
                          fontSize: 18,
                        ),
                  )),
            ),
            const SizedBox(height: 100),
          ]),
        ),
      ),
    );
  }
}
