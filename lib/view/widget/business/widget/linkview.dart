import 'package:any_link_preview/any_link_preview.dart';
import 'package:chatting/Helper/color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class link_view extends StatelessWidget {
  const link_view({
    Key key,
    @required this.Room_Data,
    @required this.myUID,
    this.iscomment=false,
    @required this.isDarkMode,
    @required  this.message_time,
  }) : super(key: key);

  final Map<String, dynamic> Room_Data;
  final String myUID;
  final bool isDarkMode;
  final String message_time;
  final bool iscomment;

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview(
      link: Room_Data['message'],
      displayDirection: uiDirection.uiDirectionVertical,
      showMultimedia: true,
      bodyMaxLines: 5,
      bodyTextOverflow: TextOverflow.ellipsis,
      titleStyle: TextStyle(
        color:iscomment?Theme.of(context).iconTheme.color: Theme.of(context).secondaryHeaderColor,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      bodyStyle: TextStyle(
          color:iscomment?Theme.of(context).iconTheme.color: Theme.of(context).secondaryHeaderColor, fontSize: 12),
      errorBody: 'Show my custom error body',
      errorTitle: 'Show my custom error title',
      errorWidget: Container(
        color: Room_Data['sender'] == myUID
            ? Colors.blue
            : isDarkMode
                ? Colors.blue
                : HexColor.fromHex("#f2f5f6"),
        child: const Text('Oops!'),
      ),
      errorImage: Room_Data['message'],
      cache: const Duration(days: 7),
      backgroundColor: Room_Data['sender'] == myUID
          ? Colors.blue
          : isDarkMode
              ? Colors.blue
              : HexColor.fromHex("#f2f5f6"),

      removeElevation: true,
      onTap: () async {
        if (!await launch(Room_Data['message']))
          throw 'Could not launch ${Room_Data['message']}';
      }, // This disables tap event
    );
  }
}
