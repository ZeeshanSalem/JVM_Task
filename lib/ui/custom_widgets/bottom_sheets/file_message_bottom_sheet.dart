import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/colors.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/text_style.dart';

class FileMessageBottomSheet extends StatelessWidget {
  final onPickImage;

  FileMessageBottomSheet({this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onPickImage,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: Icon(Icons.image, color: primaryColor, size: 30),
                  title: Text('Image',
                      style: headingTextStyle.copyWith(fontSize: 14)),
                  subtitle: Text('Pick an image to send',
                      style: subHeadingTextStyle.copyWith(fontSize: 10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
