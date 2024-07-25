import 'package:chat_app/data/remote/firebase_repo.dart';
import 'package:chat_app/pages/message.dart';
import 'package:chat_app/pages/signin/signin.dart';
import 'package:chat_app/widgets/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';


class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String fromId = '';

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  void getFromId() async {
    fromId = await FirebaseRepo.getFromId();
    setState(() {});
  }
  logOutUser() async {
    // session out
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(FirebaseRepo.PREF_USER_ID_KEY, '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.mainBlack,
          body: Padding(
            padding: const EdgeInsets.only(top: 11.0),
            child: Column(
              children: [
                /// this is appbar session
                CustomAppBar(onTap: () {},title: 'Contacts'),


                /// this is login user all contact calls
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(21),
                              topRight: Radius.circular(21))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 11),
                                width: 50,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: AppColors.outlineColor,
                                    borderRadius: BorderRadius.circular(21)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 11, vertical: 5),
                              child: Text('My Contact',
                                  style: mTextStyle20(
                                      mFontWeight: FontWeight.bold,
                                      mColor: AppColors.mainTextColor,
                                      mFontFamily: 'pRegular')),
                            ),
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseRepo.getAllContacts(),
                                builder: (_, snapshots) {
                                  if (snapshots.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshots.hasError) {
                                    return Center(
                                        child: Text(snapshots.error.toString()));
                                  }

                                  if (snapshots.hasData) {
                                    var listContact = List.generate(
                                        snapshots.data!.docs.length, (index) {
                                      return UserModel.fromJson(
                                          snapshots.data!.docs[index].data());
                                    });

                                    listContact.removeWhere(
                                            (element) => element.userId == fromId);

                                    return ListView.builder(
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: listContact.length,
                                        itemBuilder: (_, index) {
                                          var currModel = listContact[index];
                                          return customListTile(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagePage(
                                                              userId: currModel
                                                                  .userId
                                                                  .toString(),
                                                              uName: currModel.name
                                                                  .toString(),
                                                              uProfilePic: currModel
                                                                  .profilePic
                                                                  .toString(),
                                                              uActive: currModel
                                                                  .profileStatus
                                                                  .toString(),
                                                            )));
                                              },
                                              minVerticalPadding: 8,

                                              leadingProfileImg:CircleAvatar(
                                                  radius: 25, backgroundImage: currModel.profilePic!= '' ? NetworkImage(currModel.profilePic!):const AssetImage(AppImages.PROFILE_IMG)),
                                              title: currModel.name!,
                                              subtitle: currModel.mobNo!);
                                        });
                                  } else {
                                    return Center(
                                        child: Text(
                                            'No Contacts yet!,\nStart the conversation today..',
                                            style: mTextStyle16(
                                                mColor: AppColors.secondaryBlack)));
                                  }
                                }),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}

/*class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String fromId = '';

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  void getFromId() async {
    fromId = await FirebaseRepo.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('all Contacts'),
          ),
          body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseRepo.getAllContacts(),
              builder: (_, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshots.hasError) {
                  return Center(child: Text(snapshots.error.toString()));
                }

                if (snapshots.hasData) {
                  var listContact =
                  List.generate(snapshots.data!.docs.length, (index) {
                    return UserModel.fromJson(snapshots.data!.docs[index].data());
                  });

                  listContact.removeWhere((element) => element.userId == fromId);

                  return ListView.builder(
                      itemCount: listContact.length,
                      itemBuilder: (_, index) {
                        var currModel = listContact[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessagePage(
                                              userId: currModel.userId!,
                                              uName: currModel.name!,
                                              uProfilePic: currModel.profilePic!,
                                              uActive:
                                              currModel.isOnline.toString(),
                                            )));
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.outlineColor,
                                    backgroundImage: currModel.profilePic != ''
                                        ? NetworkImage(currModel.profilePic!)
                                        : const AssetImage(AppImages.PROFILE_IMG),
                                  ),
                                  title: Text(currModel.name!),
                                  subtitle: Text(currModel.mobNo!),
                                ),
                              )),
                        );
                      });
                }else{
                  return Center(
                      child: Text(
                          'No Contacts yet!,\nStart the conversation today..',
                          style: mTextStyle16(
                              mColor: AppColors.secondaryBlack)));
                }
              }),
        ));
  }
}*/
