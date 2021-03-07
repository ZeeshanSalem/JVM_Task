import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/colors.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/text_style.dart';
import 'package:path/path.dart' as P;


class SendFileConfirmDialog extends StatelessWidget {
  final onSendPressed;
  final File file;

  SendFileConfirmDialog({this.onSendPressed, this.file});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Image(
              image: FileImage(file),
              width: double.infinity,
              height: 300,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 40),

            OutlineButton(
                child: Text('Send', style: buttonTextStyle.copyWith(color: primaryColor),),
                onPressed: onSendPressed)
          ],
        ),
      ),
    );
  }
}
