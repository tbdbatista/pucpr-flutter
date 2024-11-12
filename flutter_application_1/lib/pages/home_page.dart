import 'package:flutter/material.dart';
import '../models/medicamento.dart';
import '../database/database_helper.dart';
import './cadastro_medicamento_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Medicamento> _medicamentos = [];

  @override
  void initState() {
    super.initState();
    _loadMedicamentos();
  }

  Future<void> _loadMedicamentos() async {
    final medicamentos = await DatabaseHelper.instance.getAllMedicamentos();
    setState(() {
      _medicamentos = medicamentos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Medicamentos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 24.0, 
              right: 24.0, 
              top: 24.0,
              bottom: 100.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Medicamentos Cadastrados',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _medicamentos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medication_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhum medicamento cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _medicamentos.length,
                          itemBuilder: (context, index) {
                            final medicamento = _medicamentos[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[700],
                                  radius: 25,
                                  child: Icon(
                                    Icons.medication,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                title: Text(
                                  medicamento.nome,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    _buildInfoRow(Icons.scale, 'Dosagem: ${medicamento.dosagem}'),
                                    SizedBox(height: 4),
                                    _buildInfoRow(Icons.schedule, 'Frequência: ${medicamento.frequencia}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 200,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.blue[400]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[700]!.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.blue[700]!,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _navegarParaCadastro,
                        borderRadius: BorderRadius.circular(25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 28,
                              color: Colors.blue[900],
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Future<void> _navegarParaCadastro() async {
    try {
      final medicamento = await Navigator.push<Medicamento>(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroMedicamentoPage(),
        ),
      );

      if (medicamento != null) {
        await DatabaseHelper.instance.insertMedicamento(medicamento);
        await _loadMedicamentos();
        
        if (mounted) {  // Verifica se o widget ainda está montado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Medicamento cadastrado com sucesso!',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.green[600],
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao navegar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao cadastrar medicamento',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red[600],
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
} 