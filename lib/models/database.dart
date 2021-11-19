import 'package:apartment_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



final CollectionReference _mainCollection =  FirebaseFirestore.instance.collection('data');
final FirebaseAuth _auth = FirebaseAuth.instance;

class ApartmentField extends Equatable{
  String docId;
  String nameOwn;
  String rentalName;
  String address;
  String city;
  String furniture;
  String type;
  int numBed;
  int numKit;
  int numBath;
  int price;
  double star;
  String note;
  String createdTime;

  ApartmentField({
    required this.docId,
    required this.nameOwn,
    required this.rentalName,
    required this.address,
    required this.city,
    required this.furniture,
    required this.type,
    required this.numBed,
    required this.numKit,
    required this.numBath,
    required this.price,
    required this.star,
    required this.note,
    required this.createdTime
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    docId,
    nameOwn,
    rentalName,
    address,
    city,
    furniture,
    type,
    numBed,
    numKit,
    numBath,
    price,
    star,
    createdTime
  ];


  static List<ApartmentField> categories = [
    ApartmentField(
        docId: 'docId',
        nameOwn: 'nameOwn',
        rentalName: 'rentalName',
        address: 'address',
        city: 'city',
        furniture: 'furniture',
        type: 'type',
        numBed: 0,
        numKit: 0,
        numBath: 0,
        price: 0,
        star: 0.0,
        note: "note",
        createdTime: "createdTime")
  ];
}

class Databases{

  static Future<void> addData({
    required String nameOwn,
    required String rentalName,
    required String address,
    required String city,
    required String furniture,
    required String type,
    required int numBed,
    required int numKit,
    required int numBath,
    required int price,
    required double star,
    required String note,
    required String createdTime
  }) async{
    DocumentReference docApartment = _mainCollection.doc(_auth.currentUser!.uid).collection('rent').doc();

    Map<String, dynamic> apartmentData = <String,dynamic>{
        'Name Reporter' : nameOwn,
        'Name Rental' : rentalName,
        'Address': address,
        'City': city,
        'Furniture Property': furniture,
        'Type Property' : type,
        'No Bed' : numBed,
        'No Kit': numKit,
        'No Bath' : numBath,
        'Price' : price,
        'Note': note,
        'Rating Star': star,
        'createdTime': createdTime
    };
    await docApartment
        .set(apartmentData).whenComplete(() => print("The rental update $rentalName"))
        .catchError((error) => print(error));
  }
  static Stream<QuerySnapshot> readData() {
    CollectionReference docApartment =
    _mainCollection.doc(_auth.currentUser!.uid).collection('rent');
    return docApartment.snapshots();
  }


  static Future<void> updateData({
    required String docId,
    required String nameOwn,
    required String rentalName,
    required String address,
    required String city,
    required String furniture,
    required String type,
    required int numBed,
    required int numKit,
    required int numBath,
    required int price,
    required String note,
    required double star,
    required String updatedTime
  }) async{
    DocumentReference docApartment = _mainCollection.doc(_auth.currentUser!.uid).collection('rent').doc(docId);

    Map<String, dynamic> apartmentData = <String,dynamic>{
      'Name Reporter' : nameOwn,
      'Name Rental' : rentalName,
      'Address': address,
      'City': city,
      'Furniture Property': furniture,
      'Type Property' : type,
      'No Bed' : numBed,
      'No Kit': numKit,
      'No Bath' : numBath,
      'Price' : price,
      'Note': note,
      'Rating Star': star,
      'createdTime': updatedTime
    };
    await docApartment
        .set(apartmentData).whenComplete(() => print("The rental added $rentalName"))
        .catchError((error) => print(error));
  }

  static Future<void> deleteData({
    required String docId
    }) async{
    DocumentReference docApartment = _mainCollection.doc(_auth.currentUser!.uid).collection('rent').doc(docId);

    await docApartment
        .delete().whenComplete(() => print("The rental deleted"))
        .catchError((error) => print(error));
  }

  static Future<void> addNote({
    required String note,
    required String createdTime
  }) async{
    DocumentReference docApartment = _mainCollection.doc(_auth.currentUser!.uid).collection('note').doc();

    Map<String, dynamic> apartmentData = <String,dynamic>{
      'NoteRef': note,
      'createdTime': createdTime
    };
    await docApartment
        .set(apartmentData).whenComplete(() => print("The Note update $note"))
        .catchError((error) => print(error));
  }

  static Stream<QuerySnapshot> readNote() {
    CollectionReference docApartment =
    _mainCollection.doc(_auth.currentUser!.uid).collection('note');
    return docApartment.snapshots();
  }
}

