import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DrugForm(),
    );
  }
}

class DrugForm extends StatefulWidget {
  const DrugForm({super.key});

  @override
  State<DrugForm> createState() => _DrugFormState();
}

class _DrugFormState extends State<DrugForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _industryController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();
  int _timesPerDay = 1;
  final List<TimeOfDay> _schedules = [const TimeOfDay(hour: 8, minute: 0)];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _industryController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateTimesPerDay(int value) {
    setState(() {
      _timesPerDay = value;
      if (_schedules.length < value) {
        // Adiciona novos horários se necessário
        while (_schedules.length < value) {
          _schedules.add(const TimeOfDay(hour: 8, minute: 0));
        }
      } else {
        // Remove horários extras se necessário
        _schedules.removeRange(value, _schedules.length);
      }
    });
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _schedules[index],
    );
    if (picked != null) {
      setState(() {
        _schedules[index] = picked;
      });
    }
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : _startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Reset end date if it's before new start date
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Medicamento'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Medicamento',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome do medicamento';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _industryController,
              decoration: const InputDecoration(
                labelText: 'Fabricante',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o fabricante';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosagem',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a dosagem';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Vezes ao dia: '),
                DropdownButton<int>(
                  value: _timesPerDay,
                  items: List.generate(
                    6,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) _updateTimesPerDay(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Horários:'),
            ...List.generate(
              _timesPerDay,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton(
                  onPressed: () => _selectTime(index),
                  child: Text(
                    'Horário ${index + 1}: ${_schedules[index].format(context)}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _selectDate(true),
              child: Text('Data de Início: ${_formatDate(_startDate)}'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _selectDate(false),
              child: Text(_endDate != null
                  ? 'Data de Término: ${_formatDate(_endDate!)}'
                  : 'Definir Data de Término (Opcional)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implementar a lógica de salvar
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Salvar Medicamento',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 