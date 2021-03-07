import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/message_type.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/conversation.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/message.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/auth_service.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/database_services.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/storage_services.dart';
import 'package:flutter_ecommerce_whitelabel/core/view_models/base_view_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../locator.dart';

class ChatViewModel extends BaseViewModel {
  final _dbStorage = DatabaseStorageServices();
  Conversation conversation = Conversation();
  Stream messagesStream;
  final imagePicker = ImagePicker();
  File selectedFile;
  StreamSubscription streamSubscription;
  bool isMe = false;
  Message message ;
  bool imageSend = false;


  final _dbService = locator<DatabaseService>();
  List<Message> messages; //To be removed
  Message msgToBeSent;
  List<Message> messagesList = [];
  List<Message> reversedMessagesList = [];
  final controller = TextEditingController();
  Stream consultationStream;

  ChatViewModel(Conversation conversation) {

    if (conversation != null) {
      doInitialSetup(conversation);
    } else {
    }

  }

  doInitialSetup(Conversation conversation) {
    this.conversation = conversation;
    _getMessagesStream();
    msgToBeSent = Message(senderId: conversation.senderId);
    message = Message(senderId: conversation.senderId,);
  }

  _getMessagesStream() {
    messagesStream = _dbService.getMessagesStream(conversation);
    print('Got messages Stream');
    streamSubscription = messagesStream.listen((event) {
//      print(event.snapshot.value);
      messagesList.add(Message.fromJson(
          new Map<String, dynamic>.from(event.snapshot.value)));
      reversedMessagesList = messagesList.reversed.toList();
      notifyListeners();
    });
  }

  sendMessage() async {
    setState(ViewState.busy);
    if(reversedMessagesList.isNotEmpty ){
    isMe = message.senderId ==
        locator<AuthService>().appUser.id;
    }

    if (msgToBeSent.type == MessageType.image && selectedFile != null) {
      msgToBeSent.fileUrl = await _dbStorage.uploadImage(selectedFile);

    }
    msgToBeSent.timeStamp = DateTime.now().toString();
    conversation.lastMessage = msgToBeSent;
    _dbService.sendMessage(conversation: conversation, message: msgToBeSent, isMe: isMe);
    _dbService.updateConversation(conversation);
    controller.clear();
    msgToBeSent = msgToBeSent = Message(senderId: conversation.senderId);
    setState(ViewState.idle);
  }

  pickImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    print('Picked file from storage: ${pickedFile.path.toString()}');
    if (pickedFile != null) {
      selectedFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  createConversation() async {
    setState(ViewState.busy);
    msgToBeSent.timeStamp = DateTime.now().toString();
    conversation.lastMessage = msgToBeSent ?? "";
    await _dbService.createConversation(conversation);
    setState(ViewState.idle);
  }







  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}
