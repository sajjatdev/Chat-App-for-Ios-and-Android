import 'package:chatting/Helper/color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Search_box extends StatelessWidget {
  const Search_box({
    Key key,
    @required this.isDarkMode,
    @required this.search,
    @required this.clear,
    @required this.message,
    @required this.textEditingController,
  }) : super(key: key);

  final bool isDarkMode;
  final VoidCallback search;
  final VoidCallback clear;
  final String message;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: (value) => value.isEmpty ? "Enter your Value" : null,
      style:
          TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 12.sp),
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: search,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).iconTheme.color,
            )),
        prefixIcon: IconButton(
            onPressed: clear,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
            )),
        hintText: message,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        hintStyle: TextStyle(
            color: Theme.of(context).iconTheme.color, fontSize: 12.sp),
        fillColor: isDarkMode
            ? HexColor.fromHex("#696969")
            : HexColor.fromHex("#EEEEEF"),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none),
      ),
    );
  }
}
