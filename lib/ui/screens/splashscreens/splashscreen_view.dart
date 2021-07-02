                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/screens/AuthViews/login/loginpage.dart';
import 'package:records/ui/screens/home/homepage/homepage.dart';
import 'package:records/ui/screens/splashscreens/splashscreen_view_model.dart';
import 'package:records/utils/constants/colors.dart';

class SplashscreenView extends StatelessWidget {
  const SplashscreenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SplashscreenViewModel>.withConsumer(
        viewModelBuilder: () => SplashscreenViewModel(),
        builder: (context, model, child) {
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: AnimatedSplashScreen(
            centered: true,
            backgroundColor: AppColors.primaryColor ,
            splash: Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png',),
             
              ),
            splashIconSize: 200,
            splashTransition: SplashTransition.scaleTransition,
            nextScreen: FutureBuilder<dynamic>(
              future: model.isuserloggedin(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return LogInPage();
                }
                else{
                  return HomePage();
                }
              },
            )
              ),
      ),
        );
        }
    );
  }
}
