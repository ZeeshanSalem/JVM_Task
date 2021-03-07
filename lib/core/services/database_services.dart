import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/conversation.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/message.dart';
import '../models/app_user.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final firebaseDbRef = FirebaseDatabase.instance.reference().child('evaluation');
  static final DatabaseService _singleton = DatabaseService._internal();

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();


  ///
  /// THis method to save User Data if not saved
  ///
  registerUser(AppUser user) async{
    try{
      await _db.collection("users").doc(user.id).set(user.toJson());
    }catch(e, s){
      print('Exception @DatabaseService/registerUser :$e');
      print(s);
    }
  }
  ///
  /// This method is used for user id
  ///
  Future<AppUser> getUser(id) async {
    try {
      final snapshot = await _db.collection('users').doc(id).get();
      print('User Data: ${snapshot.data()}');
      return AppUser.fromJson(snapshot.data(), snapshot.id);
    } catch (e, s) {
      print('Exception @DatabaseService/getUser :$e');
      print(s);
      return null;
    }
  }

  ///
  /// Update User Profile
  ///
  updateUserProfile(AppUser appUser) async {
    await _db
        .collection('users')
        .doc(appUser.id)
        .update(appUser.toJson());
  }
  
  ///
  /// getAllUser
  ///
  Future<List<AppUser>> getAllUser(id) async{
    List<AppUser> users = [];
    try{
      final snapshot = await _db.collection("users")
      .where('id', isNotEqualTo:  id)
      .get();
      if(snapshot.docs.length > 0){
        for(int i = 0 ; i < snapshot.docs.length; i++){
          users.add(AppUser.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
        }
      }
      return users;
    }catch(e, s){
      print("@getAllUser Exception $e");
      print(s);
    }
    
  }

//  getAllConversations() {
//    try {
//      firebaseDbRef.child('conversations').onChildAdded.listen((Event event) {
//        print(event.snapshot.value.toString());
//      });
//    } catch (e) {
//      print('Exception @getConversationsStream: $e');
//    }
//  }

//
  getConversationsStream(id) {
    Stream stream;
    try {
      stream = firebaseDbRef
          .child('conversations')
          .orderByChild('receiverId')
          .equalTo(id)
          .onChildAdded;
      return stream;
    } catch (e) {
      print('Exception @getConversationsStream: $e');
    }
  }

  sendMessage({Message message, Conversation conversation, bool isMe}) {
    print('@createConversation');
    try {
      firebaseDbRef
          .child('chatMessages')
          .child(isMe? '${conversation.receiverId}_${conversation.senderId}': '${conversation.senderId}_${conversation.receiverId}' )
          .push()
          .set(message.toJson());
    } catch (e) {
      print('Exception @getConversationsStream: $e');
    }
  }

  updateConversation(Conversation conversation) {
    print('@updateConversation');
    try {
      firebaseDbRef
          .child('conversations')
          .child('${conversation.receiverId}_${conversation.senderId}')
          .update(conversation.toJson());
    } catch (e) {
      print('Exception @getConversationsStream: $e');
    }
  }

  createConversation(Conversation conversation) {
    print('@createConversation');
    try {
      firebaseDbRef
          .child('conversations')
          .child('${conversation.receiverId}_${conversation.senderId}')
          .set(conversation.toJson());
    } catch (e) {
      print('Exception @getConversationsStream: $e');
    }
  }


  getMessagesStream(Conversation conversation) {
    print('@getMessagesStream with Conversation: ${conversation.toJson()}');
    Stream stream;
    try {
      stream = firebaseDbRef
          .child('chatMessages')
          .child('${conversation.receiverId}_${conversation.senderId}')
          .limitToLast(15)
          .onChildAdded;
      return stream;
    } catch (e) {
      print('Exception @getConversationsStream: $e');
    }
  }
  






}
