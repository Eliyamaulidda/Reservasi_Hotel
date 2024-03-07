import 'package:flutter/material.dart';
import 'package:uas/sqlite_db.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'model/reservasi.dart';

void main() {
  runApp(const Halaman1());
}

class Halaman1 extends StatelessWidget {
  const Halaman1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Form Reservasi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];

  void refreshData() async {
    final data = await DatabaseHelper.getReservasi();

    setState(() {
      catatan = data;
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  String? photoprofile;
  Future<String> getFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
    allowedExtensions: [
      'jpg',
      'png',
      'webm',
    ],);

    if (result != null) {
      PlatformFile sourceFile = result.files.first;
      final destination = await getExternalStorageDirectory();
      File? destinationFile =
          File('${destination!.path}/${sourceFile.name.hashCode}');
      final newFile =
          File(sourceFile.path!).copy(destinationFile.path.toString());
      setState(() {
        photoprofile = destinationFile.path;
      });
      File(sourceFile.path!.toString()).delete();
      return destinationFile.path;
    } else {
      return "Dokumen belum diupload";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: catatan[index]['nama'] != ''
                ? Image.file(File(catatan[index]['photo']),
                    width: 40, height: 40)
                : FlutterLogo(),
            title: Text(catatan[index]['nama']),
            subtitle: Text(catatan[index]['telepon']),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child:Row(
                children: [
                  IconButton(
                        onPressed: () {
                          Form(catatan[index]['id']);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          hapusReservasi(catatan[index]['id']);
                        },
                        icon: const Icon(Icons.delete)),
                ],
              ) ,
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Form(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void Form(id) async {
    if (id != null) {
      final dataupdate = catatan.firstWhere((element) => element['id'] == id);
      namaController.text = dataupdate['nama'];
      teleponController.text = dataupdate['telepon'];
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(hintText: "Nama Customer"),
                  ),
                  TextField(
                    controller: teleponController,
                    decoration: const InputDecoration(hintText: " No Telepon"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getFilePicker();
                      },
                      child: Row(
                        children: const [
                          Text("Identitas Jaminan"),
                          Icon(Icons.camera)
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        if (id != null) {
                          String? photo = photoprofile;
                          final data = Reservasi(
                              id: id,
                              nama: namaController.text,
                              telepon: teleponController.text,
                              photo: photo.toString());
                          updateReservasi(data);
                          namaController.text = '';
                          teleponController.text = '';
                          Navigator.pop(context);
                        } else {
                          String? photo = photoprofile;
                          final data = Reservasi(
                              nama: namaController.text,
                              telepon: teleponController.text,
                              photo: photo.toString());
                          tambahReservasi(data);
                          namaController.text = '';
                          teleponController.text = '';
                          Navigator.pop(context);
                        }
                      },
                      child: Text(id == null ? "Tambah" : 'update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> tambahReservasi(Reservasi Reservasi) async {
    await DatabaseHelper.tambahReservasi(Reservasi);
    return refreshData();
  }

  Future<void> updateReservasi(Reservasi Reservasi) async {
    await DatabaseHelper.updateReservasi(Reservasi);
    return refreshData();
  }

  Future<void> hapusReservasi(int id) async {
    await DatabaseHelper.deleteReservasi(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
