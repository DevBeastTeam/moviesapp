import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  String text = '';
  double paddingTop ;
   EmptyWidget({super.key, this.text = "", this.paddingTop =  200});

  @override
  Widget build(BuildContext context) {
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Center(
        child: Column(
          children: [
            Icon( Icons.hourglass_empty_rounded, size: h * 0.07, color: Colors.blue.withOpacity(0.2),),
            Text(
              text,
              style: t.titleMedium!.copyWith(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
