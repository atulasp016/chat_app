import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';

class FirebaseRepo {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static const String COLLECTION_USERS = 'users';
  static const String COLLECTION_CHATROOM = 'chats';
  static const String COLLECTION_MESSAGES = 'messages';
  static const String PREF_USER_ID_KEY = 'userId';

  Future<void> createUser({required UserModel user, required String pass}) async {
    try {
      var userCred = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!, password: pass);

      if (userCred.user != null) {
        user.userId = userCred.user!.uid;
        await firebaseFirestore
            .collection(COLLECTION_USERS)
            .doc(userCred.user!.uid)
            .set(user.toMap())
            .catchError((error) {
          throw (Exception('Error: $error'));
        });
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String?);
      throw (Exception('Error: $e'));
    } catch (e) {
      throw (Exception('Error: $e'));
    }
  }

  Future<void> loginUser({required String email, required String pass}) async {
    try {
      var userCred = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);

      if (userCred.user != null) {
        // Add user id in SharedPreferences
        var prefs = await SharedPreferences.getInstance();
        prefs.setString(PREF_USER_ID_KEY, userCred.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String?);
      throw (Exception('Error: Invalid Username or Password!!'));
    } catch (e) {
      throw (Exception('Error: $e'));
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllContacts() {
    return firebaseFirestore.collection(COLLECTION_USERS).get();
  }

  static Future<String> getFromId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(PREF_USER_ID_KEY) ?? '';
  }

  static String getChatId({required String fromId, required String toId}) {
    if (fromId.hashCode <= toId.hashCode) {
      return "${fromId}_$toId";
    } else {
      return "${toId}_$fromId";
    }
  }

  static Future<void> sendTextMessage({required String toId, required String msg}) async {
    String fromId = await getFromId();
    var chatId = getChatId(fromId: fromId, toId: toId);

    // Ensure the chat room exists
    await ensureChatRoomExists(chatId, fromId, toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
        msgId: currTime,
        msg: msg,
        sentAt: currTime,
        fromId: fromId,
        toId: toId);

    await firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .doc(currTime)
        .set(msgModel.toMap());
  }

  static Future<void> sendImageMessage({required String toId, required String imgUrl, String msg = ''}) async {
    String fromId = await getFromId();
    var chatId = getChatId(fromId: fromId, toId: toId);

    // Ensure the chat room exists
    await ensureChatRoomExists(chatId, fromId, toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
        msgId: currTime,
        msg: msg,
        sentAt: currTime,
        fromId: fromId,
        toId: toId,
        msgType: 1,
        imgUrl: imgUrl);

    await firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .doc(currTime)
        .set(msgModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream({required String toId, required String fromId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);

    return firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .snapshots();
  }

  static Future<void> ensureChatRoomExists(String chatId, String fromId, String toId) async {
    var chatRoomDoc = firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatId);

    var chatRoomSnapshot = await chatRoomDoc.get();
    if (!chatRoomSnapshot.exists) {
      await chatRoomDoc.set({
        'ids': [fromId, toId],
      });
      debugPrint('Chat room created with ID: $chatId');
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLiveChatContactStream({required String fromId}) {
    debugPrint('From ID: $fromId');
    try {
      var query = firebaseFirestore
          .collection(COLLECTION_CHATROOM)
          .where('ids', arrayContains: fromId);

      debugPrint('Query created: ${query.toString()}');
      return query.snapshots();
    } catch (e) {
      debugPrint('Error querying Firestore: $e');
      return Stream.error(e);
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUserId({required String userId}) {
    return firebaseFirestore.collection(COLLECTION_USERS).doc(userId).get();
  }

  static Future<void> updateReadStatus({required String msgId, required String toId, required String fromId}) async {
    var currTime = DateTime.now().millisecondsSinceEpoch.toString();
    var chatId = getChatId(fromId: fromId, toId: toId);
    await firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .doc(msgId)
        .update({'readAt': currTime});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMsg({required String toId, required String fromId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);
    debugPrint(chatId);
    return firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots();

  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUnReadMsgCount({required String toId, required String fromId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);
    debugPrint(chatId);
    return firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .where('readAt', isEqualTo:  '')
    .where('fromId', isEqualTo: toId)
        .snapshots();

  }

  static Future<UserModel?> getUserDetails(String userId) async {
    try {
      var userDoc = await firebaseFirestore.collection(COLLECTION_USERS).doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
    }
    return null;
  }

}
