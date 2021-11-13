import 'package:apartment_project/models/apartments.dart';
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
      stream: ApartmentData.readApartments(),
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
              String nameApm = noteInfo.get('nameApm');
              String address = noteInfo.get('address');
              String city = noteInfo.get('city');
              String furniture = noteInfo.get('furniture');
              String type = noteInfo.get('type');
              int numBed = noteInfo.get('numBed');
              int numKit = noteInfo.get('numKit');
              int numBath = noteInfo.get('numBath');
              int price = noteInfo.get('price');
              String nameReporter = noteInfo.get('nameOwn');
              String note = noteInfo.get('note');

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
                    "$nameApm posted by $nameReporter",
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
                    iconSize: 38,
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