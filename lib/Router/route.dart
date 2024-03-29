import 'package:chatting/Loading_page.dart';
import 'package:chatting/view/Screen/auth/loading_view.dart';
import 'package:chatting/view/Screen/business/Comment/Comment_chat.dart';
import 'package:chatting/view/Screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

class Routers {
  static Route onGenerateRoute(RouteSettings settings) {
    print('this is Route:- ${settings.name}');

    switch (settings.name) {
      case '/':
        return Landing_page.route();
      case Home_view.routeName:
        return Home_view.route();
      case welcome.routeName:
        return welcome.route();

      case profile_setup.routeName:
        return profile_setup.route();
      case Loading_view.routeName:
        return Loading_view.route();
      case request.routeName:
        return request.route(RoomId: settings.arguments as String);
      case Feed.routeName:
        return Feed.route(RoomId: settings.arguments as String);
      case AddOwnerwithAdmin.routeName:
        return AddOwnerwithAdmin.route(Getadd: settings.arguments as Map);
      case owner_request.routeName:
        return owner_request.route(room_Id: settings.arguments as String);
      case Business_image_show.routeName:
        return Business_image_show.route(
            imageurl: settings.arguments as String);
      case Create_business.routeName:
        return Create_business.route(
            BUSINESSDATA: settings.arguments as BusinessDetails);
      case privacy_policy.routeName:
        return privacy_policy.route();
      case UsernameCreate.routeName:
        return UsernameCreate.route();
      case Edit_Business_Profile.routeName:
        return Edit_Business_Profile.route(
            Room_ID: settings.arguments as String);
      case Admin_Profile.routeName:
        return Admin_Profile.route(Room_ID: settings.arguments as String);
      case group_profile.routeName:
        return group_profile.route(UIDuser: settings.arguments as String);
      case create_group.routeName:
        return create_group.route(member_list: settings.arguments as List);
      case Seleted_list.routeName:
        return Seleted_list.route();
      case Terms.routeName:
        return Terms.route();
      case Auth_phone.routeName:
        return Auth_phone.route();
      case OTP.routeName:
        return OTP.route(number: settings.arguments as String);
      case Message_contact.routeName:
        return Message_contact.route();
      case Comment_chat.routeName:
        return Comment_chat.route(
            CommentData: settings.arguments as Map<String, dynamic>,
            );
      default:
        return errorRoute();
    }
  }

  static Route errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
            ));
  }
}
