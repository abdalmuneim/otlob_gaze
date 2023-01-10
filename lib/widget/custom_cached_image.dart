import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otlob_gas/common/utils.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage(
      {Key? key, this.url, this.context, this.boxFit})
      : super(key: key);
  final String? url;
  final BuildContext? context;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: (Uri.parse(url ?? "").isAbsolute)
          ? CachedNetworkImage(
              imageUrl: url ?? "",
              fit: (boxFit) ?? BoxFit.contain,
              placeholder: (context, url) => Center(child: Utils.putShimmer),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : const Icon(
              Icons.image,
              color: Colors.blueAccent,
            ),
    );
  }
}
