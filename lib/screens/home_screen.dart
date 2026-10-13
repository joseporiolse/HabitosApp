import 'package:flutter/material.dart';
import '../models/habito.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Habito> habitos = [
    Habito(
      id: 1,
      nombre: 'Beber agua',
      color: Colors.blue.toARGB32(),
      fechasCompletadas: [],
    ),
    Habito(
      id: 2,
      nombre: 'Hacer ejercicio',
      color: Colors.orange.toARGB32(),
      fechasCompletadas: [],
    ),
    Habito(
      id: 3,
      nombre: 'Leer',
      color: Colors.green.toARGB32(),
      fechasCompletadas: [],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis hábitos'),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            '¡Bienvenido!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Tienes ${habitos.length} hábitos registrados',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, index) {
                final habito = habitos[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(habito.color),
                  ),
                  title: Text(habito.nombre),
                  trailing: Checkbox(
                    value: false,
                    onChanged: (valor) {
                      // Aquí implementaremos el cambio de estado.
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}