import 'package:edutainment/core/loader.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';
import '../icon/gradient_icon.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    this.height = 50,
    required this.child,
    this.backgroundColor = Colors.black,
    required this.items,
    this.itemStyle = const BottomBarItemStyle(),
    this.onChanged,
    this.hideBottomBar = false,
  });

  final double height;
  final Color backgroundColor;
  final Widget child;
  final List<BottomBarItem> items;
  final BottomBarItemStyle itemStyle;
  final Function(int index)? onChanged;
  final bool hideBottomBar;

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          // height: mediaHeight - (hideBottomBar ? 0 : height),
          child: child,
        ),
        if (!hideBottomBar)
          SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _BottomBarItem(
                        width: items[i].width,
                        height: items[i].height,
                        selected: items[i].selected,
                        icon: items[i].icon,
                        bottomBarItemStyle: itemStyle,
                        text: items[i].text,
                        onPressed: () async {
                          if (items[i].path.contains('movie')) {
                            final dynamic groupMovies = moviesBox.get(
                              'groupMovies',
                            );
                            if (groupMovies == null) {
                              EasyLoading.show();
                              await fetchMovies();
                              EasyLoading.dismiss();
                            }
                            if (context.mounted) {
                              context.go('/${items[i].path}');
                            }
                          } else if (context.mounted) {
                            context.go('/${items[i].path}');
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class BottomBarItemStyle {
  final Color? splashColor, highlightColor;
  final Color? textColor, textSelectedColor;
  final double? hoverElevation, elevation, focusElevation;
  final ShapeBorder? shape;
  final BoxConstraints? constraints;

  const BottomBarItemStyle({
    this.splashColor,
    this.highlightColor,
    this.textColor,
    this.textSelectedColor,
    this.hoverElevation,
    this.elevation,
    this.focusElevation,
    this.shape,
    this.constraints,
  });
}

class BottomBarItem {
  final double width, height;
  final IconData icon;
  final String? text;
  final String path;
  final VoidCallback? onPressed;
  final bool selected;

  const BottomBarItem({
    required this.width,
    required this.height,
    required this.icon,
    required this.path,
    this.text,
    this.selected = false,
    this.onPressed,
  });
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.width,
    required this.height,
    required this.selected,
    required this.icon,
    this.text,
    required this.bottomBarItemStyle,
    required this.onPressed,
  });

  final double width, height;
  final bool selected;
  final IconData icon;
  final String? text;
  final BottomBarItemStyle bottomBarItemStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: RawMaterialButton(
          hoverElevation: bottomBarItemStyle.hoverElevation ?? 0,
          elevation: bottomBarItemStyle.elevation ?? 0,
          focusElevation: bottomBarItemStyle.focusElevation ?? 0,
          splashColor:
              bottomBarItemStyle.splashColor ?? Colors.white.withOpacity(.1),
          highlightColor:
              bottomBarItemStyle.highlightColor ??
              Colors.white.withOpacity(.09),
          shape:
              bottomBarItemStyle.shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          constraints:
              bottomBarItemStyle.constraints ??
              BoxConstraints(maxWidth: width, minWidth: width * 0.5),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GradientIcon(
                icon: icon,
                size: 20,
                gradient: LinearGradient(
                  colors: selected
                      ? ColorsPallet.blb
                      : [Colors.white, Colors.white54],
                ),
              ),
              if (text == null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    text!,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? bottomBarItemStyle.textSelectedColor ??
                                ColorsPallet.lightBlueComponent
                          : bottomBarItemStyle.textColor ?? Colors.white54,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
