import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:records/ui/widget/MenuItem/menuitem.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';

import 'sideNav_view_model.dart';

class SideNavpage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
   return ViewModelProvider<SideNavViewModel>.withConsumer(
      viewModelBuilder: () => SideNavViewModel(),
      builder: (context, model, child) {
          return  Drawer(
              elevation: 0.0,
              child: SafeArea(
                child: Container(
                    color: AppColors.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // margin: EdgeInsets.only(top:50),
                                alignment: Alignment.center,
                                height: Responsive.height(0.3,context),
                                color: AppColors.white, 
                                child: Image.asset('assets/images/user.png', fit:BoxFit.fitWidth,)),

                                 SizedBox(height: Responsive.sizeboxheight(context)*0.5,),
                                 Text('Business Manager', style: TextStyle(fontSize:20, color: AppColors.white))
                            ],
                          )
                        ),

                        

                        Column(
                          children: [
                            MenuItem(
                              icon: Icons.add,
                              title: 'Add Items',
                              onTap: () {
                            model.pop();   
                                model.navigateToAddItem();
                              },
                            ),
                             MenuItem(
                          icon: Icons.add,
                          title: 'Update Price',
                          onTap: () {
                            model.pop();
                            model.navigateUpdatePrice();
                          },
                        ),
                        MenuItem(
                          icon: Icons.lock,
                          title: 'Change Password',
                          onTap: () {
                             model.pop();
                            model.navigateToResetPassword();
                          },
                        ),
                 
                        // MenuItem(
                        //   icon: Icons.show_chart,
                        //   title: 'Sales Chart',
                        //   onTap: () {
                        //    model.pop();
                        //   },
                        // ),
                        // MenuItem(
                        //   icon: Icons.settings,
                        //   title: 'Settings',
                        //   onTap: () {
                        //     model.pop();
                        //   },
                        // ),
                  
                 

                           SizedBox(height: Responsive.sizeboxheight(context)*8,),
                          ],
                        ),

                               MenuItem(
                          icon: Icons.person,
                          title: 'LogOut',
                          onTap: () {
                            model.pop();
                           model.signout();
                          },
                        ),
                           
                      ],
                    )),
              ),
          );
        });
  }
}
