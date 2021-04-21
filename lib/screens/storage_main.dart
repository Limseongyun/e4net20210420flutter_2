import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_e4net_2/screens/qrscan_screen.dart';
import 'package:flutter_e4net_2/screens/webview_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class StorageMain extends StatefulWidget {
  @override
  _StorageMainState createState() => _StorageMainState();
}

class _StorageMainState extends State<StorageMain> {
  String nowPath = "/";
  List<PlatformFile> _paths;
  List<fs.UploadTask>  _tasks = <fs.UploadTask>[];
  String mkdir = null;
  bool isMkdir = false;
  bool isLoading = false;
  List<ListTile> myList =[];


  openFileExplorer() async{
    isMkdir = false;
    mkdir = null;
    try{
      _paths = (await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true)).files;
    } on PlatformException catch(e){
      print('Unsupported operation' + e.toString());
    } catch(ex){
      print(ex);
    }
    if(!mounted) return;
    print(_paths);
    //TODO 파일을 선택했으니까 파일을 업로드 해야함
  }

  Future<List<ListTile>> getMyLists({String path, String mkdirName}) async {
    setState(() {
      isLoading = true;
    });
    io.Directory appDocDir = await getApplicationDocumentsDirectory();
    fs.ListResult result = await fs.FirebaseStorage.instance.ref(path).listAll();
    List<ListTile> temp = [];
    temp.clear();
    print('nowPath : $nowPath');
    temp.add(ListTile(
      title: Text(nowPath),
    ));

    if(nowPath.split('/').length > 2){
      temp.add(ListTile(
        title: Text('...'),
        leading: Icon(Icons.keyboard_backspace),
        onTap: (){
          var nowTemp = nowPath.split('/');
          nowTemp.removeAt(nowTemp.length-2);
          nowPath = nowTemp.join("/");
          isMkdir = false;
          mkdir = null;
          myListsHandler(nowPath: nowPath);
        },
      ));
    }

    result.prefixes.forEach((folder){
      temp.add(ListTile(
        leading: Icon(Icons.folder_rounded),
        title: Text(folder.name),
        onTap: (){
          nowPath = '$nowPath${folder.name}/';
          isMkdir = false;
          mkdir = null;
          myListsHandler(nowPath: nowPath);
        },
      ));
    });

    if(isMkdir){
      temp.add(ListTile(
        leading: Icon(Icons.folder_special_outlined),
        title: Text(mkdir),
        onTap: (){
          print('!!!mkdir!!!');
          nowPath = '$nowPath$mkdir/';
          isMkdir = false;
          mkdir = null;
          myListsHandler(nowPath: nowPath);
        },
      ));
    }

    result.items.forEach((file) {
      //TODO 앱디렉토리에 파일이 존재하는지 체크
      temp.add(ListTile(
        title: Text(file.name),
        leading: Stack(
          children: [

            Icon(Icons.file_copy_outlined),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: 'down',child: Text('download'),),
              PopupMenuItem(value: 'del',child: Text('delete'),),
              PopupMenuItem(value: 'open',child: Text('open'),),
            ];
          },
          onSelected: (value) {
            if(value =='del'){
              //TODO 지움
            }
            if(value == 'down'){
              //TODO 다운
            }
            if(value == 'open'){
              //TODO 오픈
            }
          },
        ),
      ));
    });
    return temp;
  }
  myListsHandler({@required String nowPath}){
    getMyLists(path: nowPath).then((value){
      setState(() {
        isLoading = false;
        myList = value;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    myListsHandler(nowPath: nowPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLoading ? Colors.grey: Colors.white,
      appBar: getAppBar(context),
      body: Container(
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: isLoading,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return myList[index];
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: myList.length),
            ),
            if(false)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(maxHeight: 200),
                //TODO child 생성
              ),
            )
          ],
        ),
      )
    );
  }

  Widget getAppBar(BuildContext context){
    final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
    return AppBar(
      title: Text('FireStorage!'),
      actions: [
        IconButton(
            icon: Icon(Icons.note_add_outlined),
            onPressed: (){
              openFileExplorer();
            },
        ),
        IconButton(
          icon: Icon(Icons.create_new_folder),
          onPressed: () async{
            var res = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('임시 디렉토리 명을 입력해 주세요!'),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (newValue) {
                          Navigator.pop(context, newValue);
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text('취소')
                      ),
                      TextButton(
                          onPressed: (){
                            _formKey.currentState.save();
                          },
                          child: Text('확인')
                      ),
                    ],
                  );
                },
            );
            print('디렉토리 팝업 결과 : $res');
            //TODO 만약 값이 있다면 임시디렉토리 생성
          },
        ),
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return QrScanScreen();
                    },
                )
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.wifi_tethering),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return WebViewScreen();
                },)
            );
          },
        ),
      ],
    );
  }
}
