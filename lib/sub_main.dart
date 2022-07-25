import 'package:chatting/Loading_page.dart';
import 'package:chatting/Router/route.dart';
import 'package:chatting/Services/Auth.dart';
import 'package:chatting/Services/Profile_database.dart';
import 'package:chatting/Services/business/business.dart';
import 'package:chatting/Services/business/business_profile.dart';
import 'package:chatting/Services/fireStore.dart';
import 'package:chatting/Services/group/group_services.dart';
import 'package:chatting/Services/location/get_location.dart';
import 'package:chatting/Services/message.dart';
import 'package:chatting/logic/AuthStatus/authstatus_bloc.dart';
import 'package:chatting/logic/Get_message_list/get_message_list_cubit.dart';
import 'package:chatting/logic/Phone_Update/phoneupdate_cubit.dart';
import 'package:chatting/logic/Phone_number_auth/phoneauth_bloc.dart';
import 'package:chatting/logic/business_create/business_create_cubit.dart';
import 'package:chatting/logic/business_hours/business_hours_cubit.dart';
import 'package:chatting/logic/business_location/business_location_cubit.dart';
import 'package:chatting/logic/current_user/cunrrent_user_bloc.dart';
import 'package:chatting/logic/group_create/group_create_cubit.dart';
import 'package:chatting/logic/markers/markers_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/logic/search/search_cubit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:chatting/Helper/theme_data.dart';

import 'Services/Contact/Firebase_contact.dart';

import 'Services/Google Map/SearchMap.dart';
import 'Services/business/getMarker.dart';
import 'Services/business/map_yelp_data/yelp.dart';
import 'logic/BusinessInfoGet/business_info_get_cubit.dart';
import 'logic/Business_profile/business_profile_cubit.dart';
import 'logic/Contact/contact_cubit.dart';
import 'logic/Google_Search/cubit/map_search_cubit.dart';
import 'logic/Profile_data_get/read_data_cubit.dart';
import 'logic/Profile_setup/profile_setup_cubit.dart';
import 'logic/group_profile/group_profile_cubit.dart';
import 'logic/send_message/send_message_cubit.dart';
import 'logic/yelp/yelpapi_cubit.dart';

class Chatting extends StatefulWidget {
  const Chatting({Key key}) : super(key: key);

  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  PhoneauthBloc(AuthProvider(FirebaseAuth.instance))),
          BlocProvider(
              create: (context) =>
                  AuthstatusBloc(AuthProvider(FirebaseAuth.instance))),
          BlocProvider(
              create: (context) =>
                  CunrrentUserBloc(AuthProvider(FirebaseAuth.instance))),
          BlocProvider(create: (context) => PhotouploadCubit(FireStore())),
          BlocProvider(
              create: (context) => ProfileSetupCubit(
                  cloud_FireStore(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  ReadDataCubit(cloud_FireStore(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  SendMessageCubit(messageing(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  GroupCreateCubit(messageing(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  GetMessageListCubit(messageing(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  SearchCubit(cloud_FireStore(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  BusinessLocationCubit(Get_Location())..get_location()),
          BlocProvider(
              create: (context) => BusinessCreateCubit(
                  Business_Services(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) =>
                  MarkersCubit(GetMarker(FirebaseFirestore.instance))
                    ..getMarkersData()),
          BlocProvider(
              create: (context) => GroupProfileCubit(
                  Group_Services(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) => BusinessProfileCubit(
                  Business_Profile_Services(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) => BusinessHoursCubit(
                  Business_Services(FirebaseFirestore.instance))),
          BlocProvider(
              create: (context) => MapSearchCubit(mapsearch: MapServices())),
          BlocProvider(
              create: (context) => BusinessInfoGetCubit(MapServices())),
          BlocProvider(create: (context) => YelpapiCubit(Repositorys.get())),
            BlocProvider(create: (context) => PhoneupdateCubit(AuthProvider(FirebaseAuth.instance))),
          BlocProvider(
              create: (context) => ContactCubit(FirebaseContact())
                ..Getallcontactlist(
                  isSearch: false,
                )),
        ],
        child: MaterialApp(
          title: 'Chatter',
          theme: mytheme.lightTheme,
          darkTheme: mytheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routers.onGenerateRoute,
          initialRoute: Landing_page.routeName,
        ),
      );
    });

    // return Sizer(builder: (context, orientation, deviceType) {
    //   return MultiBlocProvider(
    //     providers: [
    //       BlocProvider(
    //           create: (context) =>
    //               PhoneauthBloc(AuthProvider(FirebaseAuth.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               AuthstatusBloc(AuthProvider(FirebaseAuth.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               CunrrentUserBloc(AuthProvider(FirebaseAuth.instance))),
    //       BlocProvider(create: (context) => PhotouploadCubit(FireStore())),
    //       BlocProvider(
    //           create: (context) => ProfileSetupCubit(
    //               cloud_FireStore(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               ReadDataCubit(cloud_FireStore(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               SendMessageCubit(messageing(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               GroupCreateCubit(messageing(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               GetMessageListCubit(messageing(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               SearchCubit(cloud_FireStore(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               BusinessLocationCubit(Get_Location())..get_location()),
    //       BlocProvider(
    //           create: (context) => BusinessCreateCubit(
    //               Business_Services(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) =>
    //               MarkersCubit(GetMarker(FirebaseFirestore.instance))
    //                 ..getMarkersData()),
    //       BlocProvider(
    //           create: (context) => GroupProfileCubit(
    //               Group_Services(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) => BusinessProfileCubit(
    //               Business_Profile_Services(FirebaseFirestore.instance))),
    //       BlocProvider(
    //           create: (context) => BusinessHoursCubit(
    //               Business_Services(FirebaseFirestore.instance))),
    //     ],
    //     child: MaterialApp(
    //       title: 'Chatter',
    //       useInheritedMediaQuery: true,
    //       locale: DevicePreview.locale(context),
    //       builder: DevicePreview.appBuilder,
    //       theme: mytheme.lightTheme,
    //       darkTheme: mytheme.darkTheme,
    //       themeMode: ThemeMode.system,
    //       debugShowCheckedModeBanner: false,
    //       onGenerateRoute: Routers.onGenerateRoute,
    //       initialRoute: Landing_page.routeName,
    //     ),
    //   );
    // });
  }
}
