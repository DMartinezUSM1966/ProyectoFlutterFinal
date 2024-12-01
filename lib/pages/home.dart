import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_moviles/pages/recetas_agregar.dart';
import 'package:proyecto_moviles/pages/tabs/categoria.dart';
import 'package:proyecto_moviles/pages/tabs/recetas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int seleccion = 0;

  final List<Widget> paginas = <Widget>[
    RecetasPage(),
    Categoria(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      seleccion = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginas[seleccion],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.white,
        hoverColor: Colors.white,
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecetasAgregar()));
        },
        child: Icon(Icons.add, color: Color.fromARGB(255, 255, 8, 243)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: seleccion,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.foodOutline),
            label: 'Recetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bookshelf),
            label: 'Filtrar',
          ),
        ],
      ),
    );
  }
}
