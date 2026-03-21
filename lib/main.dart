import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await configureDependencies();

  // Start FCM listener and feed incoming messages into the NotificationBloc.
  await FcmService.instance.init(sl());

  runApp(const SmartGateApp());
}

class SmartGateApp extends StatelessWidget {
  const SmartGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Provide the singleton NotificationBloc globally so the badge
      // stays in sync on every page without re-fetching.
      value: sl<NotificationBloc>(),
      child: MaterialApp.router(
        title: 'Smart Gate',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
