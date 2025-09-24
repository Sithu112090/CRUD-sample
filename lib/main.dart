import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc/product_bloc.dart';
import 'package:flutterbloc/bloc/product_event.dart';
import 'package:flutterbloc/models/product_model.dart';
import 'package:flutterbloc/screens/product_screen.dart';
import 'package:flutterbloc/services/hive_service.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Hive initialization
  await Hive.initFlutter();

  //Register Hive Adapters
  Hive.registerAdapter(ProductAdapter());

  //Open Hive box
  await Hive.openBox<Product>('products');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(HiveService())..add(LoadProduct()),
      child: MaterialApp(
        title: 'Flutter Bloc with api',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        home: ProductScreen(),
      ),
    );
  }
}
