import 'package:edutainment/constants/appimages.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/indicators/custom_progress_bar.dart';

class ProfileProgress extends StatelessWidget {
  const ProfileProgress({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    if (screen.isTablet) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        width: screen.width * 0.3,
        height: screen.width * 0.3,
        decoration: BoxDecoration(
          color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Image.asset(AppImages.mb, width: screen.width * 0.07),
            ),
            _buildComponentForTablet(context, text: 'GRAMMAR', value: .5),
            const Divider(color: Colors.transparent, height: 10),
            _buildComponentForTablet(
              context,
              text: 'COMPREHENSION',
              value: .35,
            ),
            const Divider(color: Colors.transparent, height: 10),
            _buildComponentForTablet(
              context,
              text: 'GLOBAL KNOWLEDGE',
              value: .7,
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: screen.isLandscape
            ? const EdgeInsets.all(8)
            : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            _buildComponent(context, text: 'GRAMMAR', value: .5),
            const Divider(color: Colors.transparent, height: 10),
            _buildComponent(context, text: 'COMPREHENSION', value: .35),
            const Divider(color: Colors.transparent, height: 10),
            _buildComponent(context, text: 'GLOBAL KNOWLEDGE', value: .7),
          ],
        ),
      );
    }
  }

  Widget _buildComponentForTablet(
    context, {
    required String text,
    required double value,
  }) {
    return SizedBox(
      height: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.transparent, height: 1),
          CustomProgressBar(
            height: 5,
            width: MediaQuery.of(context).size.width,
            value: value,
            radius: 5,
            backgroundColor: ColorsPallet.blue,
            accentColor: ColorsPallet.blueAccent,
            gradient: const LinearGradient(colors: ColorsPallet.yyo),
          ),
        ],
      ),
    );
  }

  Widget _buildComponent(
    context, {
    required String text,
    required double value,
  }) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          CustomProgressBar(
            height: 10,
            width: MediaQuery.of(context).size.width,
            value: value,
            radius: 16,
            backgroundColor: ColorsPallet.blue,
            accentColor: ColorsPallet.blueAccent,
            gradient: const LinearGradient(colors: ColorsPallet.yyo),
          ),
        ],
      ),
    );
  }
}
