import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DrugHistory(),
    );
  }
}

enum TakeStatus {
  taken('Tomado', Colors.green),
  missed('Não tomado', Colors.red),
  late('Tomado com atraso', Colors.orange);

  final String label;
  final Color color;
  const TakeStatus(this.label, this.color);
}

class DrugHistory extends StatelessWidget {
  const DrugHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Medicamentos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockHistoryData.length,
        itemBuilder: (context, index) {
          final history = _mockHistoryData[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: history.imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  history.imagePath!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.medication, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.drugName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              history.dosage,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: history.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: history.status.color,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      history.status.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: history.status.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.access_time,
                    'Horário Previsto:',
                    _formatTimeOfDay(history.scheduledTime),
                    Colors.blue,
                  ),
                  if (history.status != TakeStatus.missed) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.check_circle,
                      'Horário que tomou:',
                      _formatTimeOfDay(history.takenTime!),
                      history.status.color,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Data:',
                    _formatDate(history.date),
                    Colors.grey[700]!,
                  ),
                  if (history.notes != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              history.notes!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class DrugHistoryEntry {
  final String drugName;
  final String dosage;
  final TimeOfDay scheduledTime;
  final TimeOfDay? takenTime;
  final DateTime date;
  final TakeStatus status;
  final String? notes;
  final String? imagePath;

  DrugHistoryEntry({
    required this.drugName,
    required this.dosage,
    required this.scheduledTime,
    this.takenTime,
    required this.date,
    required this.status,
    this.notes,
    this.imagePath,
  });
}

final _mockHistoryData = [
  DrugHistoryEntry(
    drugName: 'Dipirona',
    dosage: '500mg',
    scheduledTime: const TimeOfDay(hour: 8, minute: 0),
    takenTime: const TimeOfDay(hour: 8, minute: 5),
    date: DateTime.now(),
    status: TakeStatus.taken,
    imagePath: 'assets/images/01.jpg',
  ),
  DrugHistoryEntry(
    drugName: 'Omeprazol',
    dosage: '20mg',
    scheduledTime: const TimeOfDay(hour: 6, minute: 0),
    date: DateTime.now(),
    status: TakeStatus.missed,
    notes: 'Esqueci de tomar em jejum',
    imagePath: 'assets/images/02.jpg',
  ),
  DrugHistoryEntry(
    drugName: 'Losartana',
    dosage: '50mg',
    scheduledTime: const TimeOfDay(hour: 20, minute: 0),
    takenTime: const TimeOfDay(hour: 21, minute: 30),
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: TakeStatus.late,
    notes: 'Tomei com 1h30 de atraso',
    imagePath: 'assets/images/03.png',
  ),
]; 