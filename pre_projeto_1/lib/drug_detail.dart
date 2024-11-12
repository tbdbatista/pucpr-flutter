import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrugDetail.mockLosartan(),
    );
  }
}

class DrugDetail extends StatelessWidget {
  final String name;
  final String industry;
  final String dosage;
  final String notes;
  final String? imagePath;
  final DateTime startDate;
  final DateTime? endDate;

  const DrugDetail({
    super.key,
    required this.name,
    required this.industry,
    required this.dosage,
    required this.notes,
    this.imagePath,
    required this.startDate,
    this.endDate,
  });

  static DrugDetail mockLosartan() {
    return DrugDetail(
      name: 'Losartana Potássica',
      industry: 'Medley',
      dosage: '50mg',
      notes: 'Tomar 1 comprimido pela manhã em jejum. Medicamento para pressão alta.'
          ' Evitar consumo com suco de pomelo/grapefruit.'
          ' Em caso de tontura ao levantar, avisar o médico.',
      imagePath: 'assets/images/03.png',
      startDate: DateTime(2024, 1, 15),
      endDate: null, // Tratamento contínuo
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(imagePath!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.medication, size: 80),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              title: 'Informações Gerais',
              content: [
                'Fabricante: $industry',
                'Dosagem: $dosage',
                'Início do tratamento: ${startDate.day}/${startDate.month}/${startDate.year}',
                if (endDate != null)
                  'Término previsto: ${endDate!.day}/${endDate!.month}/${endDate!.year}'
                else
                  'Tratamento contínuo',
                'Observações: $notes',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<String> content}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...content.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(text, style: const TextStyle(fontSize: 18)),
                )),
          ],
        ),
      ),
    );
  }
} 