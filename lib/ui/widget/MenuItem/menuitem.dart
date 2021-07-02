import 'package:flutter/material.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/screensize.dart';

class MenuItem extends StatelessWidget {
final IconData icon;
final String title;
final Function onTap;

const MenuItem ({Key key, this.icon, this.title, this.onTap}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onTap,
   child: Padding (
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            Row(children: [
                Icon(
                  icon,
                  color: AppColors.white,
                  size: 20,
                ),

                SizedBox(width:20),

                Text(
                  title,

                  style: TextStyle(fontWeight:FontWeight.w300, fontSize:17, color: AppColors.white),
                ),

            ],),

                       Divider(
                            color: AppColors.white.withOpacity(0.9),
                            height: 10,
                            thickness: 0.8,
                            indent: 10,
                            endIndent: 10,
                          ),
                          SizedBox(height: Responsive.sizeboxheight(context)*0.5,),
          ],
        ),
    )
    );
  }


}