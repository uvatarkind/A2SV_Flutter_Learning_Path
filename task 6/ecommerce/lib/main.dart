import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_pages/core/route/app_route.dart';
import 'package:ui_pages/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:ui_pages/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:ui_pages/feature/product/presentation/bloc/product_bloc.dart';
import 'package:ui_pages/injection_container.dart'; // your DI setup file

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => getIt<ProductBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
        ),
        BlocProvider(
          create: (_)=> getIt<RegisterBloc>(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: AppRoute.onGenerateRoute,
      ),
      
    );
  }
}
