import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/icons/icons_light.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../core/api_helper.dart';
import '../../../pages/auth/auth_splash_screen.dart';
import '../../../theme/colors.dart';
import '../../../utils/assets/assets_images.dart';
import '../../../utils/boxes.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  ApiHelper baseApi = ApiHelper();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool get isTablet {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  bool get isLandscape {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  double getResponsiveSize(double phoneSize, double tabletSize) {
    return isTablet ? tabletSize : phoneSize;
  }

  EdgeInsets getResponsivePadding() {
    if (isTablet) {
      return isLandscape
          ? const EdgeInsets.symmetric(horizontal: 120, vertical: 20)
          : const EdgeInsets.symmetric(horizontal: 80, vertical: 40);
    } else {
      return isLandscape
          ? const EdgeInsets.symmetric(horizontal: 60, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomLeft,
                    colors: ColorsPallet.bdb,
                  ),
                ),
              ),
              Positioned(
                top: isLandscape ? -constraints.maxHeight * 1.7 : 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/backgrounds/bg_login.png',
                  scale: isLandscape ? 0.8 : 1.0,
                  width: constraints.maxWidth,
                  fit: BoxFit.cover,
                ),
              ),
              if (isLandscape && isTablet)
                _buildLandscapeTabletLayout(constraints)
              else
                PageView(
                  children: [
                    _buildBannerPage(constraints),
                    _buildFieldsPage(constraints),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLandscapeTabletLayout(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildBannerPage(constraints)),
        Expanded(flex: 1, child: _buildFieldsPage(constraints)),
      ],
    );
  }

  Widget _buildBannerPage(BoxConstraints constraints) {
    final logoSize = isTablet
        ? (isLandscape ? 120.0 : 180.0)
        : (isLandscape ? 80.0 : 150.0);

    final titleSize = getResponsiveSize(
      isLandscape ? 24.0 : 32.0,
      isLandscape ? 32.0 : 40.0,
    );

    final textSize = getResponsiveSize(
      isLandscape ? 12.0 : 14.0,
      isLandscape ? 14.0 : 16.0,
    );

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: getResponsivePadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  alignment: Alignment.center,
                  child: Image.asset(AppImages.playerlight),
                ),
                SizedBox(height: getResponsiveSize(8, 12)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'E-DUTAINMENT',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontFamily: 'Football Attack',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: getResponsiveSize(16, 24)),
                Flexible(
                  child: Text(
                    '''
Bienvenue sur e-dutainment

Si vous avez déjà un compte, 
veuillez swiper à droite pour vous connecter

Si vous n'avez pas encore de compte, 
Il faut vous abonner sur le site
e-dutainment.com.
                    '''
                        .trim(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: textSize,
                    ),
                  ),
                ),
                SizedBox(height: getResponsiveSize(16, 24)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsPage(BoxConstraints constraints) {
    final logoSize = isTablet
        ? (isLandscape ? 100.0 : 140.0)
        : (isLandscape ? 70.0 : 120.0);

    final bannerWidth = isTablet
        ? (isLandscape ? 200.0 : 280.0)
        : (isLandscape ? 150.0 : 230.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.black.withOpacity(.7),
        ),
        SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxWidth: isTablet ? 600 : constraints.maxWidth,
            ),
            padding: getResponsivePadding(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isLandscape || !isTablet) ...[
                  Container(
                    width: logoSize,
                    height: logoSize,
                    alignment: Alignment.center,
                    child: Image.asset(AppImages.playerlight),
                  ),
                  SizedBox(height: getResponsiveSize(16, 24)),
                ],
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 400 : double.infinity,
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            icon: Icon(AppIconsLight.passport),
                            labelText: 'Username',
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: getResponsiveSize(8, 16)),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            icon: Icon(AppIconsLight.lock),
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: getResponsiveSize(16, 24)),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 400 : double.infinity,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: getResponsiveSize(8, 16),
                  ),
                  child: PrimaryButton(
                    radius: 25,
                    colors: const [
                      ColorsPallet.blueComponent,
                      ColorsPallet.blueComponent,
                    ],
                    onPressed: () async {
                      if (usernameController.text == '' &&
                          passwordController.text == '' &&
                          context.mounted) {
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'Check required field',
                          btnOkOnPress: () {},
                          btnOk: PrimaryButton(
                            onPressed: () => {Navigator.of(context).pop()},
                            text: 'Close',
                          ),
                        ).show();
                        return;
                      }
                      EasyLoading.show();
                      var response = await baseApi.post('/auth/token', {
                        'username': usernameController.text,
                        'password': passwordController.text,
                      }, context);

                      await EasyLoading.dismiss();
                      if (getIn(response, 'success') == false) {
                        if (context.mounted) {
                          await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: '${getIn(response, 'message')}',
                            desc:
                                'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
                            btnOkOnPress: () {},
                            btnOk: PrimaryButton(
                              onPressed: () => {Navigator.of(context).pop()},
                              text: 'Close',
                            ),
                          ).show();
                        }
                      } else {
                        await userBox.put('token', getIn(response, 'token'));
                        if (context.mounted) {
                          Get.to(() => const AuthSplashScreenPage());
                        }
                      }
                    },
                    text: 'Login',
                  ),
                ),
                SizedBox(height: getResponsiveSize(8, 16)),
                Text(
                  'a service by',
                  style: TextStyle(fontSize: getResponsiveSize(12, 14)),
                ),
                SizedBox(height: getResponsiveSize(4, 8)),
                AssetsImage.bannerColor.toImage(width: bannerWidth),
                SizedBox(height: getResponsiveSize(16, 24)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
