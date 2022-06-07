import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class title_widget extends StatelessWidget {
  const title_widget({
    Key key,
    this.title,
    this.onevent,
    this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback onevent;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: onevent,
            icon: SvgPicture.asset('assets/svg/${icon}.svg',
                color: Theme.of(context).iconTheme.color))
      ],
    );
  }
}
