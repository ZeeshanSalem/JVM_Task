import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/colors.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/text_style.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/conversation.dart';
import 'package:flutter_ecommerce_whitelabel/ui/screens/authentication/authuntication_screen.dart';
import 'package:flutter_ecommerce_whitelabel/ui/screens/chat/chat_screen.dart';
import 'package:flutter_ecommerce_whitelabel/ui/screens/dashboard/dashboard_view_model.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
          builder: (context, model, child) =>
              ModalProgressHUD(
                inAsyncCall: model.state == ViewState.busy,
                child: SafeArea(
                    child: Scaffold(

                      appBar: AppBar(
                        title: Text("Dashboard"),
                        centerTitle: true,
                      ),
                      drawer: _drawer(model),


                      backgroundColor: backgroundColor,


                      body: model.allUser.length < 1 ? Center(child: Text("Searching..... ", style: headingTextStyle,),): ListView.separated(
                          itemBuilder: (context, index) => _userTile(model, index),
                          separatorBuilder: (context, index) => SizedBox(height: 10,),
                          itemCount: model.allUser.length)
                    ),),
              ),
      ),
    );
  }

  Widget _userTile(DashboardViewModel model, int index){
    final conversation = Conversation(
        senderId: model.authServices.appUser.id,
        receiverId: model.allUser[index].id,
    );
    return InkWell(
      onTap: () => Get.to(ChatScreen(appUser: model.allUser[index], conversation: conversation,)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: model.allUser[index].imgUrl == null
                          ? FadeInImage(
                              width: 150,
                              height: 172,
                              placeholder:
                                  AssetImage("assets/static_assets/google_icon.png"),
                              image: AssetImage("assets/static_assets/google_icon.png"),
                              fit: BoxFit.cover,
                            )
                          : FadeInImage(
                              width: 150,
                              height: 172,
                              placeholder:
                                  AssetImage("assets/static_assets/google_icon.png"),
                              image: NetworkImage(model.allUser[index].imgUrl),
                              fit: BoxFit.cover,
                            ),
              ),
            ),

            Text("${model.allUser[index].fullName ?? ""}", style: subHeadingTextStyle,),
            SizedBox(height: 20,),
            Text("${model.allUser[index].email ?? ""}", style: subHeadingTextStyle,),


          ],
        ),
      ),
    );
  }

  _drawer(DashboardViewModel model){
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Finger Lock",
                  style: headingTextStyle.copyWith(fontWeight: FontWeight.w400),
                ),
                Switch(
                  activeColor: secondaryColor,
                  inactiveTrackColor: lightGreyColor.withOpacity(0.2),
                  activeTrackColor: secondaryColor.withOpacity(0.2),
                  value: model.isFingerLoginEnable,
                  onChanged: (val){
                    model.fingerLock(val);
                  },
                )
              ],
            ),


            SizedBox(height: 20,),

            OutlineButton(
                onPressed: () async{
                  await model.authServices.signOut();
                  Get.offAll(AuthenticationScreen());
                },
              child: Text("Sign Out"),
            ),
          ],
        ),


      ),
    );
  }
}
