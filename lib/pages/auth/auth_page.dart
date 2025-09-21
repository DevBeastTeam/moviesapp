import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/icons/icons_light.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_helper.dart';
import '../../theme/colors.dart';
import '../../utils/assets/assets_images.dart';
import '../../utils/boxes.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            // width: MediaQuery.of(context).size.width,
            // height: Get.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.bottomLeft,
                colors: ColorsPallet.bdb,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/backgrounds/bg_login.png'),
          ),
          PageView(children: [_buildBannerPage(), _buildFieldsPage()]),
        ],
      ),
    );
  }

  Widget _buildBannerPage() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25 > 150
                    ? 150
                    : MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25 > 150
                    ? 150
                    : MediaQuery.of(context).size.width * 0.25,
                alignment: Alignment.center,
                // child: AssetsImage.defaultIcon.toImage(),
                child: Image.asset(AppImages.playerlight),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.only(left: 2, right: 2),
                child: const Text(
                  'E-DUTAINMENT',
                  style: TextStyle(fontSize: 32, fontFamily: 'Football Attack'),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '''
                Bienvenue sur e-dutainment
                \n
Si vous avez déjà un compte, 
veuillez swiper à droite pour vous connecter
\n
Si vous n’avez pas encore de compte, 
Il faut vous abonner sur le site
e-dutainment.com.
                '''
                    .trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsPage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.8,
          // width: MediaQuery.of(context).size.width,
          // height: Get.height,
          color: Colors.black.withOpacity(.7),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 > 170
                          ? 170
                          : MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5 > 170
                          ? 170
                          : MediaQuery.of(context).size.width * 0.5,
                      alignment: Alignment.center,
                      child: Image.asset(AppImages.playerlight),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        // key: controller._formKey,
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
                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                icon: Icon(AppIconsLight.lock),
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: PrimaryButton(
                  radius: 25,
                  colors: const [
                    ColorsPallet.blueComponent,
                    ColorsPallet.blueComponent,
                  ],
                  onPressed: () async {
                    if (usernameController.text == '' &&
                        usernameController.text == '' &&
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
                        context.go('/auth-splash');
                      }
                    }
                  },
                  text: 'Login',
                ),
              ),
              const Text('a service by'),
              // usernameController.text.isEmpty
              //     ? 
                  AssetsImage.bannerColor.toImage(
                      width: MediaQuery.of(context).size.width * .5 > 230
                          ? 230
                          : MediaQuery.of(context).size.width * .5,
                    )
                    ,
                  // : SizedBox.shrink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
