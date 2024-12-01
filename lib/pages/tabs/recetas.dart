import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_moviles/pages/detalleReceta.dart';
import 'package:proyecto_moviles/services/fs_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecetasPage extends StatefulWidget {
  @override
  _RecetasPageState createState() => _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool chkboxFiltrar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Row(
          children: [
            Text(
              'Categorías',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 70),
            Text(
              'Mis recetas',
              style: TextStyle(
                fontSize: 17,
                color: const Color.fromARGB(255, 190, 190, 190),
                fontWeight: FontWeight.bold,
              ),
            ),
            Checkbox(
              value: chkboxFiltrar,
              activeColor: Colors.white,
              checkColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  chkboxFiltrar = value!;
                });
              },
            ),
          ],
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                MdiIcons.menu,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    child: Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.displayName ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
            ),
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 126, 81, 168),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: chkboxFiltrar && user != null
                ? StreamBuilder(
                    stream:
                        FsService().getRecetasFiltradasPorAutor(user!.email!),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Cargando datos'));
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var receta = snapshot.data!.docs[index];
                          return _buildRecetaItem(context, receta);
                        },
                      );
                    },
                  )
                : StreamBuilder(
                    stream: FsService().getRecetas(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Cargando datos'));
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var receta = snapshot.data!.docs[index];
                          return _buildRecetaItem(context, receta);
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecetaItem(BuildContext context, DocumentSnapshot receta) {
    return Slidable(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleRecetaPage(
                nombre: receta['nombre'],
                instruccion: receta['instruccion'],
                idCategoria: receta['categoria'],
                emailUser: receta['autor'],
              ),
            ),
          );
        },
        child: StreamBuilder(
          stream: FsService().getCategoria(receta['categoria']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(); // Return an empty container if no data
            }

            var categoria =
                snapshot.data?.docs.first.data() as Map<String, dynamic>?;

            String? imagenUrl = categoria?['imagen'];

            if (imagenUrl == null || imagenUrl.isEmpty) {
              return Container(); // If the image URL is empty, return an empty container
            }

            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(164, 255, 255, 255),
                  width: 5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/categorias/$imagenUrl'), // Ruta local
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 0),
                    child: Container(
                      color:
                          const Color.fromARGB(242, 0, 0, 0).withOpacity(0.2),
                      width: double.infinity,
                      child: Text(
                        '${receta['nombre']}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Eliminar',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) {
              _confirmarBorrado(
                  context, receta['nombre'], receta.id, user!.email!);
            },
          ),
        ],
      ),
    );
  }

  void _confirmarBorrado(BuildContext context, String recetaNombre,
      String recetaId, String correo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: FsService()
              .getReceta(recetaId), // Escucha los cambios en la receta
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return AlertDialog(
                title: Text('Receta no encontrada'),
                content: Text('No se ha encontrado la receta.'),
                actions: [
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }

            // Accede a los datos de la receta
            var receta =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            String correoUsuarioReceta = receta['autor'] ?? '';

            // Verifica si el correo del usuario coincide con el de la receta
            if (correo != correoUsuarioReceta) {
              return AlertDialog(
                title: Text('No tienes permiso para eliminar esta receta'),
                content: Text('No puedes eliminar recetas de otros usuarios.'),
                actions: [
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }

            return AlertDialog(
              title: Text('Eliminar receta'),
              content: Text('¿Estás seguro de eliminar "$recetaNombre"?'),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Eliminar'),
                  onPressed: () {
                    FsService().eliminarReceta(recetaId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
