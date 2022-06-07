import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  const Line({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 10.0,
        child: Center(
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
            height: 0.5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
