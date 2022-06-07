import 'package:chatting/Helper/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class call_view extends StatefulWidget {
  const call_view({Key key}) : super(key: key);

  @override
  _call_viewState createState() => _call_viewState();
}

class _call_viewState extends State<call_view> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Calls",
                            style: TextStyle(
                                fontSize: 21.sp, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/edit-3.svg',
                                  color: Theme.of(context).iconTheme.color))
                        ],
                      ),
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? "Enter your Value" : null,
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: 12.sp),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).iconTheme.color,
                              )),
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).iconTheme.color,
                              )),
                          hintText: "Search for Calls",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          hintStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12.sp),
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
                      ),
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/customer-service.svg'),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          "You don't have any Calls (yet!)",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
