import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  final String id;
  final String usuarioId;
  final String descripcion;
  final String fotoUrl;
  final double latitud;
  final double longitud;
  final String estado;
  final DateTime fecha;

  Reporte({
    required this.id,
    required this.usuarioId,
    required this.descripcion,
    required this.fotoUrl,
    required this.latitud,
    required this.longitud,
    required this.estado,
    required this.fecha,
  });

  factory Reporte.fromMap(Map<String, dynamic> map, String id) {
    return Reporte(
      id: id,
      usuarioId: map['usuarioId'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '',
      latitud: (map['latitud'] ?? 0).toDouble(),
      longitud: (map['longitud'] ?? 0).toDouble(),
      estado: map['estado'] ?? 'pendiente',
      fecha: (map['fecha'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'descripcion': descripcion,
      'fotoUrl': fotoUrl,
      'latitud': latitud,
      'longitud': longitud,
      'estado': estado,
      'fecha': Timestamp.fromDate(fecha),
    };
  }
}