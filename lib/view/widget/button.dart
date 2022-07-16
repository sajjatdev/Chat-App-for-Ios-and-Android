import 'package:chatting/Helper/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Button extends StatelessWidget {
  final VoidCallback onpress;
  final String Texts;
  final double widths;
  final bool loadingbtn;
  final bool buttonenable;
  final Color color;
  final bool addcolor;
  Button(
      {this.onpress,
      this.Texts,
      this.widths,
      this.loadingbtn = false,
      this.buttonenable = false,
      this.color = Colors.red,
      this.addcolor = false});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return InkWell(
      onTap: buttonenable ? onpress : null,
      child: Container(
        height: 5.h,
        width: widths.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: addcolor
                ? color
                : buttonenable
                    ? isDarkMode
                        ? HexColor.fromHex("#ffffff")
                        : HexColor.fromHex("#000000")
                    : Colors.grey,
            borderRadius: BorderRadius.circular(5.0)),
        child: loadingbtn
            ? CupertinoActivityIndicator(
                color: Theme.of(context).secondaryHeaderColor,
              )
            : Text(
                '${Texts}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
      ),
    );
  }
}
