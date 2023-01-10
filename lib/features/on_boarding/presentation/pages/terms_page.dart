import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/terms_provider.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  late final TermsProvider _termsProvider = context.read<TermsProvider>();
  @override
  void initState() {
    _termsProvider.getTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomText(
          Utils.localization?.terms_conditions,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
        ),
      ),
      body: Selector<TermsProvider, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (_, isLoading, __) {
          if (isLoading) return const LoadingWidget();
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Html(
                data: _termsProvider.terms,
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
