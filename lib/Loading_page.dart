import 'package:chatting/Services/Auth.dart';
import 'package:chatting/logic/AuthStatus/authstatus_bloc.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/Screen/auth/loading_view.dart';
import 'package:chatting/view/Screen/screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Landing_page extends StatefulWidget {
  const Landing_page({
    Key key,
  }) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Landing_page());
  }

  @override
  _Landing_pageState createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page> {
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider(
        create: (context) =>
            AuthstatusBloc(AuthProvider(FirebaseAuth.instance)));
    setState(() {
      uid = sharedPreferences.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadingstaus = context.watch<AuthstatusBloc>().state;
    return LoadingOverlay(
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      isLoading: uid == null
          ? false
          : loadingstaus is UserStatus
              ? loadingstaus.authstatuscheck == true
                  ? false
                  : true
              : true,
      child: BlocBuilder<AuthstatusBloc, AuthstatusState>(
        builder: (context, state) {
          if (state is statusloding) {
            return Loading_view();
          } else if (state is UserStatus) {
            if (state.authstatuscheck == true) {
              if (uid != null) {
                return Home_view();
              } else {
                return profile_setup();
              }
            } else {
              return welcome();
            }
          } else {
            return Loading_view();
          }
        },
      ),
    );
  }
}
