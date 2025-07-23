import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../widgets/indicators/custom_progress_bar.dart';

class ProfileProgress extends StatelessWidget {
  const ProfileProgress({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
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
          const Divider(color: Colors.transparent, height: 5),
          CustomProgressBar(
            height: 20,
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
