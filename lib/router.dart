import 'package:flutter/material.dart';
import 'package:karma/landingPage.dart';
import 'package:karma/nextpage.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case LandingPage.routeName:
      return MaterialPageRoute(builder: (context)=>const LandingPage()
      );
    case NextPage.routeName:
      return MaterialPageRoute(builder: (context)=>const NextPage()
      );
    default:
      return MaterialPageRoute(builder: (context)=>
      const Scaffold(
        body: Text('This Page isn\'t developed yet. Come Later :)'),
      ),);

  }
}