import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class Edit_Business_Profile extends StatefulWidget {
  static const String routeName = '/business_profile_edit';

  static Route route({String Room_ID}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Edit_Business_Profile(
              Room_ID: Room_ID,
            ));
  }

  final String Room_ID;
  const Edit_Business_Profile({Key key, this.Room_ID}) : super(key: key);

  @override
  State<Edit_Business_Profile> createState() => _Edit_Business_ProfileState();
}

class _Edit_Business_ProfileState extends State<Edit_Business_Profile> {
  var _value = 1;
  List<String> item = ['a', 'v', 's'];
  final hours = [
    '12:00 AM',
    '12:30 AM',
    '1:00 AM',
    '1:30 AM',
    '2:00 AM',
    '2:30 AM',
    '3:00 AM',
    '3:30 AM',
    '4:00 AM',
    '4:30 AM',
    '5:00 AM',
    '5:30 AM',
    '6:00 AM',
    '6:30 AM',
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
    '24 Hours',
  ];
  String mon_open = "8:00 AM", mon_cls = "9:00 PM";
  String tu_open = "8:00 AM", tu_cls = "9:00 PM";
  String we_open = "8:00 AM", we_cls = "9:00 PM";
  String th_open = "8:00 AM", th_cls = "9:00 PM";
  String fr_open = "8:00 AM", fr_cls = "9:00 PM";
  String sa_open = "8:00 AM", sa_cls = "9:00 PM";
  String sun_open = "8:00 AM", sun_cls = "9:00 PM";
  List days = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  bool moncheck = false,
      tucheck = false,
      wecheck = false,
      thcheck = false,
      frcheck = false,
      sacheck = false,
      suncheck = false;

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    List openhr = [
      mon_open,
      tu_open,
      we_open,
      th_open,
      fr_open,
      sa_open,
      sun_open
    ];
    List clshr = [mon_cls, tu_cls, we_cls, th_cls, fr_cls, sa_cls, sun_cls];
    List IsCheckBox = [
      moncheck,
      tucheck,
      wecheck,
      thcheck,
      frcheck,
      sacheck,
      suncheck,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          "Edit Page",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        actions: [
          Theme(
            data: ThemeData(splashColor: Theme.of(context).iconTheme.color),
            child: isloading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      for (var i = 0; i < days.length; i++) {
                        FirebaseFirestore.instance
                            .collection('chat')
                            .doc(widget.Room_ID)
                            .collection("Business_Hours")
                            .doc(days[i])
                            .set({
                          "ID": days[i],
                          'open': openhr[i].contains("24 Hours")
                              ? "24"
                              : IsCheckBox[i]
                                  ? mon_open
                                  : "Off",
                          'cls': openhr[i].contains("24 Hours")
                              ? "24"
                              : IsCheckBox[i]
                                  ? clshr[i]
                                  : "Off"
                        });
                      }

                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text("Save",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.w,
            ),
            // Photo show Start

            Container(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.Room_ID)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> businessimage = snapshot.data.data();
                      return CircleAvatar(
                          radius: 30.sp,
                          backgroundImage:
                              NetworkImage(businessimage['imageURl']));
                    } else {
                      return CircleAvatar();
                    }
                  }),
            ),

            // photo Show END

            // Photo Upload Button Start
            TextButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'gif']);

                if (result != null) {
                  final path = result.files.single.path;
                  final name = result.files.single.name;
                  context
                      .read<PhotouploadCubit>()
                      .updateData(path, name, name)
                      .then((value) async {
                    String imagurl = await firebase_storage
                        .FirebaseStorage.instance
                        .ref('userimage/${name}/${name}')
                        .getDownloadURL();

                    if (imagurl != null) {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection('chat')
                            .doc(widget.Room_ID)
                            .update({'imageURl': imagurl});
                      });
                    }
                  });
                }
              },
              child: Text(
                "Set New Display Photo",
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),

            // photo Upload Button End Section
            SizedBox(
              height: 5.w,
            ),
            // Show Details Container Section Start

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(widget.Room_ID)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> businessInfo = snapshot.data.data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        height: 30.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: isDarkMode
                                ? HexColor.fromHex("#1a1a1c")
                                : HexColor.fromHex("#ffffff"),
                            borderRadius: BorderRadius.circular(15.sp)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    capitalize(businessInfo['Business_Name']),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) => Edit_Text(
                                                      appbar_Title: "Name Edit",
                                                      Room_Id: widget.Room_ID,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 6.w,
                                child: const Divider(
                                  height: 1,
                                  color: Color.fromARGB(255, 223, 223, 223),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    child: Text(
                                      businessInfo['description'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) => Edit_Text(
                                                      appbar_Title:
                                                          "Description Edit",
                                                      Room_Id: widget.Room_ID,
                                                      istitle: false,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: CupertinoActivityIndicator(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    );
                  }
                }),

            // End Details Section
            SizedBox(
              height: 5.w,
            ),
            // Start Hours Section

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BUSINESS HOURS"),
                  SizedBox(
                    height: 2.5.w,
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 20.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? HexColor.fromHex("#1a1a1c")
                            : HexColor.fromHex("#ffffff"),
                        borderRadius: BorderRadius.circular(15.sp)),
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                                value: 1,
                                groupValue: _value,
                              ),
                              Text("Open on selected hours")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                                value: 2,
                                groupValue: _value,
                              ),
                              Text("Always Open")
                            ],
                          ),
                          _value == 2
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(right: 10.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: moncheck,
                                            onChanged: (value) {
                                              setState(() {
                                                moncheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Monday",
                                            style: TextStyle(
                                                color: moncheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: moncheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      mon_open = value;
                                                    });
                                                  },
                                            value: mon_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: moncheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: moncheck != true
                                                ? null
                                                : mon_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          mon_cls = value;
                                                        });
                                                      },
                                            value: mon_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: mon_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : moncheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: tucheck,
                                            onChanged: (value) {
                                              setState(() {
                                                tucheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Tuesday",
                                            style: TextStyle(
                                                color: tucheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: tucheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      tu_open = value;
                                                    });
                                                  },
                                            value: tu_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: tucheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: tucheck != true
                                                ? null
                                                : tu_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          tu_cls = value;
                                                        });
                                                      },
                                            value: tu_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: tu_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : tucheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: wecheck,
                                            onChanged: (value) {
                                              setState(() {
                                                wecheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Wednesday",
                                            style: TextStyle(
                                                color: wecheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: wecheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      we_open = value;
                                                    });
                                                  },
                                            value: we_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: wecheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: wecheck != true
                                                ? null
                                                : we_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          we_cls = value;
                                                        });
                                                      },
                                            value: we_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: we_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : wecheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: thcheck,
                                            onChanged: (value) {
                                              setState(() {
                                                thcheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Thursday",
                                            style: TextStyle(
                                                color: thcheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: thcheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      th_open = value;
                                                    });
                                                  },
                                            value: th_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: thcheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: thcheck != true
                                                ? null
                                                : th_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          th_cls = value;
                                                        });
                                                      },
                                            value: th_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: th_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : thcheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: frcheck,
                                            onChanged: (value) {
                                              setState(() {
                                                frcheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Friday",
                                            style: TextStyle(
                                                color: frcheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: frcheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      fr_open = value;
                                                    });
                                                  },
                                            value: fr_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: frcheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: frcheck != true
                                                ? null
                                                : fr_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          fr_cls = value;
                                                        });
                                                      },
                                            value: fr_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: fr_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : frcheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: sacheck,
                                            onChanged: (value) {
                                              setState(() {
                                                sacheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Saturday",
                                            style: TextStyle(
                                                color: sacheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: sacheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      sa_open = value;
                                                    });
                                                  },
                                            value: sa_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: sacheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: sacheck != true
                                                ? null
                                                : sa_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          sa_cls = value;
                                                        });
                                                      },
                                            value: sa_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: sa_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : sacheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            activeColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            value: suncheck,
                                            onChanged: (value) {
                                              setState(() {
                                                suncheck = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Sunday",
                                            style: TextStyle(
                                                color: suncheck
                                                    ? Theme.of(context)
                                                        .iconTheme
                                                        .color
                                                    : Colors.grey),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: suncheck != true
                                                ? null
                                                : (String value) {
                                                    setState(() {
                                                      sun_open = value;
                                                    });
                                                  },
                                            value: sun_open,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: suncheck
                                                          ? Theme.of(context)
                                                              .iconTheme
                                                              .color
                                                          : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                          // Hours

                                          DropdownButton<String>(
                                            onChanged: suncheck != true
                                                ? null
                                                : sun_open.contains("24 Hours")
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          sun_cls = value;
                                                        });
                                                      },
                                            value: sun_cls,
                                            items: hours.map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: sun_open.contains(
                                                              "24 Hours")
                                                          ? Colors.grey
                                                          : suncheck
                                                              ? Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                              : Colors.grey),
                                                ),
                                                value: value,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    return Theme.of(context).iconTheme.color;
  }
}

class Edit_Text extends StatefulWidget {
  const Edit_Text(
      {Key key, this.appbar_Title, this.Room_Id, this.istitle = true})
      : super(key: key);
  final String appbar_Title;
  final String Room_Id;
  final bool istitle;

  @override
  State<Edit_Text> createState() => _Edit_TextState();
}

class _Edit_TextState extends State<Edit_Text> {
  TextEditingController value = TextEditingController();
  bool isloadingbtn = false;

  @override
  void dispose() {
    // TODO: implement dispose
    value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.appbar_Title,
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          isloadingbtn == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      isloadingbtn = true;
                    });
                    if (value.text != '') {
                      FirebaseFirestore.instance
                          .collection('chat')
                          .doc(widget.Room_Id)
                          .update(widget.istitle
                              ? {"Business_Name": value.text}
                              : {"description": value.text})
                          .then((value) {
                        Navigator.of(context).pop();
                        setState(() {
                          isloadingbtn = false;
                        });
                      });
                    }
                    setState(() {
                      isloadingbtn = false;
                    });
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ))
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(children: [
            TextFormField(
              onFieldSubmitted: (_) {
                setState(() {
                  isloadingbtn = true;
                });
                if (value.text != '') {
                  FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.Room_Id)
                      .update(widget.istitle
                          ? {"Business_Name": value.text}
                          : {"description": value.text})
                      .then((value) {
                    Navigator.of(context).pop();
                    setState(() {
                      isloadingbtn = false;
                    });
                  });
                }
                setState(() {
                  isloadingbtn = false;
                });
              },
              textInputAction: TextInputAction.done,
              controller: value,
              validator: (value) => value.isEmpty
                  ? widget.istitle
                      ? "Add Business name"
                      : "Add Description"
                  : null,
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText:
                    widget.istitle ? "Add Business name" : "Add Description",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            ),
          ]),
        ),
      ),
    );
  }
}
