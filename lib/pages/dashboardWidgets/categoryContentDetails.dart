import 'dart:async';import 'package:flutter/material.dart';import 'package:flutter_spinkit/flutter_spinkit.dart';import 'package:intl/intl.dart';import 'package:news_round/models/categoryNewsAPImodel.dart';import 'package:cached_network_image/cached_network_image.dart';import 'package:news_round/pages/bookmarkFiles/bookmarkDataModel.dart';import 'package:news_round/pages/bookmarkFiles/bookmarkDbHelper.dart';import 'package:news_round/pages/bookmarkSnackBar.dart';import 'package:news_round/pages/webview.dart';class categoryContentDetails extends StatefulWidget {  //Getting data from dashBoardScreen  final AsyncSnapshot<categoryNewsAPImodel> snapshot;  final int index;  final String category;  categoryContentDetails({required this.snapshot, required this.index, required this.category});  @override  State<categoryContentDetails> createState() => _categoryContentDetailsState();}class _categoryContentDetailsState extends State<categoryContentDetails> {  //Boolean value to check if article exists in Database - default is false  bool isBookmarked = false;  //Creating an instance of Database Helper class  bookmark_DB_helper databaseHelper = bookmark_DB_helper();  //Checking if current article is available in databse  Future<bool> bookmaredArticle() async {    isBookmarked = (await databaseHelper.isURLAvailable(widget.snapshot.data!.articles![widget.index].url.toString()))!;    return isBookmarked;  }  @override  void initState() {    super.initState();  }  @override  Widget build(BuildContext context) {    //ThemeMode Boolean Value    bool lightTheme = MediaQuery.of(context).platformBrightness == Brightness.light ? true : false;    //Screen Width and Height    var width = MediaQuery.of(context).size.width * 1;    var height = MediaQuery.of(context).size.height * 1;    //Date format and parsing from snapshot to show    final format = DateFormat('MMMM dd, yyyy');    DateTime dateTime = DateTime.parse(widget.snapshot.data!.articles![widget.index].publishedAt.toString());    //Root Widget of this class    return Scaffold(        //Appbar with Category title and backBtn        appBar: AppBar(          elevation: 0,          title: Text(            widget.category,            style: TextStyle(                fontFamily: 'nunitosSans_semiBold',                color: lightTheme ? Colors.black87 : Colors.white),          ),          backgroundColor: lightTheme ? Colors.white : Colors.grey.shade900,          centerTitle: true,          leading: IconButton(            tooltip: "Navigation",            icon: Icon(              Icons.arrow_back_ios_sharp,              color: lightTheme ? Colors.black87 : Colors.white,              size: 25,            ),            onPressed: () {              Navigator.pop(context);            },          ),          actions: [            Container(              margin:const EdgeInsets.only(right: 10),                child: FutureBuilder(future: bookmaredArticle(), builder: (context,snapshot){              if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){ print(isBookmarked.toString());                return InkWell(                  onTap: () {                    //Checking if already bookmark added, if yes then deleting onclick                    if (isBookmarked == true) {                      databaseHelper.delete(widget.snapshot.data!                          .articles![widget.index].url                          .toString());                      bookmarkRemoved(context, lightTheme);                    //Otherwise adding new bookmark to database                    } else if (isBookmarked == false) {                      databaseHelper.insert(bookmarkDataModel(                        author: widget.snapshot.data!                            .articles![widget.index].author                            .toString(),                        content: widget.snapshot.data!                            .articles![widget.index].content                            .toString(),                        description: widget.snapshot.data!                            .articles![widget.index].description                            .toString(),                        publishedAt: widget.snapshot.data!                            .articles![widget.index].publishedAt                            .toString(),                        sourceName: widget.snapshot.data!                            .articles![widget.index].source!.name                            .toString(),                        title: widget.snapshot.data!                            .articles![widget.index].title                            .toString(),                        url: widget.snapshot.data!                            .articles![widget.index].url                            .toString(),                        urlToImage: widget.snapshot.data!                            .articles![widget.index].urlToImage                            .toString(),                      ));                      bookmarkAdded(context, lightTheme);                    }                    setState(() {});                  },                  child:isBookmarked?const Icon(Icons.bookmark_added,color: Colors.blue,size: 30,): Icon(Icons.bookmark_add_outlined,color:lightTheme?Colors.black:Colors.white,size: 30,),                );              }else if(snapshot.connectionState == ConnectionState.waiting){                return const Center(                  child: SpinKitFadingCircle(                    size: 20,                    color: Colors.black,                  ),                );              }else{                return Container(                );              }            })),          ],        ),        //Main Content Container        body: Container(          width: width,          height: height,          color: lightTheme ? Colors.white : Colors.grey.shade900,          //Stack of Image Container and Details Container          child: Stack(            children: [              //News Image Stack first Container with Radius and shadow              Container(                margin: const EdgeInsets.only(top: 3),                height: height * 0.4,                decoration: BoxDecoration(                  border: Border.all(                      width: 0.25,                      color: lightTheme ? Colors.black87 : Colors.white),                  boxShadow: [                    BoxShadow(                        color: lightTheme                            ? Colors.transparent                            : Colors.transparent,                        blurRadius: 20,                        offset: const Offset(1, -1),                        spreadRadius: 0)                  ],                  borderRadius: const BorderRadius.only(                      topLeft: Radius.circular(20),                      topRight: Radius.circular(25)),                ),                //Main Image of news category item with borderRadius                child: ClipRRect(                  borderRadius: const BorderRadius.only(                      topLeft: Radius.circular(20),                      topRight: Radius.circular(25)),                  child: CachedNetworkImage(                      fit: BoxFit.cover,                      imageUrl: Uri.parse(widget.snapshot.data!                                  .articles![widget.index].urlToImage                                  .toString())                              .isAbsolute                          ? widget                              .snapshot.data!.articles![widget.index].urlToImage                              .toString()                          : "https://img.freepik.com/premium-vector/error-message-laptop-screen-error-warning-sign-screen-computer-device_630277-341.jpg",                      placeholder: (context, url) => const SpinKitFadingCircle(                            //Placeholder untill image is loading                            color: Colors.amber,                            size: 50,                          ),                      //Error widget when image loading failed                      errorWidget: (context, url, error) {                        return const Center(                            child: Icon(                          Icons.error_outline,                          color: Colors.red,                        ));                      }),                ),              ),              //News Item Content part with description and title              Positioned(                  bottom: 5,                  left: 0,                  right: 0,                  //Second Container of stack with shadow and border radius                  child: Container(                    padding: const EdgeInsets.all(12),                    height: height * 0.51,                    decoration: BoxDecoration(                        boxShadow: [                          BoxShadow(                              color: lightTheme                                  ? Colors.black12                                  : Colors.grey.shade800,                              blurRadius: 5,                              offset: const Offset(0, -3),                              spreadRadius: 1)                        ],                        color: lightTheme ? Colors.white : Colors.grey.shade900,                        borderRadius: const BorderRadius.only(                            topLeft: Radius.circular(20),                            topRight: Radius.circular(25)),                        border: Border.all(                            width: 0.2,                            color: lightTheme ? Colors.black87 : Colors.grey)),                    //Scrollable content if overflow                    child: SingleChildScrollView(                      child: Column(                        mainAxisAlignment: MainAxisAlignment.start,                        crossAxisAlignment: CrossAxisAlignment.center,                        children: [                          //Title of news item of each category                          SizedBox(                            width: width,                            child: InkWell(                                child: Text(                                  maxLines: 3,                                  overflow: TextOverflow.ellipsis,                                  widget.snapshot.data!.articles![widget.index]                                      .title                                      .toString(),                                  style: TextStyle(                                    fontSize: 19,                                    fontFamily: 'nunitosSans_bold',                                    fontWeight: FontWeight.bold,                                    color: lightTheme                                            ? Colors.black                                            : Colors.white,                                  ),                                )),                          ),                          //Source and publish date of news item                          Container(                            margin: const EdgeInsets.only(top: 3),                            alignment: Alignment.center,                            width: width,                            height: height * 0.05,                            child: Row(                              mainAxisAlignment: MainAxisAlignment.spaceBetween,                              crossAxisAlignment: CrossAxisAlignment.center,                              children: [                                //Source name with click method callback                                InkWell(                                  onTap: () {                                    //Redirecting to webview page                                    Navigator.push(                                        context,                                        MaterialPageRoute(                                            builder: (context) => webview(                                                webUrl: widget.snapshot.data!                                                    .articles![widget.index].url                                                    .toString())));                                  },                                  child: Text(                                    widget.snapshot.data!                                        .articles![widget.index].source!.name                                        .toString(),                                    style: const TextStyle(                                        fontSize: 12,                                        fontFamily: 'nunitosSans_regular',                                        color: Colors.blue,                                        fontWeight: FontWeight.bold),                                  ),                                ),                                //Publish time of news article                                Text(                                  format.format(dateTime),                                  style: TextStyle(                                      fontSize: 11,                                      color: lightTheme                                          ? Colors.grey.shade800                                          : Colors.grey.shade200,                                      fontFamily: 'nunitosSans_regular',                                      fontWeight: FontWeight.bold),                                ),                              ],                            ),                          ),                          //Content or description based on ternary condition                          Container(                            margin: const EdgeInsets.only(top: 5),                            alignment: Alignment.center,                            child: Text(                              widget.snapshot.data!.articles![widget.index]                                          .content ==                                      null //If content is null then display description                                  ? widget                                      .snapshot                                      .data!                                      .articles![widget.index]                                      .content //Else display content if that is not null on each news article                                      .toString()                                  : widget.snapshot.data!                                      .articles![widget.index].content                                      .toString(),                              style: TextStyle(                                  fontSize: 16,                                  fontFamily: 'nunitosSans_regular',                                  color: lightTheme                                      ? Colors.grey.shade800                                      : Colors.grey.shade200,                                  fontWeight: FontWeight.normal),                            ),                          ),                          //Read more btn with click method call back                          InkWell(                              onTap: () {                                //Redirecting to webview class with URL                                Navigator.push(                                    context,                                    MaterialPageRoute(                                        builder: (context) => webview(                                            webUrl: widget.snapshot.data!                                                .articles![widget.index].url                                                .toString())));                              },                              //Button Design                              child: Container(                                margin:                                    const EdgeInsets.only(bottom: 5, top: 0),                                alignment: Alignment.center,                                width: double.infinity,                                height: height * 0.1,                                child: Container(                                  padding: const EdgeInsets.symmetric(                                      vertical: 4, horizontal: 15),                                  decoration: BoxDecoration(                                      border: Border.all(                                          color: lightTheme                                              ? Colors.black87                                              : Colors.white,                                          width: 0.5),                                      borderRadius: const BorderRadius.all(                                          Radius.circular(4))),                                  child: Text(                                    'Read More',                                    style: TextStyle(                                        fontSize: 15,                                        color: lightTheme                                            ? Colors.black87                                            : Colors.white,                                        fontFamily: 'nunitosSans_regular'),                                  ),                                ),                              ))                        ],                      ),                    ),                  )),            ],          ),        ));  }}