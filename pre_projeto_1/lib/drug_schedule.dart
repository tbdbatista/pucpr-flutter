import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DrugsList(),
    );
  }
}

class Drugs {
  final String name;
  final String industry;
  final String dosage;
  final int timesPerDay;
  final List<TimeOfDay> schedules;
  final DateTime startDate;
  final DateTime? endDate;
  final String notes;
  final String? imagePath;

  Drugs({
    required this.name,
    required this.industry,
    required this.dosage,
    required this.timesPerDay,
    required this.schedules,
    required this.startDate,
    this.endDate,
    required this.notes,
    this.imagePath,
  });
}

class DrugsList extends StatefulWidget {
  const DrugsList({super.key});

  @override
  State<DrugsList> createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  final List<Drugs> _drugs = [
    Drugs(
      name: 'Dipirona',
      industry: 'Medley',
      dosage: '500mg',
      timesPerDay: 3,
      schedules: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 12, minute: 0),
        const TimeOfDay(hour: 18, minute: 0),
      ],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 10)),
      notes: 'Tomar após o café da manhã, almoço e jantar',
      imagePath: 'assets/images/01.jpg',
    ),
    Drugs(
      name: 'Omeprazol',
      industry: 'Teuto',
      dosage: '20mg',
      timesPerDay: 1,
      schedules: [
        const TimeOfDay(hour: 6, minute: 0),
      ],
      startDate: DateTime.now(),
      notes: 'Tomar em jejum, 30 minutos antes do café da manhã',
      imagePath: 'assets/images/02.jpg',
    ),
    Drugs(
      name: 'Losartana',
      industry: 'EMS',
      dosage: '50mg',
      timesPerDay: 2,
      schedules: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      notes: 'Tomar após o café da manhã e jantar',
      imagePath: 'assets/images/03.png',
    ),
    Drugs(
      name: 'Amoxicilina',
      industry: 'Medley',
      dosage: '875mg',
      timesPerDay: 2,
      schedules: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      notes: 'Tomar o tratamento completo conforme prescrito',
      imagePath: 'assets/images/04.png',
    ),
    Drugs(
      name: 'Atenolol',
      industry: 'Biosintética',
      dosage: '25mg',
      timesPerDay: 1,
      schedules: [
        const TimeOfDay(hour: 7, minute: 0),
      ],
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      notes: 'Tomar pela manhã',
      imagePath: 'assets/images/05.png',
    ),
  ];

  TimeOfDay? _getNextTime(List<TimeOfDay> schedules) {
    final now = TimeOfDay.now();
    final sortedSchedules = List<TimeOfDay>.from(schedules)
      ..sort((a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      });

    for (var schedule in sortedSchedules) {
      if (_isTimeAfterNow(schedule, now)) {
        return schedule;
      }
    }
    return sortedSchedules.first;
  }

  bool _isTimeAfterNow(TimeOfDay schedule, TimeOfDay reference) {
    final scheduleMinutes = schedule.hour * 60 + schedule.minute;
    final referenceMinutes = reference.hour * 60 + reference.minute;
    return scheduleMinutes > referenceMinutes;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final orderedDrugs = List<Drugs>.from(_drugs)
      ..sort((a, b) {
        final aNext = _getNextTime(a.schedules);
        final bNext = _getNextTime(b.schedules);
        if (aNext == null || bNext == null) return 0;

        final aMinutes = aNext.hour * 60 + aNext.minute;
        final bMinutes = bNext.hour * 60 + bNext.minute;
        return aMinutes.compareTo(bMinutes);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus medicamentos do dia'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 108),
        itemCount: orderedDrugs.length,
        itemBuilder: (context, index) {
          final drug = orderedDrugs[index];
          final nextSchedule = _getNextTime(drug.schedules);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: drug.imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  drug.imagePath!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.medication, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drug.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fabricante: ${drug.industry}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Dosagem: ${drug.dosage}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${drug.timesPerDay}x ao dia',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Horários: ${drug.schedules.map((h) {
                      final isNext = nextSchedule == h;
                      return Text(
                        h.format(context),
                        style: TextStyle(
                          color: isNext ? Colors.red : null,
                          fontWeight: isNext ? FontWeight.bold : null,
                        ),
                      ).data;
                    }).join(", ")}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Início: ${_formatDate(drug.startDate)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (drug.endDate != null)
                    Text(
                      'Término: ${_formatDate(drug.endDate!)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )
                  else
                    const Text(
                      'Uso contínuo',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (drug.notes.isNotEmpty)
                    Text(
                      'Observações: ${drug.notes}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (nextSchedule != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Próxima dose: ${nextSchedule.format(context)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: nextSchedule.hour < TimeOfDay.now().hour
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          if (nextSchedule.hour < TimeOfDay.now().hour)
                            const Text(
                              'Essa dose está atrasada!',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 24,
                              ),
                            ),
                        ],
                      ),
                    ),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        icon: const Icon(Icons.check),
                        label: const Text(
                          'Tomei',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text(
                          'Esqueci de tomar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
