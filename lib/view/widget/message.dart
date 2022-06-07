import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class message_widget extends StatelessWidget {
  const message_widget({
    Key key,
    this.icon,
    this.title,
  }) : super(key: key);

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/${icon}.svg'),
          SizedBox(
            height: 5.w,
          ),
          Text(
            "You don't have any ${title} (yet!)",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ],
      ),
    );
  }
}
