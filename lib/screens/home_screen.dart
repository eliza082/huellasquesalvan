import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/reporte_service.dart';
import '../models/reporte.dart';
import '../widgets/reporte_card.dart';
import 'reporte_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reporteService = ReporteService();
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Huellas que Salvan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<Reporte>>(
        stream: reporteService.obtenerReportes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay reportes aún.\n¡Sé el primero en ayudar!'),
            );
          }
          final reportes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reportes.length,
            itemBuilder: (context, i) => ReporteCard(reporte: reportes[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReporteScreen()),
        ),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Reportar'),
      ),
    );
  }
}