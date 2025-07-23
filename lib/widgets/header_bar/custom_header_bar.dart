import 'package:flutter/material.dart';

import '../../icons/icons_light.dart';

class CustomHeaderBar extends StatelessWidget {
  const CustomHeaderBar({
    super.key,
    this.height = 50,
    this.title = '',
    this.titleStyle,
    this.onBack,
    this.centerTitle = true,
  });

  final double height;
  final String title;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: height,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (onBack != null) {
                onBack!();
              }
            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(AppIconsLight.arrowLeft),
            ),
          ),
          Expanded(
            child: centerTitle
                ? Center(
                    child: Text(
                      title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
