import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    '0HTtGrkBOyil7P1hZa9NsGLKwxYxiHuZwGTvfeMp', // Back4App App ID
    'https://parseapi.back4app.com', // Back4App API URL
    clientKey: 'PCXeKqUisLQITq9q1r2uSNw6kDbV4NFPdP6hkHaq', // Back4App Client Key
    autoSendSessionId: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
