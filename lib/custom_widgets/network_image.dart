import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Creates an Cached Network Image with default placeholder
class DefParameterNetworkImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      placeholder: Image.asset("images/placeholders/banner_placeholder.jpg"),
      errorWidget: Image.asset("images/placeholders/banner_error.png"),
      fit: BoxFit.fitWidth,
    );
  }

  DefParameterNetworkImage({this.imageUrl});
  final String imageUrl;
}
