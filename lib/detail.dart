import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  Detail(this.data, {Key? key}) : super(key: key) {
    //Step 1.2:Get the reference of the document
    _documentReference =
        FirebaseFirestore.instance.collection('posts').doc(data['id']);
    //Step 2.2:Get the reference of the comments collection
    _referenceComments = _documentReference.collection('comments');
    //Step 4.2:Get the stream
    _streamComments =
        _referenceComments.orderBy('posted_on', descending: true).snapshots(); //Step 9: Add orderBy orderBy('posted_on', descending: true)
  }

  Map data;
  late DocumentReference
      _documentReference; //Step 1.1: Create field for the document reference
  late CollectionReference
      _referenceComments; //Step 2.1: Create field for the comments collection
  late Stream<QuerySnapshot>
      _streamComments; //Step 4.1: Create fiels for the comments stream
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                TextEditingController controller = TextEditingController();
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> commentToAdd = {
                              //Step 8.2: Change type to Map<String,dynamic>
                              'comment_text': controller.text,
                              'posted_on': FieldValue.serverTimestamp()
                              //Step 8.1: Add ServerTimestamp
                            };

                            //Step 3.1: Add the comment to the sub-collection comments
                            _referenceComments.add(commentToAdd);

                            //Step 3.2: Dismiss the bottom sheet
                            Navigator.of(context).pop();
                          },
                          child: Text('Submit'))
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.send),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                color: Colors.black12,
                padding: EdgeInsets.all(18),
                child: Text(data['title'])),
            Expanded(
              child: buildCommentsListView(),
            ),
          ],
        ));
  }

  StreamBuilder buildCommentsListView() {
    //Step 5: Add a StreamBuilder
    return StreamBuilder<QuerySnapshot>(
        stream: _streamComments,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Some error occurred: ${snapshot.error}');
          }

          if (snapshot.hasData) {
            //Step 6: Get the data
            QuerySnapshot data = snapshot.data;
            List<QueryDocumentSnapshot> documents = data.docs;
            List<Map> comments = documents
                .map((e) =>
                    {'comment_id': e.id, 'comment_text': e['comment_text']})
                .toList();

            //Step 7: Display the comment on a ListView
            return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  Map thisComment = comments[index];
                  return ListTile(
                    title: Text(thisComment['comment_text']),
                  );
                });
          }

          return CircularProgressIndicator();
        });
  }
}
