import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  //Recetas

  Stream<QuerySnapshot> getRecetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Stream<QuerySnapshot> getReceta(String id) {
    return FirebaseFirestore.instance
        .collection('recetas')
        .where(FieldPath.documentId, isEqualTo: id)
        .snapshots();
  }

  Stream<QuerySnapshot> getRecetasFiltradasPorAutor(String autorid) {
    return FirebaseFirestore.instance
        .collection('recetas')
        .where('autor', isEqualTo: autorid)
        .snapshots();
  }

  Stream<QuerySnapshot> getRecetasFiltradasPorCategoria(String idCategoria) {
    return FirebaseFirestore.instance
        .collection('recetas')
        .where('categoria', isEqualTo: idCategoria)
        .snapshots();
  }

  Future<void> agregarReceta(
    String nombre,
    String instruccion,
    String categoria,
    String autor,
  ) async {
    return FirebaseFirestore.instance.collection('recetas').doc().set({
      'nombre': nombre,
      'instruccion': instruccion,
      'categoria': categoria,
      'autor': autor,
    });
  }

  Future<void> eliminarReceta(String id) async {
    return FirebaseFirestore.instance.collection('recetas').doc(id).delete();
  }

  // Categorias

  Stream<QuerySnapshot> getCategorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Stream<QuerySnapshot> getCategoria(String id) {
    return FirebaseFirestore.instance
        .collection('categorias')
        .where(FieldPath.documentId, isEqualTo: id)
        .snapshots();
  }
}
