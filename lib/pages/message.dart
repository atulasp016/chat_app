import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/message_model.dart';
import '../data/remote/firebase_repo.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class MessagePage extends StatefulWidget {
  String userId;
  String uName;
  String uProfilePic;
  String uActive;
  MessagePage(
      {super.key,
      required this.userId,
      required this.uName,
      required this.uProfilePic,
      required this.uActive});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var messageController = TextEditingController();
  DateFormat dtFormat = DateFormat.Hm();
  List<MessageModel> listMsg = [];
  String fromId = '';

  @override
  void initState() {
    super.initState();
    initializeChatRoom();
  }

  void initializeChatRoom() async {
    fromId = await FirebaseRepo.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leadingWidth: 25,
          title: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.outlineColor,
                backgroundImage: widget.uProfilePic != ''
                    ? NetworkImage(widget.uProfilePic)
                    : const AssetImage(AppImages.PROFILE_IMG),
              ),
              const SizedBox(width: 11),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.uName,
                      style: mTextStyle18(
                          mFontWeight: FontWeight.w500,
                          mColor: AppColors.mainTextColor,
                          mFontFamily: 'mSemiBold')),
                  Text(widget.userId,
                      style: mTextStyle14(
                          mFontWeight: FontWeight.w500,
                          mColor: AppColors.secondaryTextColor,
                          mFontFamily: 'pRegular'))
                ],
              ))
            ],
          ),
          actions: [
            Image.asset(AppImages.IC_AUDIO_CALL,
                width: 25, height: 25, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Image.asset(AppImages.IC_VIDEO_CALL,
                  width: 30, height: 30, fit: BoxFit.fill),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseRepo.getChatStream(
                        toId: widget.userId, fromId: fromId),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      listMsg = List.generate(
                          snapshot.data!.docs.length,
                          (index) => MessageModel.fromJson(
                              snapshot.data!.docs[index].data()));

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                            itemCount: listMsg.length,
                            itemBuilder: (_, index) {
                              return listMsg[index].fromId == fromId
                                  ? userChatBox(listMsg[index])
                                  : anotherUserChatBox(listMsg[index]);
                            });
                      } else {
                        return Center(
                            child: Text(
                                'No Messages yet!,\nStart the conversation today..',
                                style: mTextStyle16(
                                    mColor: AppColors.secondaryTextColor)));
                      }
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                enableSuggestions: true,
                controller: messageController,
                style: mTextStyle16(mColor: AppColors.greyColor),
                decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    filled: true,
                    fillColor: AppColors.secondaryBlack,
                    hintText: 'Write a question',
                    hintStyle: mTextStyle16(mColor: Colors.grey),
                    prefixIcon: const Icon(Icons.mic, color: Colors.grey),
                    suffixIcon: InkWell(
                        onTap: () {
                          if (messageController.text.isNotEmpty) {
                            FirebaseRepo.sendTextMessage(
                                toId: widget.userId,
                                msg: messageController.text);
                            messageController.clear();
                          }
                        },
                        child:
                            const Icon(Icons.send_rounded, color: Colors.grey)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(21))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///userChatBox
  Widget userChatBox(MessageModel msgModel) {
    var time = dtFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)));
    return Row(
      children: [
        Container(width: MediaQuery.of(context).size.width * 0.2),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(11),
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(21),
                topLeft: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: msgModel.msgType == 0
                        ? Text(msgModel.msg!,
                            style: mTextStyle12(
                                mColor: AppColors.whiteColor,
                                mFontWeight: FontWeight.bold))
                        : msgModel.msg != ''
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(msgModel.imgUrl!),
                                  const SizedBox(height: 5),
                                  Text(msgModel.msg!,
                                      maxLines: 2,
                                      style: mTextStyle12(
                                          mColor: AppColors.whiteColor,
                                          mFontWeight: FontWeight.bold))
                                ],
                              )
                            : Image.network(msgModel.imgUrl!)),
                Icon(Icons.done_all_rounded,
                    color: msgModel.readAt != ''
                        ? Colors.green
                        : Colors.grey.withOpacity(0.5),
                    size: 18),
                const SizedBox(width: 8),
                Text(time, style: mTextStyle12(mColor: AppColors.whiteColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///anotherUserChatBox
  Widget anotherUserChatBox(MessageModel msgModel) {
    ///update readStatus
    ///

    if (msgModel.readAt == '') {
      FirebaseRepo.updateReadStatus(
          msgId: msgModel.msgId!, toId: widget.userId, fromId: fromId);
    }

    var time = dtFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)));
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(11),
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(21),
                topLeft: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                        child: msgModel.msgType == 0
                            ? Text(msgModel.msg!,
                                style: mTextStyle14(mColor: Colors.black))
                            : Image.network(msgModel.imgUrl!)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
                          Text(time, style: mTextStyle10(mColor: Colors.black)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(width: MediaQuery.of(context).size.width * 0.2),
      ],
    );
  }
}
