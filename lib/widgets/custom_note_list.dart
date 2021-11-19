import 'package:apartment_project/models/database.dart';
import 'package:apartment_project/shares/const.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  static const String routeName = '/note';

  static Route route(){
    return MaterialPageRoute(
      builder: (_) => NoteList(),
      settings: RouteSettings(name: routeName)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: StreamBuilder<QuerySnapshot?>(
            stream: Databases.readNote(),
            builder: (context, snapshot) {
              return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 16.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var noteInfo = snapshot.data!.docs[index];
                    String note = noteInfo.get('NoteRef');
                    String createdTime = noteInfo.get('createdTime');
                    return Ink(
                      decoration: BoxDecoration(
                        color: CustomColors.firebaseGrey
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8.0),
                          ),
                          title: Text(
                            "Note: $note",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: styleHeading_2Text.copyWith(
                                color: CustomColors.firebaseBlack
                                    .withOpacity(0.8)),
                          ),
                          subtitle: Text(
                            "Created :$createdTime",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleHeading_2Text.copyWith(
                                color:
                                CustomColors.firebaseAmber),
                          ),
                          leading: const Icon(
                            Icons.note,
                            size: 38,
                            color: Colors.yellow,
                          ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
