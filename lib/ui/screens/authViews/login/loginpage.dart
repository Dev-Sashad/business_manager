import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/widget/generalButton.dart';
import 'package:records/ui/widget/text_form.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';
import 'package:records/utils/constants/textstyle.dart';
import 'package:records/utils/constants/validator.dart';
import 'loginpage_view_model.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LogInPageModel>.withConsumer(
        viewModelBuilder: () => LogInPageModel(),
        builder: (context, model, child) {
          return GestureDetector(
            onTap:(){
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Scaffold(
                    body: SingleChildScrollView(
                        child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            height: Responsive.height(1, context),
                            width: Responsive.width(1, context),
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                height: Responsive.height(0.36, context),
                                width: Responsive.width(1, context),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    colors: [
                                      Colors.orangeAccent[200],
                                      Colors.orangeAccent,
                                      Colors.orangeAccent[100],
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(50)),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/user.png',
                                      height: MediaQuery.of(context).size.height *
                                          0.2,
                                      alignment: Alignment.center,
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('LOGIN',
                                                  style: headertextStyle,
                                                  textAlign: TextAlign.left),
                                              SizedBox(height: 1),
                                              Text(
                                                  'Adequate record keeping is necessary for \nproper bussines monitoring.',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  textAlign: TextAlign.left)
                                            ]))
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: Form(
                                              key: formKey,
                                              child: ListView(
                                                 shrinkWrap: true,
                                                 scrollDirection: Axis.vertical,
                                                  children: [
                                                    CustomTextFormField(
                                                      hasPrefixIcon: true,
                                                      prefixIcon: Icon(Icons.mail,
                                                          color: AppColors.grey),
                                                      label: "Email",
                                                      borderStyle:
                                                          BorderStyle.solid,
                                                      textInputType: TextInputType
                                                          .emailAddress,
                                                      controller: emailController,
                                                      onChanged: (value) {
                                                        model.email = value;
                                                      },
                                                      validator: emailValidator,
                                                    ),
                                                    CustomTextFormField(
                                                      label: "Password",
                                                      borderStyle:
                                                          BorderStyle.solid,
                                                      textInputType: TextInputType
                                                          .visiblePassword,
                                                      obscured:
                                                          model.visiblePassword,
                                                      hasSuffixIcon:
                                                          true, // suffix icon enabled
                                                      controller:
                                                          passwordController,
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          model
                                                              .setvisiblePassword();
                                                        }, // changes the password visibility
                                                        icon: Icon(
                                                          model.visiblePassword
                                                              ? Icons
                                                                  .visibility_off
                                                              : Icons.visibility,
                                                          color: AppColors
                                                              .grey_light,
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        model.password = value;
                                                      },
                                                      validator: (value){
                                                       return value.isEmpty ? 'enter password': null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                        height: Responsive
                                                                .sizeboxheight(
                                                                    context) *
                                                            0.5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            model.forgetPasswordDialog(context);
                                                          },
                                                          child: Text(
                                                            'Forgot password?',
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.green,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: Responsive
                                                            .sizeboxheight(
                                                                context)),
                                                    CustomButton(
                                                        child: Text('Login',
                                                            style:
                                                                buttonTextStyle),
                                                        onPressed: () {
                                                          model.submit(formKey);
                                                        }),
                                                    SizedBox(
                                                        height: Responsive
                                                            .sizeboxheight(
                                                                context)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Don\'t have an account?  ',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .black),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            model
                                                                .navigateToSignUp();
                                                          },
                                                          child: Text(
                                                            'Sign Up',
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.red,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        )),
                              
                            ]))))),
          );
        });
  }
}
