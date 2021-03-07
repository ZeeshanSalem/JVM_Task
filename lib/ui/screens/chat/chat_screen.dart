import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/colors.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/text_style.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/message_type.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/app_user.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/conversation.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/auth_service.dart';
import 'package:flutter_ecommerce_whitelabel/ui/custom_widgets/alert_dialogs/send_confirmation_dialog.dart';
import 'package:flutter_ecommerce_whitelabel/ui/custom_widgets/bottom_sheets/file_message_bottom_sheet.dart';
import 'package:flutter_ecommerce_whitelabel/ui/custom_widgets/message_text_widget.dart';
import 'package:flutter_ecommerce_whitelabel/ui/screens/chat/chat_view_model.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';



class ChatScreen extends StatelessWidget {
  final Conversation conversation;
  final AppUser appUser;
  ChatScreen({this.appUser, this.conversation});

  @override
  Widget build(BuildContext context) {
    print(conversation.receiverId);
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(conversation),
      child: Consumer<ChatViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,

              ///
              /// Body
              ///
              body: Stack(
                children: [
                  /// Chat Screen dody
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ///
                  /// Top bar
                  ///
                  _topAppBar(),

                  ///
                  /// Chat Messages
                  ///
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: model.reversedMessagesList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        //Todo: Change docId to real Firebase Id
                        bool isMe = model.reversedMessagesList[index].senderId ==
                            locator<AuthService>().appUser.id;

                        print('isMe: $isMe');
                        model.isMe = isMe;
                        model.message = model.reversedMessagesList[index];
                         if (model.reversedMessagesList[index].type ==
                            MessageType.image) {
                          return isMe
                              ? ImageMessageRight(model.reversedMessagesList[index])
                              : ImageMessageLeft(model.reversedMessagesList[index]);
                        } else {
                          return isMe
                              ? MessengerTextRight(
                              message: model.reversedMessagesList[index])
                              : MessengerTextLeft(
                              message: model.reversedMessagesList[index]);
                        }
                      },
                    ),
                  ),

                  ///
                  /// Send Message Text Field plus buttons
                  ///
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          ///
                          /// Add files button
                          ///
                          GestureDetector(
                            child: Image.asset(
                              'assets/static_assets/icon_add.png',
                              width: 30,
                              height: 40,
                            ),
                            onTap: () {
                              _showModalBottomSheet(context, model);
                            },
                          ),
                          SizedBox(width: 20),

                          ///
                          /// Message TextField
                          ///
                          Flexible(
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: model.controller,
                              onChanged: (val) {
                                model.msgToBeSent.message = val;
                              },
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: 'Type your message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          ///
                          /// Send Message Button
                          ///
                          GestureDetector(
                            onTap: () {
                              if (model.msgToBeSent.message.trim().length > 0) {
                                model.sendMessage();
                              }
                            },
                            child: Image(
                              image:
                              AssetImage('assets/static_assets/ic_send_message.png'),
                              width: 41,
                              height: 41,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  _topAppBar() {
    return Container(
      width: double.infinity,
      height: 83,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Row(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          SizedBox(width: 25),
          ClipRRect(
            child: FadeInImage(
              image: NetworkImage(
                 appUser.imgUrl ?? ''),
              placeholder: AssetImage('assets/static_assets/google_icon.png'),
              width: 41,
              height: 41,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(width: 10),
          Text("${appUser.fullName}", style: subHeadingTextStyle,),
          Spacer(),
          OutlineButton(
            onPressed: (){},
            child: Text("Delete"),
          ),
          SizedBox(width: 20),

        ],
      ),
    );
  }

  _showModalBottomSheet(context ,ChatViewModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) => FileMessageBottomSheet(
          onPickImage: () async {
            await model.pickImage();
            Navigator.pop(context);
          },
        )).then((val) {
      _modalBottomSheetClosed(context, model);
    });
  }

  _modalBottomSheetClosed(context, ChatViewModel model) {
    if (model.selectedFile != null) {
        model.msgToBeSent.type = MessageType.image;
      showDialog(
          context: context,
          child: SendFileConfirmDialog(
            file: model.selectedFile,
            onSendPressed: () {
              print('Send pressed');
              Navigator.pop(context);
              model.sendMessage();
            },
          ));
    } else
      print('File is null');
  }

}
