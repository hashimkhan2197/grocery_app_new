import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text('Feedback',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('improvements').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var snapshotData = snapshot.data.documents;
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),

                  ///FeedBack Section
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Text(
                      "Feedback Section",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 25,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.documents[index];
                      return Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white70),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data['number'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                data['message'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400
                                )),
                          ),
                          //    trailing: Text(data['status'])
                        ),
                      );
                    },
                    itemCount: snapshot.data.documents.length,
                  )

                ],
              ),
            );
          }
      ),
    );
  }
}
