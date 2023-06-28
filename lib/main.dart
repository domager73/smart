import 'package:appwrite/appwrite.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc/auth_cubit.dart';
import 'package:smart/data/app_repository.dart';
import 'package:smart/feature/create/bloc/category/category_cubit.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import 'package:smart/feature/registration/ui/register_screen.dart';
import 'package:smart/services/custom_bloc_observer.dart';
import 'package:smart/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'feature/create/bloc/sub_category/sub_category_cubit.dart';
import 'feature/create/ui/category_screen.dart';
import 'feature/create/ui/choose_by_notBy_screen.dart';
import 'feature/create/ui/photo_screen.dart';
import 'feature/create/ui/search_products_screen.dart';
import 'feature/create/ui/sub_category_screen.dart';
import 'feature/home/ui/home_screen.dart';
import 'feature/login/ui/login_first_screen.dart';
import 'feature/login/ui/login_second_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = CustomBlocObserver();
  runApp(MyRepositoryProviders());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.mainBackground,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      routes: {
        '/login_first_screen': (context) => const LoginFirstScreen(),
        '/login_second_screen': (context) => const LoginSecondScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/create_category_screen': (context) => const CategoryScreen(),
        '/create_sub_category_screen': (context) => const SubCategoryScreen(),
        '/create_search_products_screen': (context) => const SearchProductsScreen(),
        '/create_photo_screen' : (context) => const PhotoScreen(),
        '/create_by_not_by_screen' : (context) => const ByNotByScreen(),
      },
      color: const Color(0xff292B57),
      home: const HomePage(),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);
  final client = Client()
      .setEndpoint('http://89.253.237.166/v1')
      .setProject('64987d0f7f186b7e2b45');

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AppRepository(client: client),
      ),
      RepositoryProvider(
        create: (_) => CreatingAnnouncementManager(client: client),
      ),
    ], child: const MyBlocProviders());
  }
}

class MyBlocProviders extends StatelessWidget {
  const MyBlocProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => AuthCubit(
            appRepository: RepositoryProvider.of<AppRepository>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => CategoryCubit(
            creatingManager: RepositoryProvider.of<CreatingAnnouncementManager>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => SubCategoryCubit(
            creatingManager: RepositoryProvider.of<CreatingAnnouncementManager>(context)),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => ItemSearchCubit(
            creatingManager: RepositoryProvider.of<CreatingAnnouncementManager>(context)),
        lazy: false,
      ),
    ], child: const MyApp());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return const HomeScreen();
          } else {
            return const Center(
              child: LoginFirstScreen(),
            );
          }
        },
      ),
    );
  }
}
