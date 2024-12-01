import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_moviles/services/fs_service.dart';

class DetalleRecetaPage extends StatefulWidget {
  final String nombre;
  final String instruccion;
  final String idCategoria;
  final String emailUser;

  const DetalleRecetaPage(
      {super.key,
      required this.nombre,
      required this.instruccion,
      required this.idCategoria,
      required this.emailUser});

  @override
  State<DetalleRecetaPage> createState() => _DetalleRecetaPageState();
}

class _DetalleRecetaPageState extends State<DetalleRecetaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombre,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 5,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // StreamBuilder para mostrar la categoría
          StreamBuilder<QuerySnapshot>(
            stream: FsService().getCategoria(widget.idCategoria),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Categoría no encontrada'));
              }

              var categoria =
                  snapshot.data!.docs[0].data() as Map<String, dynamic>;
              String nombre = categoria['nombre'] ?? 'Sin nombre';

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(MdiIcons.label, color: Colors.orangeAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Categoría: $nombre',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),
          // Contenedor con imagen de la categoría
          StreamBuilder<QuerySnapshot>(
            stream: FsService().getCategoria(widget.idCategoria),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Categoría no encontrada'));
              }

              var categoria =
                  snapshot.data!.docs[0].data() as Map<String, dynamic>;
              String imagen = categoria['imagen'] ?? 'default.jpeg';

              return Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/img/categorias/$imagen',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Divider(thickness: 1),
          SizedBox(height: 10),
          // Detalles del autor y la puntuación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(MdiIcons.accountCircle, color: Colors.black54),
                  SizedBox(width: 5),
                  Text(
                    widget.emailUser,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(MdiIcons.star, color: Colors.orangeAccent),
                  SizedBox(width: 5),
                  Text(
                    '4.5',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(thickness: 1),
          SizedBox(height: 20),
          // Card con la receta
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nombre,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1),
                  Text(
                    widget.instruccion,
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
