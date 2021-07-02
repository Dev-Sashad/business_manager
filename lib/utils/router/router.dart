import 'package:flutter/material.dart';
import 'package:records/ui/screens/AuthViews/SignUp/signup.dart';
import 'package:records/ui/screens/AuthViews/login/loginpage.dart';
import 'package:records/ui/screens/AuthViews/resetpassword/resetpassword.dart';
import 'package:records/ui/screens/Home/homepage/homepage.dart';
import 'package:records/ui/screens/OtherViews/add_item/additem.dart';
import 'package:records/ui/screens/OtherViews/add_stock/addstock.dart';
import 'package:records/ui/screens/OtherViews/sales_list/saleslist.dart';
import 'package:records/ui/screens/OtherViews/sell/sell.dart';
import 'package:records/ui/screens/OtherViews/stock_list/stocklist.dart';
import 'package:records/ui/screens/otherViews/update_price/updatePrice.dart';
import 'package:records/utils/router/routeNames.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case HomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );

        case SignInPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LogInPage(),
      );

         case SignUpPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );

           case UpdatePriceRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UpdatePrice(),
      );

           case ResetPasswordRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ResetPasswordpage(),
      );


         case AddItemRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AddItempage (),
      );

          case StockListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Stocklist(),
      );

        case AddStockRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Addstock(),
      );

         case SellRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Sellstock(),
      );

         case SalesListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Salelist(),
      );



    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
