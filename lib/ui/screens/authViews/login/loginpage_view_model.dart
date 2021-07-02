import 'package:flutter/material.dart';
import 'package:records/core/services/authentication.dart';
import 'package:records/ui/widget/generalButton.dart';
import 'package:records/ui/widget/text_form.dart';
import 'package:records/utils/baseModel/baseModel.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';
import 'package:records/utils/constants/validator.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/routeNames.dart';

class LogInPageModel extends BaseModel {
  final forgetPasswordformKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;
  // bool _progress= true;
  // bool get progress => _progress;
  final AuthService _authentication = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProgressService _progressService = locator<ProgressService>();

  setvisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }

  // setProgress(){
  //   _progress = !_progress;
  //   notifyListeners();
  // }

  void submit(GlobalKey<FormState> formKey) async {
    //signIn user
    if (validate(formKey)) {
      try {
        _authentication.login(email, password);
      } catch (e) {
        print(e);
      }
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateReplacementTo(SignUpPageRoute);
  }


    forget(GlobalKey<FormState> formKey, String email, BuildContext context){
    if (validate(formKey)) {
          Navigator.of(context).pop();
           _progressService.loadingDialog();

      try {

        _authentication.forgotpassword(email).then((value){
           _progressService.dialogComplete(response);
        });

      } catch (e) {
        print(e);
      }
    }
  }

  void pop() {
    _navigationService.pop();
  }

  void forgetPasswordDialog(BuildContext context) {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.grey,
                      size: 25,
                    ),
                  ),
                ),
            content:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caros',
                    ),
                  ),
                SizedBox(height: Responsive.sizeboxheight(context)),
                Form(
                   key: formKey,
                   child: CustomTextFormField(
                  hasPrefixIcon: true,
                  prefixIcon: Icon(Icons.mail, color: AppColors.grey),
                  label: "Email",
                  borderStyle: BorderStyle.solid,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: emailValidator,
                   )
                ),
              ],
            ),
            actions: <Widget>[
             Padding(
               padding: const EdgeInsets.symmetric(horizontal:20),
               child: CustomButton(
                    child: Text('reset', style: buttonTextStyle),
                    onPressed: () {
                forget(formKey, email, context);
                    }),
             ),
            ],
          );
        });
  }
}
