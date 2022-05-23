import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'db/db.helper.dart';
import 'services/theme_services.dart';
import 'ui/home_page.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
   runApp(MyApp());
}

class MyApp extends StatelessWidget { 


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light ,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,

      home: HomePage()
    );
  }
}