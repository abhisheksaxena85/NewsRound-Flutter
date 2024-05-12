/*  Widget of dashboard headline,  from selected countries,** Dashboard Headlines Widget ***/import 'package:cached_network_image/cached_network_image.dart';import 'package:flutter/material.dart';import 'package:flutter_spinkit/flutter_spinkit.dart';import 'package:intl/intl.dart';import 'package:news_round/models/newsHeadlinesAPImodel.dart';import 'package:news_round/pages/dashboardWidgets/headLineDetails.dart';import 'package:news_round/pages/webview.dart';import 'package:shared_preferences/shared_preferences.dart';Future<void> settingData() async {  SharedPreferences preferences = await SharedPreferences.getInstance();  preferences.setString("countryCode", "in");}//Building headline news List with BuilderWidget headlineListViewBuilder(AsyncSnapshot<newsHeadlinesAPImodel> snapshot, double width, double height,bool lightTheme,BuildContext context){ //Gettng required data from parent widget class  //Defining Date format for publish date on each headline item  final format = DateFormat('MMMM dd, yyyy');  //Using listViewBuilder for Main List of NewsHeadLine  return ListView.builder(        scrollDirection: Axis.horizontal, //Scroll Direction of list        itemCount: snapshot.data!.articles!.length,        //Building items after making API call        itemBuilder: (context, index) {          //Getting date time from API data of each headline item          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());          //Returning null widget if Content and Description is null of a particular item from API          if (snapshot.data!.articles![index].content == null && snapshot.data!.articles![index].description == null) {            return Container();          //Otherwise returing widget with values and OnClick function          } else {            return InkWell(              //Click Function CallBack on each item of HeadLine List View              onTap: () {                //Redirecting to another class for details                Navigator.push(                    context,                    MaterialPageRoute(                        builder: (context) => headLineDetails(                          snapshot: snapshot,                          index: index,                        )));              },              //Each item Widget              child: Container(                width: width * 0.9,                height: width * 0.6,                padding: EdgeInsets.symmetric(                    horizontal: width * 0.04, vertical: width * 0.02), //Providing margin symmetically                //Using Stack to put Image & Title on top of Each Other                child: Stack(                  alignment: Alignment.center,                  children: [                    //Image View for Main HeadLine News Image from API response                    ClipRRect(                        borderRadius:                        const BorderRadius.all(Radius.circular(15)),                        child: Container(                          decoration: BoxDecoration(                            color:lightTheme? Colors.grey.shade200: Colors.black54,                          ),                          //For a NetWork Image                          child: CachedNetworkImage(  //Normal Image loads from network whenever the focus is on that,                            fit: BoxFit.cover,        //But the CachedNetworKImage Loads a image for runtime until the class is disposed, It stays there as a cached memory data                            width: width,                            height: height,                            //Showing placeHolder until the image is loading                            placeholder: (context, url) => Container(                              child: SpinKitFadingCircle(                                color: lightTheme? Colors.black87:Colors.white,                                size: 50,                              ),                            ),                            //Error widget when image failed to load                            errorWidget: (context, url, error) =>                            const Icon(                              Icons.image_not_supported_outlined,                              color: Colors.red,                            ),                            //Image URL from API response                            imageUrl: snapshot                                .data!.articles![index].urlToImage                                .toString(),                          ),                        )),                    //Title Area of Stack with Source & Publish Time                    Positioned(                      bottom: 20,                      //Main Container of details on ImageView of Headline news Item                      child: Container(                          alignment: Alignment.bottomCenter,                          margin: const EdgeInsets.only(left: 5, right: 5),                          height: height * 0.22,                          //Adding color according to theme & border radius                          decoration: BoxDecoration(                              color:lightTheme? Colors.white:Colors.grey.shade900,                              borderRadius:const BorderRadius.all(                                  Radius.circular(10))),                          //Padding from each side                          padding: const EdgeInsets.only(                              left: 7, right: 7, top: 10, bottom: 10),                          //Inside children widgets                          child: Column(                            mainAxisAlignment: MainAxisAlignment.center,                            children: [                              //Title of Headline article                              SizedBox(                                  width: width * 0.7,                                  child: Text(                                    maxLines: 2,                                    overflow: TextOverflow.ellipsis,                                    snapshot                                        .data!.articles![index].title                                        .toString(),                                    style: TextStyle(                                        fontSize: 15,                                        color:lightTheme? Colors.black:Colors.white,                                        fontFamily:                                        'nunitosSans_regular',                                        fontWeight: FontWeight.bold),                                  )),                              //Adding Spapcer                              const Spacer(),                              //Row of Source and Publish time                              Container(                                  width: width * 0.7,                                  child: Row(                                    mainAxisAlignment:                                    MainAxisAlignment.spaceBetween,                                    crossAxisAlignment:                                    CrossAxisAlignment.center,                                    children: [                                      //Source Name Text with onClick feature                                      InkWell(                                        onTap: (){                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> webview(webUrl: snapshot.data!.articles![index].url!.toString()) ));                                        },                                        child: Text(                                          overflow: TextOverflow.ellipsis,                                          snapshot.data!.articles![index]                                              .source!.name!.substring(0,                                              snapshot.data!.articles![index]                                                  .source!.name!.length>=15?15:snapshot.data!.articles![index]                                                  .source!.name!.length                                          ).toString(),                                          style:const TextStyle(                                              fontSize: 12,                                              color: Colors.blue,                                              fontFamily:                                              'nunitosSans_regular',                                              fontWeight:                                              FontWeight.bold),                                        ),                                      ),                                      //Publish time text                                      Text(                                        format.format(dateTime),                                        style: TextStyle(                                            fontSize: 11,                                            color: lightTheme                                                ? Colors.grey.shade800                                                : Colors.grey.shade200,                                            fontFamily:                                            'nunitosSans_regular',                                            fontWeight:                                            FontWeight.bold),                                      ),                                    ],                                  ))                            ],                          )),                    ),                  ],                ),              ),            );          }        });}