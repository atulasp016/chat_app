import 'package:chat_app/pages/signin/signin.dart';
import 'package:chat_app/pages/users_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/pages/message.dart';
import 'package:chat_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/user_model.dart';
import '../data/remote/firebase_repo.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';
import '../widgets/ui_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static DateFormat dtFormat = DateFormat.Hm();
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
                  CustomAppBar(
                      onTap: () {
                        logOutUser();
                      },
                      title: 'Home'),

                  /// this is login user all contact chats
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(21),
                              topRight: Radius.circular(21))),
                      child: SingleChildScrollView(
                        child: Column(
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
                            StreamBuilder(
                                stream: FirebaseRepo.getLiveChatContactStream(
                                    fromId: fromId),
                                builder: (_, snapshots) {
                                  if (snapshots.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshots.hasError) {
                                    return Center(
                                        child: Text(snapshots.error.toString()));
                                  } else if (snapshots.hasData) {
                                    var listUserId = List.generate(
                                        snapshots.data!.docs.length, (index) {
                                      var mData = snapshots.data!.docs[index]
                                          .get('ids') as List<dynamic>;

                                      mData.removeWhere(
                                              (element) => element == fromId);
                                      return mData[0];
                                    });
                                    print(listUserId);

                                    return listUserId.isNotEmpty ? ListView.builder(
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: listUserId.length,
                                        itemBuilder: (_, index) {
                                          return FutureBuilder(
                                              future: FirebaseRepo.getUserByUserId(
                                                  userId: listUserId[index]),
                                              builder: (_, userSnap) {
                                                if (userSnap.hasData) {
                                                  var currModel =
                                                  UserModel.fromJson(
                                                      userSnap.data!.data()!);
                                                  return appUserAllChatListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MessagePage(
                                                                    userId: currModel
                                                                        .userId
                                                                        .toString(),
                                                                    uName: currModel
                                                                        .name
                                                                        .toString(),
                                                                    uProfilePic: currModel
                                                                        .profilePic
                                                                        .toString(),
                                                                    uActive: currModel
                                                                        .profileStatus
                                                                        .toString(),
                                                                  )));
                                                    },
                                                    profilePic: currModel
                                                        .profilePic !=
                                                        ''
                                                        ? NetworkImage(currModel
                                                        .profilePic
                                                        .toString())
                                                        : const AssetImage(
                                                        AppImages.PROFILE_IMG),
                                                    titleName:
                                                    currModel.name.toString(),
                                                    subtitleLastMsg: StreamBuilder(
                                                        stream:
                                                        FirebaseRepo.getLastMsg(
                                                            toId: currModel
                                                                .userId!,
                                                            fromId: fromId),
                                                        builder:
                                                            (_, lastMsgSnapshot) {
                                                          if (lastMsgSnapshot
                                                              .hasData) {
                                                            var lastMsg =
                                                            MessageModel.fromJson(
                                                                lastMsgSnapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .data());

                                                            return lastMsg.fromId ==
                                                                fromId
                                                                ? Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .done_all_rounded,
                                                                    color: lastMsg.readAt !=
                                                                        ''
                                                                        ? Colors
                                                                        .green
                                                                        : Colors
                                                                        .grey
                                                                        .withOpacity(0.5),
                                                                    size: 18),
                                                                const SizedBox(
                                                                    width: 8),
                                                                lastMsg.msgType ==
                                                                    0
                                                                    ? Expanded(
                                                                  child: Text(
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      lastMsg.msg!,
                                                                      style: mTextStyle14(mColor: AppColors.secondaryTextColor)),
                                                                )
                                                                    : lastMsg.msg != ''
                                                                    ? Row(
                                                                  children: [
                                                                    Icon(Icons.image, color: Colors.green.withOpacity(0.5), size: 18),
                                                                    Expanded(child: Text(lastMsg.msg!, maxLines: 1, overflow: TextOverflow.ellipsis, style: mTextStyle14(mColor: AppColors.secondaryTextColor))),
                                                                  ],
                                                                )
                                                                    : Row(
                                                                  children: [
                                                                    Icon(Icons.image, color: Colors.green.withOpacity(0.5), size: 18),
                                                                    Expanded(child: Text('Sent a photo', style: mTextStyle14(mColor: AppColors.secondaryTextColor))),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                                : lastMsg.msgType ==
                                                                0
                                                                ? Expanded(
                                                              child: Text(
                                                                  lastMsg
                                                                      .msg!,
                                                                  maxLines:
                                                                  1,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: mTextStyle14(
                                                                      mColor:
                                                                      AppColors.secondaryTextColor)),
                                                            )
                                                                : lastMsg.msg !=
                                                                ''
                                                                ? Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.image,
                                                                    color: Colors.green.withOpacity(0.5),
                                                                    size: 18),
                                                                Expanded(
                                                                  child: Text(
                                                                      lastMsg.msg!,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: mTextStyle14(mColor: AppColors.secondaryTextColor)),
                                                                ),
                                                              ],
                                                            )
                                                                : Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.image,
                                                                    color: Colors.green.withOpacity(0.5),
                                                                    size: 18),
                                                                Expanded(
                                                                  child: Text(
                                                                      'Sent a photo',
                                                                      style: mTextStyle14(mColor: AppColors.secondaryTextColor)),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Container();
                                                        }),
                                                    trailing: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        StreamBuilder(
                                                            stream: FirebaseRepo
                                                                .getLastMsg(
                                                                toId: currModel
                                                                    .userId!,
                                                                fromId: fromId),
                                                            builder:
                                                                (_, lastMsgSnap) {
                                                              if (lastMsgSnap
                                                                  .hasData) {
                                                                var lastMsg =
                                                                MessageModel.fromJson(
                                                                    lastMsgSnap
                                                                        .data!
                                                                        .docs[0]
                                                                        .data());
                                                                var time = dtFormat
                                                                    .format(DateTime
                                                                    .fromMillisecondsSinceEpoch(
                                                                    int.parse(
                                                                        lastMsg.sentAt!)));
                                                                return Text(time,
                                                                    style: mTextStyle12(
                                                                        mColor: AppColors
                                                                            .secondaryTextColor));
                                                              }

                                                              return Container();
                                                            }),
                                                        StreamBuilder(
                                                            stream: FirebaseRepo
                                                                .getUnReadMsgCount(
                                                                toId: currModel
                                                                    .userId!,
                                                                fromId: fromId),
                                                            builder: (_,
                                                                unReadCountSnap) {
                                                              if (unReadCountSnap
                                                                  .hasData &&
                                                                  unReadCountSnap
                                                                      .data!
                                                                      .docs
                                                                      .isNotEmpty) {
                                                                return CircleAvatar(
                                                                  radius: 10,
                                                                  backgroundColor:
                                                                  AppColors
                                                                      .secondaryColor,
                                                                  child: Text(
                                                                    '${unReadCountSnap.data!.docs.length}',
                                                                    style: mTextStyle12(
                                                                        mFontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        mColor: AppColors
                                                                            .whiteColor),
                                                                  ),
                                                                );
                                                              }

                                                              return const SizedBox(
                                                                  width: 0,
                                                                  height: 0);
                                                            }),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return const SizedBox(
                                                    width: 0, height: 0);
                                              });
                                        }): Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No chats found now!!',
                                        style: TextStyle(
                                          color: AppColors.mainTextColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.whiteColor,
            foregroundColor: AppColors.primaryColor,
            splashColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        ));
  }

  Widget appUserAllChatListTile({
    required VoidCallback onTap,
    required profilePic,
    required String titleName,
    required subtitleLastMsg,
    required trailing,
  }) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 16,
      leading: CircleAvatar(radius: 25, backgroundImage: profilePic),
      title: Text(titleName,
          style: mTextStyle18(
              mFontWeight: FontWeight.bold, mColor: AppColors.mainBlack)),
      subtitle: subtitleLastMsg,
      trailing: Container(
          constraints:
          const BoxConstraints(maxWidth: 100), // Adjust maxWidth as needed
          child: trailing),
    );
  }
}
