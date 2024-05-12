import 'package:cached_network_image/cached_network_image.dart';import 'package:flutter/foundation.dart';import 'package:flutter/material.dart';import 'package:flutter_spinkit/flutter_spinkit.dart';import 'package:news_round/models/categoryNewsAPImodel.dart';import 'package:news_round/newsViewModel/categoriesNewsViewModel.dart';import 'package:news_round/pages/dashboardWidgets/categoryContentDetails.dart';class categoriesContent extends StatefulWidget {  //Gettin this data from dashboardScreen  final List<String> selectedCategories;  final bool lightTheme;  final String? countryCode;  final BuildContext context;  final double width;  final double height;  categoriesContent(      {required this.selectedCategories,      required this.lightTheme,      required this.countryCode,      required this.context,      required this.width,      required this.height});  @override  State<categoriesContent> createState() => _categoriesContentState();}class _categoriesContentState extends State<categoriesContent> {  //API Url for Category news  String? APIbaseUrl = 'https://newsapi.org/v2/everything?q=';  String? category = "Technology";  String? APIkeyUrl =      '&language=en&pageSize=15&apiKey=a42859103b874063a56b0e10754d9de0';  @override  Widget build(BuildContext context) {    //ThemeMode boolean    bool theme = MediaQuery.of(context).platformBrightness == Brightness.light;    bool lightTheme = theme ? true : false;    //ListView to generate news according to categories provided by user as input    return Container(        color: widget.lightTheme ? Colors.blue : Colors.grey.shade900,        child: ListView.builder(          primary: false, //Disabling it's scroll capibility          shrinkWrap: true,          scrollDirection: Axis.vertical,          itemCount: widget.selectedCategories              .length, //Generating till Selected catefories left          itemBuilder: (context, index) {            if (kDebugMode) {              print(widget.selectedCategories[index].toString());            } //Debug only            //Main Category Item Bloc -> Each bloc contains another sub-blocs of items to show data of API according to categories            return Container(              color: widget.lightTheme ? Colors.white : Colors.grey.shade900,              //Future builder to make API call on each category              child: FutureBuilder(                future: categoriesNewsViewModel().fetchCategoryNews(                    "${APIbaseUrl!}${widget.selectedCategories[index]}+${category!}${APIkeyUrl!}"), //Calling API from Category Repository                builder: (c, s) {                  //When snapshot has data and Connection Satate is done                  if (s.hasData && s.connectionState == ConnectionState.done) {                    //When snapshot has data and load success                    //Returning the bloc of items of different-2 category's API call                    return Container(                      margin: const EdgeInsets.only(                          top: 20, bottom: 10, left: 10, right: 10),                      //Sub-Item ListView Builder                      child: categoryBuilder(                          s,                          c,                          widget.lightTheme,                          widget.selectedCategories[index].toString(),                          widget.width,                          widget.height,                          true,                          15),                    );                    //When snapshot not yet loaded and Connection State is loading                  } else if (s.connectionState == ConnectionState.waiting) {                    return SizedBox(                      child: index == 0                          ? Container(                              height: widget.height,                              padding: const EdgeInsets.only(                                  top: 50, bottom: 10, left: 5, right: 5),                              child: Center(                                child: SpinKitFadingCircle(                                  //Cicular SpinKit Animation till waiting                                  color: widget.lightTheme                                      ? Colors.black87                                      : Colors.white,                                ),                              ))                          : Container(),                    );                    //Showing Error only on first index -> when something goes wrong                  } else {                    return index == 0                        ? Container(                            height: widget.height,                            color: widget.lightTheme                                ? Colors.white                                : Colors.grey.shade900,                            alignment: Alignment.topCenter,                            margin: const EdgeInsets.only(                                top: 50, bottom: 10, left: 5, right: 5),                            child: Text(                              textAlign: TextAlign.center,                              'Something went wrong,\nPlease try again',                              style: TextStyle(                                  fontSize: 16,                                  color:                                      lightTheme ? Colors.black : Colors.white,                                  fontFamily: 'nunitosSans_semiBold',                                  fontWeight: FontWeight.bold),                            ),                          )                        : Container();                  }                },              ),            );          },        ));  }}Widget categoryBuilder(    AsyncSnapshot<categoryNewsAPImodel> snapshot,    BuildContext context,    bool lightTheme,    String category,    double width,    double height,    bool isTitleVisible,    int itemLenght) {  //Getting data from parent class  if (kDebugMode) {    print(category.toString());  }  if (snapshot.data!.articles!.isEmpty) {    return Container(      width: width * 0.5,      height: height * 0.4,      child: Column(        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.center,        children: [          Image.asset(            'assets/images/newsNotFoundImage.png',          ),          Container(            child: Text(              textAlign: TextAlign.center,              'Sorry, No Articles found!',              style: TextStyle(                  fontSize: 17,                  color: lightTheme ? Colors.black : Colors.white,                  fontFamily: 'nunitosSans_semiBold',                  fontWeight: FontWeight.bold),            ),          )        ],      ),    );  } else {    //Building subItems of a category with listViewBuilder    return Container(      margin: const EdgeInsets.only(top: 0),      child: ListView(        scrollDirection: Axis.vertical,        primary: false, //Disabling scroll        shrinkWrap: true,        children: [          //Category Title of each category bloc          Container(            margin: const EdgeInsets.only(bottom: 20),            child: isTitleVisible                ? Text(                    '$category :',                    style: TextStyle(                        fontSize: 20,                        color: lightTheme ? Colors.black87 : Colors.white,                        fontFamily: 'nunitosSans_semiBold'),                  )                : const SizedBox(),          ),          //Generating items of category bloc          ListView.builder(              shrinkWrap: true,              primary: false,              scrollDirection: Axis.vertical,              //Building only ten items in each Category bloc with ternary Logic              itemCount: snapshot.data!.articles!.length < itemLenght                  ? snapshot.data!.articles!.length                  : itemLenght,              itemBuilder: (context, index) {                //Each Item with Click Function Call Back, And Checking if item is removed or not                return snapshot.data!.articles![index].title.toString() ==                        '[Removed]'                    ? Container()                    : InkWell(                        onTap: () {                          //Redirecting to categoryContentDetails page to show more details to users                          Navigator.push(                              context,                              MaterialPageRoute(                                  builder: (context) => categoryContentDetails(                                        snapshot: snapshot,                                        index: index,                                        category: category,                                      )));                        },                        //Each Horizontal container with image and title and Click Feature                        child: Container(                          padding: const EdgeInsets.only(                              left: 0.2, top: 0.2, bottom: 0.2),                          margin: const EdgeInsets.only(bottom: 15),                          width: double.infinity,                          height: 100,                          alignment: Alignment.center,                          //Providing border and it's Radius                          decoration: BoxDecoration(                              color: lightTheme ? Colors.white : Colors.black38,                              borderRadius:                                  const BorderRadius.all(Radius.circular(10)),                              border: Border.all(                                  width: 0.2,                                  color: lightTheme                                      ? Colors.black87                                      : Colors.grey)),                          //Image and title                          child: Row(                            mainAxisAlignment: MainAxisAlignment.start,                            crossAxisAlignment: CrossAxisAlignment.center,                            children: [                              //Image View from with API                              ClipRRect(                                  borderRadius: const BorderRadius.only(                                      topLeft: Radius.circular(10),                                      bottomLeft: Radius.circular(10)),                                  child: Container(                                    color: lightTheme                                        ? Colors.grey.shade200                                        : Colors.black38,                                    //Cached Network Image                                    child: CachedNetworkImage(                                      fit: BoxFit.cover,                                      height: 100,                                      width: width * 0.35,                                      placeholder: (context, url) =>                                          SpinKitThreeBounce(                                        color: lightTheme                                            ? Colors.black54                                            : Colors.white,                                        size: 20,                                      ),                                      errorWidget: (context, url, error) =>                                          const Icon(                                        Icons.image_not_supported_outlined,                                        color: Colors.red,                                      ),                                      imageUrl: Uri.parse(snapshot.data!                                                  .articles![index].urlToImage                                                  .toString())                                              .isAbsolute                                          ? snapshot                                              .data!.articles![index].urlToImage                                              .toString()                                          : "https://img.freepik.com/premium-vector/error-message-laptop-screen-error-warning-sign-screen-computer-device_630277-341.jpg",                                    ),                                  )),                              //Title of each of Category Item child Contaner                              Container(                                  margin: const EdgeInsets.only(left: 15),                                  width: width * 0.48,                                  child: Text(                                    maxLines: 3,                                    overflow: TextOverflow.ellipsis,                                    snapshot.data!.articles![index].title                                        .toString(),                                    style: TextStyle(                                        fontSize: 15,                                        color: lightTheme                                            ? Colors.black                                            : Colors.white,                                        fontFamily: 'nunitosSans_regular',                                        fontWeight: FontWeight.bold),                                  )),                            ],                          ),                        ));              }),        ],      ),    );  }}