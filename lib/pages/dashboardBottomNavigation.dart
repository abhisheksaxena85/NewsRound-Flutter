import 'package:flutter/services.dart';import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';import 'package:flutter/material.dart';import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';import 'package:news_round/pages/bookmarkNewsPage.dart';import 'package:news_round/pages/dashboardScreen.dart';import 'package:news_round/pages/searchNewsPage.dart';class dashboardNavigationBar extends StatefulWidget {  List<String>? selectedCategories;  dashboardNavigationBar({required this.selectedCategories});  @override  State<dashboardNavigationBar> createState() => _dashboardNavigationBarState();}class _dashboardNavigationBarState extends State<dashboardNavigationBar> {  int navigationIndex = 0;  @override  Widget build(BuildContext context) {    //ThemeMode boolean    bool theme = MediaQuery.of(context).platformBrightness == Brightness.light;    bool lightTheme = theme ? true : false;    //*Changing the color of statusBar of this screen    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(      statusBarColor: lightTheme? Colors.white: Colors.black54,      // statusBarIconBrightness: lightTheme? Brightness.dark: Brightness.light,      // statusBarBrightness:lightTheme? Brightness.dark: Brightness.light,    ));    return Scaffold(      backgroundColor: lightTheme?Colors.white:Colors.grey.shade900,      body: itemSelection(navigationIndex),      //*Bottom Navigation Bar of dashboard      bottomNavigationBar: Container(        margin:const EdgeInsets.only(left: 3,right: 3),        child: SnakeNavigationBar.color(        currentIndex: navigationIndex,        snakeShape: SnakeShape.indicator,        shape: RoundedRectangleBorder(          side: BorderSide(color:lightTheme?Colors.black87: Colors.white,width: 0.4),          borderRadius: BorderRadius.circular(15.0),        ),        snakeViewColor:lightTheme? Colors.black:Colors.white,        backgroundColor:lightTheme? Colors.white:Colors.black54,        items:[          BottomNavigationBarItem(            tooltip: 'Dashboard',              icon: Icon(Icons.home_rounded,color: lightTheme ?Colors.black:Colors.white,size: 26,)),          BottomNavigationBarItem(            tooltip: 'Trending',              icon: Icon(MdiIcons.earth,color: lightTheme ?Colors.black:Colors.white,size: 26,)),          BottomNavigationBarItem(            tooltip: 'Bookmark',              icon: Icon(MdiIcons.bookmark,color: lightTheme ?Colors.black:Colors.white,size: 26,)),        ],        onTap: (index) async {          setState(() {            navigationIndex = index;          });        },       ),      ),    );  }   Widget itemSelection(int index){    switch(index){      case 0:        return dashboardScreen(selectedCategories:widget.selectedCategories,);      case 1:        return searchNewsPage();      case 2:        return bookmarkNewsPage();      default:        return Container();    }  }}