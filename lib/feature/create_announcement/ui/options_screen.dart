import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/dropDownSingleCheckBox/custon_dropDown_single_checkbox.dart';
import '../../../widgets/textField/under_line_text_field.dart';
import '../data/creating_announcement_manager.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final priseController = TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();
  bool isTouch = true;

  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Сaractéristiques',
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                'Prix',
                style: AppTypography.font16black.copyWith(fontSize: 18),
              ),
              UnderLineTextField(
                width: double.infinity,
                hintText: '',
                controller: priseController,
                keyBoardType: TextInputType.number,
                validator: (value) {
                  double? n;
                  try {
                    n = double.parse(priseController.text);
                  } catch (e) {
                    n = -1;
                  }
                  if (n < 0 || n > 20000000) {
                    isTouch = false;
                    return 'Erreur! Réessayez ou entrez dautres informations.';
                  }
                  isTouch = true;
                  return null;
                },
                onChange: (String value) {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    priseController.text =
                        double.parse(priseController.text).toString();
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onTapOutside: (e) {
                  setState(() {
                    priseController.text =
                        double.parse(priseController.text).toString();
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                suffixIcon: 'DZD',
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                  child: Column(
                children: (repository.currentItem != null
                        ? repository
                            .currentItem!.parameters.variableParametersList
                        : [])
                    .map((e) => CustomDropDownSingleCheckBox(
                          parameters: e,
                          onChange: (String? value) {
                            e.setVariant(value!);
                            setState(() {});
                          },
                          currentVariable: e.currentValue,
                        ))
                    .toList(),
              ))
            ],
          ),
        ),
        floatingActionButton: CustomElevatedButton.orangeContinue(
          width: MediaQuery.of(context).size.width - 30,
          text: 'Continuer',
          callback: () {
            repository.setPrice(priseController.text);
            repository.setInfoFormItem();
            Navigator.pushNamed(context, '/create_description');
          },
          isTouch: isTouch,
        ),
      ),
    );
  }
}
