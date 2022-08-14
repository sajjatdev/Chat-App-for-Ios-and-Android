// import 'dart:io';

// import 'package:chatting/Helper/color.dart';
// import 'package:chatting/main.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:chatting/logic/business_create/business_create_cubit.dart';
// import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
// import 'package:chatting/view/widget/widget.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:sizer/sizer.dart';

// class Create_business_Profile extends StatefulWidget {
//   static const String routeName = '/create_business_profile';

//   static Route route({Map<dynamic, dynamic> data}) {
//     return MaterialPageRoute(
//         settings: RouteSettings(name: routeName),
//         builder: (_) => Create_business_Profile(
//               data: data,
//             ));
//   }

//   const Create_business_Profile({Key key, this.data}) : super(key: key);
//   final Map<dynamic, dynamic> data;
//   @override
//   State<Create_business_Profile> createState() =>
//       _Create_business_ProfileState();
// }

// class _Create_business_ProfileState extends State<Create_business_Profile> {
//   String path;
//   String name;
//   String myuid;
//   bool btnen = false;
//   bool is_loading = false;
//   bool has_path = false;
//   TextEditingController Business_name = TextEditingController();
//   TextEditingController description = TextEditingController();

//   String address;
//   var latitude;
//   var longitude;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getsomedata();
//   }

//   void getsomedata() {
//     setState(() {
//       myuid = sharedPreferences.getString('uid');
//       address = widget.data['address'];
//       latitude = widget.data['latitude'];
//       longitude = widget.data['longitude'];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isDarkMode = brightness == Brightness.dark;
//     return LoadingOverlay(
//       isLoading: is_loading,
//       child: Scaffold(
//         appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: Theme.of(context).iconTheme.color,
//               ),
//             )),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       "Create\nbusiness",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                           fontSize: 30.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).iconTheme.color),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.w,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       final result = await FilePicker.platform.pickFiles(
//                         allowMultiple: false,
//                         type: FileType.image,
//                       );

//                       if (result != null) {
//                         setState(() {
//                           path = result.files.single.path;
//                           name = result.files.single.name;
//                           has_path = true;
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: 15.w,
//                       height: 15.w,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).iconTheme.color,
//                           borderRadius: BorderRadius.circular(50)),
//                       child: has_path
//                           ? CircleAvatar(
//                               radius: 25.sp,
//                               backgroundImage: FileImage(
//                                 File(path),
//                               ),
//                             )
//                           : SvgPicture.asset(
//                               'assets/svg/Shape_group.svg',
//                               color: Theme.of(context).iconTheme.color,
//                             ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.w,
//                   ),
//                   Container(
//                     height: 40.w,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: isDarkMode
//                             ? HexColor.fromHex("#1a1a1c")
//                             : HexColor.fromHex("#ffffff"),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 25, vertical: 10),
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: Business_name,
//                             validator: (value) =>
//                                 value.isEmpty ? "Name can't be blank" : null,
//                             onSaved: (value) {
//                               print(value);
//                             },
//                             onChanged: (value) {
//                               setState(() {
//                                 btnen = value.isNotEmpty;
//                               });
//                             },
//                             style: TextStyle(
//                                 color: Theme.of(context).iconTheme.color),
//                             decoration: InputDecoration(
//                               hintText: "Business Name (Mandatory)",
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: HexColor.fromHex("#D8D8D8")),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: HexColor.fromHex("#D8D8D8")),
//                               ),
//                               hintStyle:
//                                   TextStyle(color: HexColor.fromHex("#C9C9CB")),
//                             ),
//                           ),
//                           TextFormField(
//                             controller: description,
//                             validator: (value) =>
//                                 value.isEmpty ? "Name can't be blank" : null,
//                             onSaved: (value) {
//                               print(value);
//                             },
//                             style: TextStyle(
//                                 color: Theme.of(context).iconTheme.color),
//                             decoration: InputDecoration(
//                               hintText: "Description (Optional)",
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: HexColor.fromHex("#D8D8D8")),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: HexColor.fromHex("#D8D8D8")),
//                               ),
//                               hintStyle:
//                                   TextStyle(color: HexColor.fromHex("#C9C9CB")),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.w,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         address,
//                         style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).iconTheme.color),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.w,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       "Enter your business location to see if there is already Hangout spot created for your business.",
//                       style: TextStyle(color: HexColor.fromHex("#707070")),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40.w,
//                   ),
//                   Button(
//                     loadingbtn: false,
//                     buttonenable: btnen ? true : false,
//                     // buttonenable:
//                     //     Business_name.text != null && path != null ? true : false,
//                     onpress: () {
//                       if (Business_name.text != null) {
//                         setState(() {
//                           is_loading = true;
//                         });
//                         if (path != null) {
//                           context
//                               .read<PhotouploadCubit>()
//                               .updateData(path, name,
//                                   Business_name.text.replaceAll(" ", ''))
//                               .then((value) async {
//                             try {
//                               String imagurl = await firebase_storage
//                                   .FirebaseStorage.instance
//                                   .ref(
//                                       'userimage/${Business_name.text.replaceAll(" ", '')}/${name}')
//                                   .getDownloadURL();

//                               // context
//                               //     .read<BusinessCreateCubit>()
//                               //     .Create_Business(
//                               //       address: address,
//                               //       description: description.text,
//                               //       latitude: latitude,
//                               //       longitude: longitude,
//                               //       imageURl: imagurl ?? Business_name.text,
//                               //       Business_Name: Business_name.text,
//                               //       Business_Id:
//                               //           Business_name.text.replaceAll(" ", ''),
//                               //       owner: myuid,
//                               //       type: 'business',
//                               //     )
//                               //     .then((value) {
//                               //   Navigator.of(context).pushReplacementNamed(
//                               //       '/messageing',
//                               //       arguments: {
//                               //         'otheruid': Business_name.text
//                               //             .replaceAll(" ", '')
//                               //             .toString(),
//                               //         'type': 'business',
//                               //       });
//                               });
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(e.toString())));
//                             }
//                           });
//                         } else {
//                           // context.read<BusinessCreateCubit>().Create_Business(
//                           //       address: address,
//                           //       description: description.text,
//                           //       latitude: latitude,
//                           //       longitude: longitude,
//                           //       imageURl: Business_name.text,
//                           //       Business_Name: Business_name.text,
//                           //       Business_Id:
//                           //           Business_name.text.replaceAll(" ", ''),
//                           //       owner: myuid,
//                           //       type: 'business',
//                           //     );

//                           Navigator.of(context)
//                               .pushReplacementNamed('/messageing', arguments: {
//                             'otheruid': Business_name.text
//                                 .replaceAll(" ", '')
//                                 .toString(),
//                             'type': 'business',
//                           });
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                                 content: Text(
//                           'Enter you Correct Information',
//                         )));
//                       }
//                     },
//                     Texts: "CREATE BUSINESS",
//                     widths: 80,
//                   ),
//                   SizedBox(
//                     height: 5.w,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       "By tapping on “Create” I acknowledge that I am the owner of this business/franchise.",
//                       style: TextStyle(color: HexColor.fromHex("#707070")),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
