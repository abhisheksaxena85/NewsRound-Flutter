import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_round/contact_mail_page.dart';
import 'package:news_round/internetBloc/internet_bloc.dart';

void main() {
  //Setting the orientation to vertical permanent
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //Providing multiple BLOCs
    return MultiBlocProvider(
        providers: [
          //Providing the internet BLOC
          BlocProvider(
            create: (context) => InternetBloc(),
          ),
        ],
        child:MaterialApp(
        title: 'News Round',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primaryColorDark: Colors.black,
          primaryColorLight: Colors.white,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark
        ),
        //Building the layout according to screen width
        // home: AppLayoutBuilder())
        home: ContactPage()),
    );
  }
}