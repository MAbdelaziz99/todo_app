import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/data/network/local/database/db_helber.dart';
import 'package:todo_app/presentation/home/cubit/home_cubit.dart';
import 'package:todo_app/presentation/splash/splash_screen.dart';

import 'app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DBHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers:
        [
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit()..createDatabase(),
          ),
        ],
        child: MaterialApp(
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) =>
              AppRouter.getInstance().generateRouter(settings),
        ),
      ),
    );
  }
}
