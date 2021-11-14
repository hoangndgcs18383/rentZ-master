import 'package:apartment_project/models/filter/selected_list_controller.dart';
import 'package:apartment_project/models/type_model.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import '../custom_detail_item_list.dart';
import 'package:get/get.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Search extends SearchDelegate {
  late String name;
  Search({required this.name});

  static const String routeName = '/filter';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => Filter(), settings: RouteSettings(name: routeName));
  }

  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('data')
      .doc(auth.currentUser!.uid)
      .collection('rent');

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () {
          Navigator.pushNamed(context, '/filter');
          // if (query.isEmpty) {
          //   close(context, null);
          // } else {
          //   query = '';
          //   showSuggestions(context);
          // }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.snapshots().asBroadcastStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) => element[name]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(
              child: Text("No search by $name found!"),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element[name]
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String address = data.get('Address');
                  final String nameRental = data.get('Name Rental');
                  final int price = data.get('Price');

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 20.0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: CustomColors.firebaseGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailApartment(data: data)));
                        },
                        leading: Icon(
                          Icons.home_work,
                          size: 64,
                        ),
                        title: Text('Rental: $nameRental - Cost: $price\$'),
                        subtitle: Text("Address: $address"),
                        trailing: Icon(Icons.access_alarm),
                        tileColor: Colors.lightBlueAccent.withOpacity(0.5),
                        contentPadding: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  );
                })
              ],
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.snapshots().asBroadcastStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) => element[name]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(
              child: Text("No search by $name found!"),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element[name]
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String address = data.get('Address');
                  final String nameRental = data.get('Name Rental');
                  final String nameReporter = data.get('Name Reporter');

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 20.0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: CustomColors.firebaseGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailApartment(data: data)));
                        },
                        leading: Icon(
                          Icons.home_work,
                          size: 64,
                        ),
                        title: Text(
                            'Rental: $nameRental - Reprter: $nameReporter'),
                        subtitle: Text("Address: $address"),
                        trailing: Icon(Icons.access_alarm),
                        tileColor: Colors.lightBlueAccent.withOpacity(0.5),
                        contentPadding: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  );
                })
              ],
            );
          }
        });
  }
}

class Filter extends StatelessWidget {
  static const String routeName = '/filter';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => Filter(), settings: RouteSettings(name: routeName));
  }

  var controller = Get.put(SelectedListController());
  List<String> defaultList = [
    'Name Rental',
    'Name Reporter',
    'Address',
    'City',
    'No Bed',
    'No Kit',
    'No Bath',
    'Price',
    'Rating Star',
  ];

  Filter({Key? key}) : super(key: key);
  void openFilterDialog(context) async {
    await FilterListDialog.display<String>(context,
        listData: defaultList,
        selectedListData: controller.selectedList,
        headlineText: 'Properties',
        closeIconColor: CustomColors.firebaseGrey,
        applyButtonTextStyle: TextStyle(fontSize: 20),
        searchFieldHintText: 'Search Here...',
        choiceChipLabel: (item) => item,
        validateSelectedItem: (list, val) => list!.contains(val),
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                    element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          } else {
            return [];
          }
        },
        onApplyButtonClick: (list) {
          controller.selectedList.value = (List<String>.from(list!));
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openFilterDialog(context);
          },
          backgroundColor: CustomColors.firebaseOrange,
          child: const Icon(
            Icons.search,
            color: Colors.white,
            size: 32,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name Property',
                  style: TextStyle(
                    color: CustomColors.firebaseWhite,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => controller.selectedList.length == 0
                    ? Text('No Name Found',
                        style: TextStyle(
                          color: CustomColors.firebaseWhite,
                          fontSize: 22.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ))
                    : Wrap(
                        children: controller.selectedList
                            .map((String e) => Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Chip(
                                        label: TextButton(
                                          child: Text(e),
                                          onPressed: () {
                                            showSearch(
                                                context: context,
                                                delegate: Search(name: e));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
