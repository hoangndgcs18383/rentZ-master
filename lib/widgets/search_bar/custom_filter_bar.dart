import 'package:apartment_project/models/type_model.dart';
import 'package:apartment_project/screens/dashboard_screen.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  // static const String routeName = '/filter';
  //
  // static Route route(){
  //   return MaterialPageRoute(
  //     builder: (_) => FilterBar(),
  //     settings: RouteSettings(name: routeName)
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type Property',
              style: TextStyle(
                color: CustomColors.firebaseWhite,
                fontSize: 22.0,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTypeFilter(types: TypeModel.types),
            Text(
              'Furniture Property',
              style: TextStyle(
                color: CustomColors.firebaseWhite,
                fontSize: 22.0,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomFurnitureFilter(furniture: FurnitureModel.furniture,),
          ],
        ),
      ),
    );
  }
}

class CustomTypeFilter extends StatelessWidget {
  final List<TypeModel> types;
  const CustomTypeFilter({Key? key, required this.types}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types
          .map(
            (type) => InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Text(type.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class CustomFurnitureFilter extends StatelessWidget {
  final List<FurnitureModel> furniture;
  const CustomFurnitureFilter({Key? key, required this.furniture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: furniture
          .map(
            (type) => InkWell(
          onTap: (){

          },
          child: Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Text(type.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
