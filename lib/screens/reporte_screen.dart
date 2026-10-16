import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reporte.dart';
import '../services/reporte_service.dart';

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  final _descripcion = TextEditingController();
  final _service = ReporteService();
  File? _foto;
  Position? _posicion;
  bool _cargando = false;

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) setState(() => _foto = File(img.path));
  }

  Future<void> _obtenerUbicacion() async {
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() => _posicion = pos);
  }

  Future<void> _enviar() async {
    if (_foto == null || _posicion == null || _descripcion.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }
    setState(() => _cargando = true);
    try {
      final reporte = Reporte(
        id: '',
        usuarioId: FirebaseAuth.instance.currentUser!.uid,
        descripcion: _descripcion.text.trim(),
        fotoUrl: '', // Sin Storage, no subimos foto
        latitud: _posicion!.latitude,
        longitud: _posicion!.longitude,
        estado: 'pendiente',
        fecha: DateTime.now(),
      );
      await _service.crearReporte(reporte);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar animal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _tomarFoto,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: _foto != null
                      ? DecorationImage(
                          image: FileImage(_foto!), fit: BoxFit.cover)
                      : null,
                ),
                child: _foto == null
                    ? const Center(
                        child: Icon(Icons.camera_alt, size: 60))
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcion,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción del caso',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _obtenerUbicacion,
              icon: const Icon(Icons.location_on),
              label: Text(
                _posicion == null
                    ? 'Obtener ubicación'
                    : 'Ubicación: ${_posicion!.latitude.toStringAsFixed(4)}, ${_posicion!.longitude.toStringAsFixed(4)}',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _cargando ? null : _enviar,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: _cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}