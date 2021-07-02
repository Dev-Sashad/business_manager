import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/AuthViews/resetpassword/resetpassword_view_model.dart';
import 'package:records/ui/widget/generalButton.dart';
import 'package:records/ui/widget/text_form.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';
import 'package:records/utils/constants/validator.dart';

class ResetPasswordpage extends StatefulWidget {
  @override
  ResetPasswordpageState createState() => ResetPasswordpageState();
}

class ResetPasswordpageState extends State<ResetPasswordpage> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  String oldPassword, newPassword;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ResetPasswordViewModel>.withConsumer(
        viewModelBuilder: () => ResetPasswordViewModel(),
        builder: (context, model, child) {
          return GestureDetector(
            onTap:(){
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color:AppColors.white),
                    onPressed: () {
                      model.pop();
                    }),
                backgroundColor: Colors.orangeAccent,
                title: Text('Change Password',
                    textAlign: TextAlign.center, style: appBartextStyle,),
                centerTitle: true,
              ),
              body: ListView(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: Responsive.sizeboxheight(context)),
                            CustomTextFormField(
                              label: "Old Password",
                              borderStyle: BorderStyle.solid,
                              textInputType: TextInputType.visiblePassword,
                              obscured: model.visiblePassword,
                              hasSuffixIcon: true, // suffix icon enabled
                              controller: oldPasswordController,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  model.setvisiblePassword();
                                }, // changes the password visibility
                                icon: Icon(
                                  model.visiblePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey_light,
                                ),
                              ),
                              onChanged: (value) {
                                oldPassword = value;
                              },
                              validator: passwordValidator,
                            ),
                            SizedBox(height: Responsive.sizeboxheight(context)),
                            CustomTextFormField(
                              label: "New Password",
                              borderStyle: BorderStyle.solid,
                              textInputType: TextInputType.visiblePassword,
                              obscured: model.visiblePassword,
                              hasSuffixIcon: true, // suffix icon enabled
                              controller: newPasswordController,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  model.setvisiblePassword();
                                }, // changes the password visibility
                                icon: Icon(
                                  model.visiblePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey_light,
                                ),
                              ),
                              onChanged: (value) {
                                newPassword = value;
                              },
                              validator: passwordValidator,
                            ),
                          ])),
                ),
                SizedBox(height: Responsive.sizeboxheight(context) * 2),
                Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                      child: Text('Change Password', style: buttonTextStyle),
                      onPressed: () {
                        model.resetpassword(oldPassword, newPassword, formKey);
                      }),
                ),
              ]),
            ),
          );
        });
  }
}
