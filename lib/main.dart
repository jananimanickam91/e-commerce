import 'package:example_code/e-commerce_webpage/bloc/cart_bloc/cart_bloc.dart';
import 'package:example_code/e-commerce_webpage/bloc/product_bloc/product_bloc.dart';
import 'package:example_code/e-commerce_webpage/repo/product_repository.dart';
import 'package:example_code/e-commerce_webpage/views/desktop/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc(repository: ProductRepository())..add(InitialProducts())),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter E-Commerce',
        theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity, fontFamily: 'Roboto'),
        home: ProductPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
