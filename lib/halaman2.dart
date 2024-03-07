import 'package:flutter/material.dart';
import 'package:uas/sqlite_db.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'model/kamar.dart';

void main() {
  runApp(const Halaman2());
}

class Halaman2 extends StatelessWidget {
  const Halaman2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  TextEditingController nomorController = TextEditingController();
  TextEditingController jeniskamarController = TextEditingController();
  TextEditingController jumlahpesanController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];

  void refreshData() async {
    final data = await DatabaseHelper.getKamar();

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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
          return Card(
            elevation: 5,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  
                  height: 200,
                  child: catatan[index]['photo'] != ''
                      ? Image.file(
                          File(catatan[index]['photo']),
                        
                          fit: BoxFit.cover,
                        )
                      : FlutterLogo(),
                ),
                Text(catatan[index]['nomor']),
                Text(catatan[index]['jeniskamar']),
                Text(catatan[index]['jumlahpesan']),
                Text(catatan[index]['harga']),
                 ListTile(
                   trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Form(catatan[index]['id']);
                          },
                          icon: const Icon(Icons.edit)),
                        IconButton(
                           onPressed: () {
                           hapusKamar(catatan[index]['id']);
                        },
                          icon: const Icon(Icons.delete)),
                      ],
                    ),
                   )
                 )
              ],
            ),
          );
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
      nomorController.text = dataupdate['No Kamar'];
      jeniskamarController.text = dataupdate['Jenis Kamar'];
      jumlahpesanController.text = dataupdate['Durasi'];
      hargaController.text = dataupdate['Harga Permalam'];
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
                    controller: nomorController,
                    decoration: const InputDecoration(hintText: "No Kamar"),
                  ),
                  TextField(
                    controller: jeniskamarController,
                    decoration: const InputDecoration(hintText: "Jenis Kamar"),
                  ),
                  TextField(
                    controller: jumlahpesanController,
                    decoration: const InputDecoration(hintText: "Durasi"),
                  ),
                  TextField(
                    controller: hargaController,
                    decoration: const InputDecoration(hintText: "Harga Permalam"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getFilePicker();
                      },
                      child: Row(
                        children: const [
                          Text(" Gambar Yang Dipesan"),
                          Icon(Icons.camera)
                        ],
                      )),
                  ElevatedButton(
                  onPressed: () async {
                        if (id != null) {
                          String? photo = photoprofile;
                          final data = Kamar(
                              id: id,
                              nomor: nomorController.text,
                              jeniskamar: jeniskamarController.text,
                              jumlahpesan: jumlahpesanController.text,
                              harga: hargaController.text,
                              photo: photo.toString());
                          updateKamar(data);
                          nomorController.text = '';
                          jeniskamarController.text = '';
                          jumlahpesanController.text = '';
                          hargaController.text = '';
                          Navigator.pop(context);
                        } 
                        else {
                          String? photo = photoprofile;
                          final data = Kamar(
                              nomor: nomorController.text,
                              jeniskamar: jeniskamarController.text,
                              jumlahpesan: jumlahpesanController.text,
                              harga: hargaController.text,
                              photo: photo.toString());
                          tambahKamar(data);
                          nomorController.text = '';
                          jeniskamarController.text = '';
                          jumlahpesanController.text = '';
                          hargaController.text = '';
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

  Future<void> tambahKamar(Kamar kamar) async {
    await DatabaseHelper.tambahKamar(kamar);
    return refreshData();
  }

  Future<void> updateKamar(Kamar kamar) async {
    await DatabaseHelper.updateKamar(kamar);
    return refreshData();
  }

  Future<void> hapusKamar(int id) async {
    await DatabaseHelper.deleteKamar(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
