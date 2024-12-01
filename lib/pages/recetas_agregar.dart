import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/services/fs_service.dart';

class RecetasAgregar extends StatefulWidget {
  const RecetasAgregar({super.key});

  @override
  State<RecetasAgregar> createState() => _RecetasAgregarState();
}

class _RecetasAgregarState extends State<RecetasAgregar> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nombreController = TextEditingController();
  TextEditingController instruccionesController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController autorController = TextEditingController();

  String? _categoria;
  String? _nombre;
  String? _instrucciones;
  String? _url;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Receta',
        ),
        foregroundColor: Colors.white,
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Color similar al login
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 126, 81, 168)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(
                  255, 255, 255, 255), // Fondo oscuro similar al login
            ),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Campo: Nombre
                  Text(
                    'Nombre de la Receta',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ingrese el nombre de la receta',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(185, 70, 68, 68)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese un nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nombre = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Instrucciones
                  const Text(
                    'Instrucciones',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: instruccionesController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escriba las instrucciones para la receta',
                      hintStyle: TextStyle(color: Color.fromARGB(125, 0, 0, 0)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 5, 4, 4)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese las instrucciones';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _instrucciones = value;
                    },
                  ),
                  SizedBox(height: 8),

                  SizedBox(height: 16),
                  Text(
                    'Categoria',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(height: 8),
                  StreamBuilder(
                      stream: FsService().getCategorias(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Cargando categorias.');
                        }
                        List<DropdownMenuItem<String>> items = snapshot
                            .data.docs
                            .map<DropdownMenuItem<String>>((document) {
                          return DropdownMenuItem<String>(
                            value: document.id,
                            child: Text(document['nombre']),
                          );
                        }).toList();

                        return DropdownButtonFormField<String>(
                          value: _categoria,
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              _categoria = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                          hint: Text('Seleccione una categoría'),
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, seleccione una categoría';
                            }
                            return null;
                          },
                        );
                      }),
                  SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Debes iniciar sesión para agregar una receta.'),
                        ));
                        return;
                      }

                      // Validamos si el formulario es válido
                      if (_formKey.currentState!.validate()) {
                        FsService().agregarReceta(
                          nombreController.text,
                          instruccionesController.text,
                          _categoria!,
                          user!.email ?? 'desconocido',
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Color.fromARGB(255, 247, 14, 247),
                    ),
                    label: Text(
                      'Guardar Receta',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
