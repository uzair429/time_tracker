import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;
import 'package:provider/provider.dart';
import 'package:work_time_tracker/constants.dart';
import '../controller/organization_controller.dart';
import 'package:path/path.dart' as path;

class DisplayPdfScreen extends StatefulWidget {
  const DisplayPdfScreen({Key? key}) : super(key: key);

  @override
  State<DisplayPdfScreen> createState() => _DisplayPdfScreenState();
}

class _DisplayPdfScreenState extends State<DisplayPdfScreen> {

  List<File> pdfFiles = [];
  late final OrganizationController orgController;
  @override
  void initState() {
    orgController = Provider.of<OrganizationController>(context, listen: false);
    super.initState();
    loadPdfFiles();
  }

  Future<void> loadPdfFiles() async {
    pdfFiles = await getPdfFiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('PDF Files',style: Constants.appBarTextStyle,),
      ),
      body: pdfFiles.isEmpty
          ? Center(child: Text('No Pdf Files', style: Constants.appBarTextStyle,))
          : ListView.builder(
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          var fileLocation = pdfFiles[index].path;
          String fileName = path.basename(pdfFiles[index].path);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Constants.primaryColor,
              child: ListTile(
                title: Text(fileName,style: Constants.valueStyle,),
                onTap: () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    await open_file.OpenFile.open(fileLocation);
                  }
                },
                onLongPress: (){
                  _showDeleteConformation(pdfFiles[index]);
                  loadPdfFiles();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<File>> getPdfFiles() async {
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS) {
      Directory root = await path_provider.getApplicationSupportDirectory(); // this is using path_provider
      path = root.path + '/${orgController.selectedOrganization}';
    }
    final Directory dir = Directory(path!);
    final List<FileSystemEntity> files = await dir.list().toList();
    final List<File> pdfFiles = files.whereType<File>().toList();
    return pdfFiles;
  }

  _showDeleteConformation(file){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Are you sure to Delete Pdf file'),
        actions: [
          ElevatedButton(
              onPressed: ()=> Navigator.of(context).pop(),
              child: Text('CANCEl')),
          ElevatedButton(
              onPressed: () async {
                await file.delete();
                Navigator.of(context).pop();
              },
              child: Text('DELETE')),
        ],
      );
    });
  }
}
