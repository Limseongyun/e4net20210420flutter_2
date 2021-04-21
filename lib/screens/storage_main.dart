import 'package:flutter/material.dart';

class StorageMain extends StatefulWidget {
  @override
  _StorageMainState createState() => _StorageMainState();
}

class _StorageMainState extends State<StorageMain> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Container(),
    );
  }

  Widget getAppBar(BuildContext context){
    return AppBar(
      title: Text('FireStorage!'),
      actions: [
        IconButton(
            icon: Icon(Icons.note_add_outlined),
            onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.create_new_folder),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.wifi_tethering),
          onPressed: (){},
        ),
      ],
    );
  }
}
