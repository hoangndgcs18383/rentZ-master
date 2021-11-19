import 'package:apartment_project/models/database.dart';
import 'package:apartment_project/shares/const.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/shares/vadidator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
final FirebaseAuth auth = FirebaseAuth.instance;
String formatDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
final CollectionReference _collectionReference = FirebaseFirestore.instance
    .collection('data')
    .doc('rentalZ')
    .collection(auth.currentUser!.uid);

class DetailApartment extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;
  const DetailApartment({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailApartment> createState() => _DetailApartmentState();
}

class _DetailApartmentState extends State<DetailApartment> {
  double rating = 0;

  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return StreamBuilder<QuerySnapshot>(
        stream: Databases.readData(),
        builder: (context, snapshot) {
          final address = widget.data.get('Address');
          final city = widget.data.get('City');
          final nameApm = widget.data.get('Name Rental');
          final numBed = widget.data.get('No Bed');
          final numKit = widget.data.get('No Kit');
          final numBath = widget.data.get('No Bath');
          final price = widget.data.get('Price');
          final note = widget.data.get('Note');
          final furniture = widget.data.get('Furniture Property');
          final type = widget.data.get('Type Property');
          final nameReporter = widget.data.get('Name Reporter');
          final createdTime = widget.data.get('createdTime');
          final ratingStar = widget.data.get('Rating Star');

        return Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 330,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 330,
                      child: Image.asset("assets/images/logo.jpeg", fit: BoxFit.cover,),
                    ),
                    Positioned(
                      top: 42,
                      left: 16,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.grey
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: CustomColors.firebaseWhite,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Expanded(
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: media.size.width-112,
                                    child: Text("Rental Name: $nameApm",
                                      style: styleHeading_1Text.copyWith(color: CustomColors.firebaseAmber),
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Container(
                                    width: media.size.width-112,
                                    child: Text("$address, $city",
                                      style: styleHeading_2Text.copyWith(color: CustomColors.firebaseYellow),
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Text("\"$note\"",
                                    style: styleHeading_2Text.copyWith(color: CustomColors.firebaseWhite),
                                  ),
                                  SizedBox(height: 16,),
                                  Text("$price\$ per month",
                                    style: styleHeading_3Text,
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/note');
                                  },
                                  icon: Icon(Icons.comment))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bed, size: 20, color: Colors.white,),
                                  SizedBox(width: 4,),
                                  Text("$numBed Bedroom", style: TextStyle(fontSize: 16 ,color: CustomColors.googleBackground, fontWeight: FontWeight.bold),)
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.kitchen, size: 20, color: Colors.white,),
                                  SizedBox(width: 4,),
                                  Text("$numKit Kitten", style: TextStyle(fontSize: 16 ,color: CustomColors.googleBackground, fontWeight: FontWeight.bold),)
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.bathroom, size: 20, color: Colors.white,),
                                  SizedBox(width: 4,),
                                  Text("$numBath Bath", style: TextStyle(fontSize: 16 ,color: CustomColors.googleBackground, fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(
                            left: 32, right: 32),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                child: ClipRRect(
                                  child: Image.asset("assets/images/logo.jpeg", fit: BoxFit.fill,),
                                  borderRadius: BorderRadius.all(Radius.circular(24)),
                                ),
                              ),
                              SizedBox(width: 16,),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("$nameReporter", style: TextStyle(
                                        color: CustomColors.firebaseYellow,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Owner", style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),)
                                    ],
                              )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () {},
                                  child: Text("Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Divider(),
                        SizedBox(height: 8,),
                        Container(
                          margin: EdgeInsets.only(left: 32, right: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Property Type : $type", style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Property Furniture - $furniture",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      //UI
                      // Container(
                      //   margin: EdgeInsets.only(left: 32, right: 32),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text("Features", style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w600,
                      //       ),),
                      //       SizedBox(height: 16,),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.wifi, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Wifi", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.fitness_center, color: Colors.black38,),
                      //               SizedBox(width: 4,),
                      //               Text("Gym", style: TextStyle(
                      //                 color: CustomColors.googleBackground,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.local_cafe_rounded, color: Colors.brown,),
                      //               SizedBox(width: 4,),
                      //               Text("Cafe", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //
                      //         ],
                      //       ),
                      //       SizedBox(height: 8,),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.wifi, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Wifi", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.bed, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Bed", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.local_cafe_rounded, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Cafe", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //
                      //         ],
                      //       ),
                      //       SizedBox(height: 8,),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.wifi, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Wifi", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.bed, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Bed", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               Icon(Icons.local_cafe_rounded, color: Colors.green,),
                      //               SizedBox(width: 4,),
                      //               Text("Cafe", style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w500,
                      //               ),)
                      //             ],
                      //           ),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Add your note here",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Form(
                        child: TextFormField(
                          validator: (value) => Validator.validatePrice(value: value!),
                          maxLines: 1,
                          controller: _noteController,
                          cursorColor: CustomColors.firebaseYellow,
                          style: TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                            labelText: 'Note',
                            labelStyle:
                                TextStyle(color: CustomColors.firebaseYellow),
                            hintText: 'Optional',
                            hintStyle: TextStyle(
                              color:
                                  CustomColors.firebaseWhite.withOpacity(0.5),
                            ),
                            fillColor: Colors.lightGreen.withOpacity(0.3),
                            filled: true,
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: CustomColors.firebaseAmber,
                                width: 5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: CustomColors.firebaseWhite,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 5,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              CustomColors.firebaseGreen,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() async {
                              setState(() {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                        'Create succesfully at $formatDate')));
                              });
                              await Databases.addNote(
                                  note: _noteController.text,
                                  createdTime: formatDate);
                              FocusScope.of(context).unfocus();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text(
                              'ADD ITEM',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.firebaseBlack,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Star: $ratingStar',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                            RatingBar.builder(
                                initialRating: ratingStar,
                                minRating: 1,
                                itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                onRatingUpdate: (rating) {
                                  setState(() {});
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

                // SizedBox(height: 18,),
                // Container(
                //   child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         primary: Colors.green,
                //         onPrimary: Colors.white,
                //       ),
                //       onPressed: () {},
                //       child: Container(
                //           alignment: Alignment.center,
                //           padding: EdgeInsets.symmetric(vertical: 16),
                //           child: Text("Book Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),))
                //   ),
                // ),
              ],
            ),
          );
        });
  }
}
