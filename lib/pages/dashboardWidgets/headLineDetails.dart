import 'package:flutter/material.dart';import 'package:flutter_spinkit/flutter_spinkit.dart';import 'package:intl/intl.dart';import 'package:news_round/models/newsHeadlinesAPImodel.dart';import 'package:cached_network_image/cached_network_image.dart';import 'package:news_round/pages/webview.dart';class headLineDetails extends StatefulWidget {  //Getting data from Headlines News Items  final AsyncSnapshot<newsHeadlinesAPImodel> snapshot;  final int index;  headLineDetails({required this.snapshot, required this.index});  @override  State<headLineDetails> createState() =>_headLineDetailsState();}class _headLineDetailsState extends State<headLineDetails> {  @override  Widget build(BuildContext context) {    //Light Theme Boolean Value    bool lightTheme =MediaQuery.of(context).platformBrightness == Brightness.light ? true : false;    //Screen Height and Width    var width = MediaQuery.of(context).size.width * 1;    var height = MediaQuery.of(context).size.height * 1;    //Format of dateTime    final format = DateFormat('MMMM dd, yyyy');    //Parsing the dateTime from snapshot    DateTime dateTime = DateTime.parse(widget.snapshot.data!.articles![widget.index].publishedAt.toString());    //Root Widget    return Scaffold(      //App Bar of this class      appBar: AppBar(        elevation: 0,        //Title of appbar        title: Text(          'Top Headlines',          style: TextStyle(              fontFamily: 'nunitosSans_semiBold',              color: lightTheme ? Colors.black87 : Colors.white),        ),        backgroundColor: lightTheme ? Colors.white : Colors.grey.shade900,        centerTitle: true,        //Back Button on AppBar        leading: IconButton(          tooltip: "Navigation",          icon: Icon(            Icons.arrow_back_ios_sharp,            color: lightTheme ? Colors.black87 : Colors.white,            size: 25,          ),          onPressed: () {            Navigator.pop(context);          },        ),      ),      //Main body Container with Stack      body: Container(        width: width,        height: height,        color: lightTheme ? Colors.white : Colors.grey.shade900,        child: Stack(          children: [            //Headline News Image Stack            Container(              margin:const EdgeInsets.only(top: 3),              height: height * 0.4,              //Providing Border and border radius              decoration: BoxDecoration(                border: Border.all(                    width: 0.25,                    color: lightTheme ? Colors.black87 : Colors.white),                boxShadow: [                  BoxShadow(                      color: lightTheme ? Colors.transparent : Colors.transparent,                      blurRadius: 20,                      offset:const Offset(1, -1),                      spreadRadius: 0)                ],                borderRadius: const BorderRadius.only(                    topLeft: Radius.circular(20),                    topRight: Radius.circular(25)),              ),              //Main Image of News Headline with borderRadius              child: ClipRRect(                borderRadius: const BorderRadius.only(                    topLeft: Radius.circular(20),                    topRight: Radius.circular(25)),                child: CachedNetworkImage(                  fit: BoxFit.cover,                  imageUrl:widget.snapshot.data!.articles![widget.index].urlToImage.toString(),  //Image URL                  placeholder: (context, url) => Container( //PlaceHolder for Image until image is not loaded                    child: const SpinKitFadingCircle(                      color: Colors.amber,                      size: 50,                    ),                  ),                  //Error widget when Image failes to load                  errorWidget: (context, url, error) => const Center(                      child: Icon(                    Icons.error_outline,                    color: Colors.red,                  )),                ),              ),            ),            //HeadLine News Title and description Stack with Source and Publish time            Positioned(                bottom: 5,                left: 0,                right: 0,                //Continer with it's Shadow                child: Container(                  padding: const EdgeInsets.all(12),                  height: height * 0.51,                  //Providing border and shadow and Radisu                  decoration: BoxDecoration(                      boxShadow: [                        BoxShadow(                            color: lightTheme                                ? Colors.black12                                : Colors.grey.shade800,                            blurRadius: 5,                            offset: Offset(0, -3),                            spreadRadius: 1)                      ],                      color: lightTheme ? Colors.white : Colors.grey.shade900,                      borderRadius:const BorderRadius.only(                          topLeft: Radius.circular(20),                          topRight: Radius.circular(25)),                      border: Border.all(                          width: 0.2,                          color: lightTheme ? Colors.black87 : Colors.grey)),                  //Scrollable details if overflows                  child: SingleChildScrollView(                      child:Column(                        mainAxisAlignment: MainAxisAlignment.start,                        crossAxisAlignment: CrossAxisAlignment.center,                        children: [                          //Title of headline news                          Container(                            width: width,                            child: Text(                              maxLines: 3,                              overflow: TextOverflow.ellipsis,                              widget.snapshot.data!.articles![widget.index].title.toString(),                              style: TextStyle(                                  fontSize: 19,                                  fontFamily: 'nunitosSans_bold',                                  fontWeight: FontWeight.bold,                                  color: lightTheme ? Colors.black : Colors.white),                            ),                          ),                          //Source and publish date in Row                          Container(                            margin:const EdgeInsets.only(top: 3),                            alignment: Alignment.center,                            width: width,                            height: height * 0.05,                            child: Row(                              mainAxisAlignment: MainAxisAlignment.spaceBetween,                              crossAxisAlignment: CrossAxisAlignment.center,                              children: [                                //Source name with click feature                                InkWell(                                  onTap: () {                                    //Redirecting to Webview class with web URL                                    Navigator.push(                                        context,                                        MaterialPageRoute(                                            builder: (context) => webview(                                                webUrl: widget.snapshot                                                    .data!.articles![widget.index].url                                                    .toString())));                                  },                                  //Source title                                  child: Text(                                    widget.snapshot.data!.articles![widget.index].source!.name                                        .toString(),                                    style: const TextStyle(                                        fontSize: 12,                                        fontFamily: 'nunitosSans_regular',                                        color: Colors.blue,                                        fontWeight: FontWeight.bold),                                  ),                                ),                                //Publish time from snapshot in dateTime format                                Text(                                  format.format(dateTime),                                  style: TextStyle(                                      fontSize: 11,                                      color: lightTheme                                          ? Colors.grey.shade800                                          : Colors.grey.shade200,                                      fontFamily: 'nunitosSans_regular',                                      fontWeight: FontWeight.bold),                                ),                              ],                            ),                          ),                          //Content or description from snapshot depending which one is not null                          Container(                            margin:const EdgeInsets.only(top: 5),                            alignment: Alignment.center,                            child: Text(                              widget.snapshot.data!.articles![widget.index].content == null     //If Content is null then description will be show                                  ? widget.snapshot.data!.articles![widget.index].description   //Otherwise the Content will be shown there                                      .toString()                                  : widget.snapshot.data!.articles![widget.index].content                                      .toString(),                              style: TextStyle(                                  fontSize: 16,                                  fontFamily: 'nunitosSans_regular',                                  color: lightTheme                                      ? Colors.grey.shade800                                      : Colors.grey.shade200,                                  fontWeight: FontWeight.normal),                            ),                          ),                          //Read more btn to redirect for full web article in webview class                          InkWell(                              onTap: () {                                //Redirecting to webview with web URL                                Navigator.push(                                    context,                                    MaterialPageRoute(                                        builder: (context) => webview(                                            webUrl: widget.snapshot                                                .data!.articles![widget.index].url                                                .toString())));                              },                              //Read more Button Design                              child: Container(                                margin: const EdgeInsets.only(bottom: 5,top: 0),                                alignment: Alignment.center,                                width: double.infinity,                                height: height * 0.1,                                child: Container(                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),                                  decoration: BoxDecoration(                                    border: Border.all(color:lightTheme                                            ? Colors.black87                                            : Colors.white,                                      width: 0.5                                    ),                                      borderRadius: const BorderRadius.all(                                          Radius.circular(4))),                                  child: Text(                                    'Read More',                                    style: TextStyle(                                        fontSize: 15,                                        color: lightTheme                                            ? Colors.black87                                            : Colors.white,                                        fontFamily: 'nunitosSans_regular'),                                  ),                                ),                              ))                        ],                      ),                    ),                )),          ],        ),      ),    );  }}