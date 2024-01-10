import 'package:flutter/material.dart';
import 'package:image_editor_app/Providers/screen_provider.dart';
import 'package:provider/provider.dart';

import 'Providers/image_path_provider.dart';
import 'Views/home.dart';
import 'Views/edit_photo.dart';
import 'Views/remove_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImagePathProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Home(),
      ),
    );
  }
}
