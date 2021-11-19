import 'package:apartment_project/models/database.dart';
import 'package:apartment_project/models/user.dart';
import 'package:apartment_project/screens/edit_screen.dart';
import 'package:apartment_project/shares/const.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/widgets/custom_detail_item_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Databases.readData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index];
              String docID = snapshot.data!.docs[index].id;
              String nameApm = noteInfo.get('Name Rental');
              String address = noteInfo.get('Address');
              String city = noteInfo.get('City');
              String furniture = noteInfo.get('Furniture Property');
              String type = noteInfo.get('Type Property');
              int numBed = noteInfo.get('No Bed');
              int numKit = noteInfo.get('No Kit');
              int numBath = noteInfo.get('No Bath');
              int price = noteInfo.get('Price');
              String nameReporter = noteInfo.get('Name Reporter');
              String note = noteInfo.get('Note');
              double ratingStar = noteInfo.get('Rating Star');
              String createdTime = noteInfo.get('createdTime');

              return Ink(
                decoration: BoxDecoration(
                  color: CustomColors.firebaseGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () =>  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          DetailApartment(data: noteInfo))
                  ),
                  title: Text(
                    "$nameApm  ($ratingStar) Star",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: styleHeading_2Text.copyWith(color: CustomColors.firebaseBlack.withOpacity(0.8)),
                  ),
                  subtitle: Text(
                    "$price\$/month",
                    maxLines: 2 ,
                    overflow: TextOverflow.ellipsis,
                    style: styleHeading_2Text.copyWith(color: CustomColors.firebaseAmber),
                  ),
                  leading: const Icon(Icons.home, size: 38, color: Colors.yellow,),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 28,
                    color: Colors.lightGreenAccent,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditScreen(
                            currentApartmentName: nameApm,
                            currentAddress: address,
                            currentCity: city,
                            currentFurniture: furniture,
                            currentType: type,
                            currentNumKit: numKit,
                            currentNumBed: numBed,
                            currentNumBath: numBath,
                            currentPrice: price,
                            currentNameReporter: nameReporter,
                            currentNote: note,
                            currentStar: ratingStar,
                            documentId: docID,
                          ),
                        ),
                      );
                    },
                  )
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }
}