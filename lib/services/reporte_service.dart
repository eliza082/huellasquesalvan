import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporte.dart';

class ReporteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> crearReporte(Reporte reporte) async {
    await _db.collection('reportes').add(reporte.toMap());
  }

  Stream<List<Reporte>> obtenerReportes() {
    return _db
        .collection('reportes')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Reporte.fromMap(doc.data(), doc.id))
            .toList());
  }
}