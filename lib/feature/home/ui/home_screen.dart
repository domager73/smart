import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc/auth/auth_cubit.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_elevated_button.dart';

import '../../../utils/colors.dart';
import '../../../widgets/conatainers/anouncment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Center(
          child: TextButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).logout();
              },
              child: const Text('Выйти'))),
      Center(child: const AnnouncementContainer()),
      const Text(''),
      Center(
        child: CustomElevatedButton.withIcon(
          callback: () {
            Navigator.pushNamed(context, '/create_category_screen');
          },
          width: MediaQuery.of(context).size.width - 30,
          text: 'Ajouter une annonce',
          styleText: AppTypography.font14white,
          isTouch: true,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      )
    ];

    void onSelectTab(int index) {
      if (_selectedTab == index) return;
      setState(() {
        _selectedTab = index;
      });
    }

    return WillPopScope(
      child: Scaffold(
        body: widgetOptions[_selectedTab],
        bottomNavigationBar: ClipRRect(
          child: BottomNavigationBar(
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedTab,
            items: [
              BottomNavigationBarItem(
                  icon: NavigatorBarItem(
                    asset: 'Assets/icons/search.svg',
                    isSelected: _selectedTab == 0,
                  ),
                  tooltip: 'Page daccueil',
                  label: 'Page daccueil'),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/email.svg',
                  isSelected: _selectedTab == 1,
                ),
                tooltip: 'Messages',
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/like.svg',
                  isSelected: _selectedTab == 2,
                ),
                tooltip: 'Délection',
                label: 'Délection',
              ),
              BottomNavigationBarItem(
                icon: NavigatorBarItem(
                  asset: 'Assets/icons/profile.svg',
                  isSelected: _selectedTab == 3,
                ),
                tooltip: 'Mon profil',
                label: 'Mon profil',
              ),
            ],
            selectedLabelStyle: AppTypography.font10pink,
            unselectedLabelStyle: AppTypography.font10lightGray,
            onTap: onSelectTab,
            selectedItemColor: AppColors.red,
            unselectedItemColor: AppColors.lightGray,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}

class NavigatorBarItem extends StatelessWidget {
  const NavigatorBarItem(
      {Key? key, required this.asset, required this.isSelected})
      : super(key: key);

  final String asset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: 24,
      width: 24,
      color: isSelected ? AppColors.red : AppColors.lightGray,
    );
  }
}
