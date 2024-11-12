import 'package:flutter/material.dart';
import '../models/medicamento.dart';

class CadastroMedicamentoPage extends StatefulWidget {
  @override
  _CadastroMedicamentoPageState createState() => _CadastroMedicamentoPageState();
}

class _CadastroMedicamentoPageState extends State<CadastroMedicamentoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequenciaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Medicamento',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Informações do Medicamento',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                _buildTextField(
                  controller: _nomeController,
                  label: 'Nome do Medicamento',
                  icon: Icons.medication,
                  hint: 'Ex: Paracetamol',
                ),
                SizedBox(height: 24),
                _buildTextField(
                  controller: _dosageController,
                  label: 'Dosagem',
                  icon: Icons.scale,
                  hint: 'Ex: 1 comprimido de 500mg',
                ),
                SizedBox(height: 24),
                _buildTextField(
                  controller: _frequenciaController,
                  label: 'Frequência',
                  icon: Icons.schedule,
                  hint: 'Ex: 2 vezes ao dia',
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _salvarMedicamento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 28),
                      SizedBox(width: 8),
                      Text('Salvar Medicamento'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            prefixIcon: Icon(icon, size: 24, color: Colors.blue[700]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _salvarMedicamento() {
    if (_formKey.currentState!.validate()) {
      final medicamento = Medicamento(
        nome: _nomeController.text,
        dosagem: _dosageController.text,
        frequencia: _frequenciaController.text,
      );
      
      Navigator.pop(context, medicamento);
    }
  }
} 