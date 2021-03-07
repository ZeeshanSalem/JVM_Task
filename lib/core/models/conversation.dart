import 'dart:core';

import 'package:flutter_ecommerce_whitelabel/core/models/app_user.dart';

import 'message.dart';

class Conversation {
  String id;
  String receiverId;
  String senderId;
  Message lastMessage;
  bool isReadReceiver;
  bool isReadSender;
  AppUser receiverProfile;
  AppUser senderProfile;

  Conversation(
      {this.id,
        this.receiverId,
        this.senderId,
        this.lastMessage,
        this.isReadReceiver,
        this.isReadSender});

  Conversation.fromJson(json) {
    this.id = json['id'];
    this.receiverId = json['receiverId'];
    this.senderId = json['senderId'];
    this.isReadReceiver = json['isReadReceiver'];
    this.isReadSender = json['isReadSender'];
    this.lastMessage =
        Message.fromJson(new Map<String, dynamic>.from(json['lastMessage']));
  }

  toJson() {
    return {
      'id': this.id,
      'receiverId': this.receiverId,
      'senderId': this.senderId,
      'isReadReceiver': this.isReadReceiver,
      'isReadSender': this.isReadSender,
      'lastMessage': this.lastMessage?.toJson(),
    };
  }
}
