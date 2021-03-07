import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/message_type.dart';
import 'package:intl/intl.dart';

class Message {
  String senderId;
  String message;
  String timeStamp;
  MessageType type;
  String fileUrl;

  Message(
      {this.senderId,
        this.message,
        this.timeStamp,
        this.type = MessageType.text,
        this.fileUrl});

  Message.fromJson(json) {
    this.senderId = json['senderId'];
    this.message = json['message'];
    this.type = _getMessageType(json['type']);
    if (json['timeStamp'] != null) {
      print('String time: ${json['timeStamp']}');
      DateTime time =
      DateFormat('yyyy-mm-dd HH:mm:s').parse(json['timeStamp']).toLocal();
      if (time != null) {
        timeStamp = DateFormat('HH : mm').format(time);
      }
    }
    fileUrl = json['fileUrl'];
    print(message.toString());
  }

  toJson() {
    return {
      'senderId': this.senderId,
      'message': this.message,
      'timeStamp': timeStamp?.toString() ?? null,
      'fileUrl': this.fileUrl,
      'type': describeEnum(this.type ?? MessageType.text),
    };
  }

  _getMessageType(type) {
    if (type == 'text')
      return MessageType.text;
    else if (type == 'file')
      return MessageType.file;
    else if (type == 'image') return MessageType.image;
  }
}
