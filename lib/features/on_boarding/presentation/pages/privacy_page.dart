import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/privacy_provider.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final PrivacyProvider _privacyProvider = context.read<PrivacyProvider>();
  @override
  void initState() {
    _privacyProvider.getPrivacy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomText(
          Utils.localization?.privacy_policy,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
        ),
      ),
      body: Selector<PrivacyProvider, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (_, isLoading, __) {
          if (isLoading) return const LoadingWidget();
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Html(
                data: _privacyProvider.privacy,
                onLinkTap: (url, context, attributes, element) async {
                  final Uri uri = Uri.parse(url ?? '');
                  if (await canLaunchUrl(uri)) {
                    launchUrl(uri);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
