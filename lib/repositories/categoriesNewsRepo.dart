import 'dart:convert';import 'package:http/http.dart' as http;import 'package:news_round/models/categoryNewsAPImodel.dart';class categoriesNewsRepo{  //Repo => For Categories news  Future<categoryNewsAPImodel> fetchCategoryNews(String? url) async{    final response = await http.get(Uri.parse(url!)); //Parsing the API get data    var data = jsonDecode(response.body); //Decoding the body of received data    //When call successful    if(response.statusCode==200){      return categoryNewsAPImodel.fromJson(data);    }else if(response.statusCode ==403){      throw('Error: something went wrong with image & Status code is ${response.statusCode.toString()}');    }else{      throw('Error: something went wrong');    }  }}