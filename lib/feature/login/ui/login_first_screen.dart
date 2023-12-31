import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/textField/custom_text_field.dart';
import '../../../widgets/textField/mask_text_field.dart';

final maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+## (###) ###-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

class LoginFirstScreen extends StatefulWidget {
  const LoginFirstScreen({Key? key}) : super(key: key);

  @override
  State<LoginFirstScreen> createState() => _LoginFirstScreenState();
}

class _LoginFirstScreenState extends State<LoginFirstScreen> {
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isError = false;

  bool isTouch = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 230,
                  height: 62,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("Assets/logo.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Bienvenue!',
                  style: AppTypography.font24black,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: width * 0.6,
                  child: Text(
                    'Lorem lobortis mi ornare nisi tellus sed aliquam accuornare nis',
                    style: AppTypography.font14lightGray,
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MaskTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/phone.svg',
                          mask: maskPhoneFormatter,
                          validator: (value) {
                            if (maskPhoneFormatter.getUnmaskedText().length !=
                                11) {
                              return 'Erreur! Réessayez ou entrez dautres informations.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (maskPhoneFormatter.getUnmaskedText().length ==
                                11) {
                              isTouch = true;
                              setState(() {});
                              return;
                            }
                            isTouch = false;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: height * 0.18,
                        ),
                        CustomElevatedButton(
                          callback: () {
                            if (!_formKey.currentState!.validate()) {
                              isError = true;
                              setState(() {});
                              return;
                            }
                            Navigator.pushNamed(
                                context, '/login_second_screen');
                          },
                          text: 'Entrer',
                          styleText: AppTypography.font14white,
                          height: 52,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          isTouch: isTouch,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Pas de compte? ',
                          style: AppTypography.font14lightGray
                              .copyWith(fontSize: 16)),
                      TextSpan(
                          text: 'Inscrivez-vous!',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register_screen');
                            },
                          style: AppTypography.font16UnderLinePink)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        onPressed: () {},
                        shape: const CircleBorder(),
                        constraints:
                            const BoxConstraints(maxWidth: 40, maxHeight: 40),
                        child: const Image(
                            image: AssetImage('Assets/facebook.png')),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      RawMaterialButton(
                        constraints:
                            const BoxConstraints(maxWidth: 40, maxHeight: 40),
                        onPressed: () {},
                        shape: const CircleBorder(),
                        child:
                            const Image(image: AssetImage('Assets/google.png')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
