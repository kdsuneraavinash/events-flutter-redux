import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';

/// Creates an Cached Network Image with default placeholder
class DefParameterNetworkImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      placeholder: Image.asset("images/placeholders/banner_placeholder.jpg"),
      errorWidget: Image.asset("images/placeholders/banner_error.png"),
      fit: isCover ? BoxFit.cover : BoxFit.contain,
      height: isCover ? MediaQuery.of(context).size.width/aspectRatio : null,
    );
  }

  DefParameterNetworkImage({this.imageUrl, this.isCover = false});

  final String imageUrl;
  final bool isCover;
  final aspectRatio = 16/9;
}
