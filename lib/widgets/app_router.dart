import 'package:apartment_project/widgets/custom_appbar.dart';
import 'package:apartment_project/widgets/custom_note_list.dart';
import 'package:apartment_project/widgets/search_bar/custom_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoute{
  static Route onGererateRoute(RouteSettings settings){
    print("Route: ${settings.name}");
    switch (settings.name){
      case Filter.routeName:
        return Filter.route();
      case NoteList.routeName:
        return NoteList.route();
      default:
        return _errorRoute();
    }
  }
  static _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: AppBarTitle(),
          ),
        ));
  }
}