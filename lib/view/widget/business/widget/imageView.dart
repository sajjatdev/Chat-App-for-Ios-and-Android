import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Image_view extends StatelessWidget {
  const Image_view({
    Key key,
    this.Room_Data,
    this.myUID,
    this.isDarkMode,
    this.message_time,
  }) : super(key: key);
  final Map<String, dynamic> Room_Data;
  final String myUID;
  final bool isDarkMode;
  final int message_time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/business_image_show', arguments: Room_Data['message']);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          width: double.infinity,
          height: 70.w,
          fit: BoxFit.cover,
          imageUrl: Room_Data['message'],
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
