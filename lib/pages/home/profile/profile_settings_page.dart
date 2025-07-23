import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'home/settings',
      hideBottomBar: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            centerTitle: true,
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: ColorsPallet.darkBlue,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text('PROFILE'),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Edit Profile',
                    onPressed: () {
                      context.go('/home/settings/profile-edit');
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: PrimaryButton(
              text: 'Logout',
              colors: [Colors.red.withOpacity(.8), Colors.red.withOpacity(.8)],
              onPressed: () async {
                EasyLoading.show();
                await userBox.clear();
                Future.delayed(const Duration(seconds: 1), () {
                  EasyLoading.dismiss();
                  context.go('/auth');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
