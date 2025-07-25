// main.dart
import 'package:example_code/products_page/bloc/product_bloc.dart';
import 'package:example_code/products_page/repo/repo.dart';
import 'package:example_code/splash_screen/splash_screen.dart';
import 'package:example_code/theme/theme_configration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ProductBloc(repository: ProductRepository()))],
      child: MaterialApp(title: 'Cartify', debugShowCheckedModeBanner: false, theme: AppTheme.lightTheme, home: const SplashScreen()),
    );
  }
}
