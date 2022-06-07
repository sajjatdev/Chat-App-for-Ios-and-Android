import 'package:chatting/Helper/color.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class UsernameCreate extends StatefulWidget {
  static const String routeName = '/username_crate';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => UsernameCreate());
  }

  const UsernameCreate({Key key}) : super(key: key);

  @override
  _UsernameCreateState createState() => _UsernameCreateState();
}

class _UsernameCreateState extends State<UsernameCreate> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();

  bool isbtn = false;
  bool btnloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
              SizedBox(
                height: 8.w,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create\nUsername",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  )),
              Spacer(
                flex: 1,
              ),
              Form(
                key: key,
                child: TextFormField(
                  controller: username,
                  validator: (value) =>
                      value.isEmpty ? "Username can't be blank" : null,
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/svg/check-2.svg',
                        width: 5.w,
                        height: 5.w,
                        color:
                            isbtn ? Colors.green : HexColor.fromHex('#5F5F62'),
                      ),
                    ),
                    hintText: "Username (Required)",
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor.fromHex("#D8D8D8")),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor.fromHex("#D8D8D8")),
                    ),
                    hintStyle: TextStyle(color: HexColor.fromHex("#C9C9CB")),
                  ),
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                "The username can be made up of letters (a-z), numbers (0-9) depending on availability. Other users will be able to find you by this username instead of your phone number.\n\n\nMinimum length is 5 characters",
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
              Spacer(
                flex: 2,
              ),
              Button(
                buttonenable: true,
                loadingbtn: btnloading,
                onpress: () async {
                  if (key.currentState.validate()) {
                    setState(() {
                      isbtn = true;
                      btnloading = true;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('username', username.text);
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pushNamed('/profile_Setup');
                    });
                  }
                },
                Texts: "SAVE",
                widths: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
