import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/core/loader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../icons/icons_light.dart';
import '../../../utils/boxes.dart';
import '../../../utils/profile.dart';
import '../../../utils/utils.dart';
import '../../../widgets/header_bar/custom_header_bar.dart';
import '../../../widgets/ui/default_scaffold.dart';
import '../../../widgets/ui/primary_button.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPage();
}

class _ProfileEditPage extends State<ProfileEditPage> {
  final dynamic userData = userBox.get('data');
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController givenNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    familyNameController.text = getIn(userData, 'name.family_name', '');
    givenNameController.text = getIn(userData, 'name.given_name', '');
    emailController.text = getIn(userData, 'email', '');
    phoneController.text = getIn(userData, 'phone', '');
    addressController.text = getIn(userData, 'address', '');
    postalCodeController.text = getIn(userData, 'postal_code', '');
    localityController.text = getIn(userData, 'locality', '');
    birthdayController.text = getIn(userData, 'birthday', '') != ''
        ? DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(getIn(userData, 'birthday', '')))
        : '';
  }

  @override
  void dispose() {
    super.dispose();

    familyNameController.dispose();
    givenNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    localityController.dispose();
    birthdayController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'profile',
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CustomHeaderBar(
                onBack: () {
                  context.go('/home');
                },
                title: 'EDIT PROFILE',
              ),
              Container(
                // alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: givenNameController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.passport),
                              labelText: 'Given name *',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: familyNameController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.passport),
                              labelText: 'Family name *',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.envelope),
                              labelText: 'Email *',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.phone),
                              labelText: 'Phone',
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.locationDot),
                              labelText: 'Address',
                            ),
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: postalCodeController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.locationDot),
                              labelText: 'Postal Code',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: localityController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.locationDot),
                              labelText: 'Locality',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                            controller: birthdayController,
                            decoration: const InputDecoration(
                              icon: Icon(AppIconsLight.cakeCandles),
                              labelText: 'Birthday',
                            ),
                            onTap: () async {
                              var pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    getIn(userData, 'birthday', '') != ''
                                    ? DateTime.parse(
                                        getIn(userData, 'birthday', ''),
                                      )
                                    : DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                var formattedDate = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(pickedDate);
                                setState(() {
                                  birthdayController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                            keyboardType: TextInputType.datetime,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 50, color: Colors.transparent),
                    PrimaryButton(
                      onPressed: () async {
                        if (familyNameController.text == '' ||
                            givenNameController.text == '' ||
                            emailController.text == '') {
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
                        } else {
                          var saveOptions = {
                            'family_name': familyNameController.text,
                            'given_name': givenNameController.text,
                            'email': emailController.text,
                            'phone': phoneController.text,
                            'address': addressController.text,
                            'postal_code': postalCodeController.text,
                            'locality': localityController.text,
                            'birthday': birthdayController.text,
                          };
                          var userSaved = await saveUser(saveOptions, context);
                          if (userSaved != null &&
                              getIn(userSaved, 'success', false)) {
                            await fetchUser();

                            if (context.mounted) {
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: 'Success',
                                desc: 'Profile saved',
                                btnOkOnPress: () {},
                                btnOk: PrimaryButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'Close',
                                ),
                              ).show();
                            }
                          }
                        }
                      },
                      text: 'Save change',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
