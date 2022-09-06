import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  Detail(this.data,{Key? key}) : super(key: key);
  Map data;


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Details'),
    ),
    floatingActionButton: FloatingActionButton(onPressed: () {

      showModalBottomSheet(
        context: context, builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(),
              ElevatedButton(onPressed: (){}, child: Text('Submit'))
            ],
          ),
        );
      }, );

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
          child: ListView.builder(
              itemCount: 40,
              itemBuilder: (contexr,index){
            return ListTile(title: Text('Hello world'),);
          }),
        ),
      ],
    )
    );
  }
}
