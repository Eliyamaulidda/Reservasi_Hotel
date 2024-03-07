import 'package:uas/halaman1.dart';
import 'package:flutter/material.dart';
import 'package:uas/halaman1.dart';
import 'package:uas/halaman2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ('HOTEL SEJAHTERA INDAH'),
        backgroundColor: Color.fromARGB(255, 237, 17, 153),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: "Reservasi Hotels", icon: Icon(Icons.hotel),),
            Tab(text: "Class Hotel", icon: Icon(Icons.hotel_class_rounded),)
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Halaman1(),
          ),
          Center(
            child: Halaman2(),
          ),
        ],
      ),
    );
  }
}
