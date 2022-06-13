import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class messageing_widget extends StatelessWidget {
  const messageing_widget({
    Key key,
    @required this.data,
    @required this.myUID,
    @required this.image,
    @required this.profile_data,
  }) : super(key: key);

  final DocumentSnapshot data;
  final Map<String, dynamic> profile_data;
  final String myUID;
  final String image;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    bool ismessage = data['message'] == '';
    String link_check = data['message'];
    bool islink =
        link_check.contains('https://') || link_check.contains('http://');
    return ismessage
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: data['sender'] == myUID
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                data['sender'] == myUID
                    ? Text(
                        Time_Chat.readTimestamp(data['time']),
                        style: TextStyle(color: Colors.grey.shade400),
                      )
                    : GestureDetector(
                        onLongPress: () {
                          // Long Press event add Later
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(profile_data["imageUrl"]),
                        ),
                      ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    constraints: BoxConstraints(maxWidth: 60.w),
                    padding: const EdgeInsets.all(20),
                    decoration:
                        data['message_type'] != 'image' || islink == false
                            ? BoxDecoration(
                                color: data['sender'] == myUID
                                    ? HexColor.fromHex("#1ea1f1")
                                    : isDarkMode
                                        ? HexColor.fromHex("#1a1a1c")
                                        : HexColor.fromHex("#f2f5f6"),
                                borderRadius: data['sender'] == myUID
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30))
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30)))
                            : BoxDecoration(),
                    child: data['message_type'] == 'image'
                        ? CachedNetworkImage(
                            imageUrl: data['message'],
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                CircularProgressIndicator(
                                    color: Theme.of(context).iconTheme.color,
                                    value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : link_check.contains('https://') ||
                                link_check.contains('http://')
                            ? AnyLinkPreview(
                                link: data['message'],
                                displayDirection:
                                    uiDirection.uiDirectionHorizontal,
                                showMultimedia: false,
                                bodyMaxLines: 5,
                                bodyTextOverflow: TextOverflow.ellipsis,
                                titleStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                bodyStyle: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: 12),
                                errorBody: 'Show my custom error body',
                                errorTitle: 'Show my custom error title',
                                errorWidget: Container(
                                  color: data['sender'] == myUID
                                      ? HexColor.fromHex("#1ea1f1")
                                      : isDarkMode
                                          ? HexColor.fromHex("#1a1a1c")
                                          : HexColor.fromHex("#f2f5f6"),
                                  child: const Text('Oops!'),
                                ),
                                errorImage: data['message'],
                                cache: const Duration(days: 7),
                                backgroundColor: data['sender'] == myUID
                                    ? HexColor.fromHex("#1ea1f1")
                                    : isDarkMode
                                        ? HexColor.fromHex("#1a1a1c")
                                        : HexColor.fromHex("#f2f5f6"),

                                removeElevation: true,
                                onTap: () async {
                                  if (!await launch(data['message']))
                                    throw 'Could not launch ${data['message']}';
                                }, // This disables tap event
                              )
                            : Text(data['message'],
                                style: TextStyle(
                                    color: data['sender'] == myUID
                                        ? Theme.of(context).secondaryHeaderColor
                                        : Theme.of(context).iconTheme.color)),
                  ),
                ),
                data['sender'] != myUID
                    ? Text(
                        Time_Chat.readTimestamp(data['time']),
                        style: TextStyle(color: Colors.grey.shade400),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(
                    'assets/svg/read.svg',
                    width: 5.w,
                    height: 5.w,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          );
  }
}
