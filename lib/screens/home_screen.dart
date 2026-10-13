
import 'package:flutter/material.dart';
import '../modelos/habitos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Habit> habits = [
    Habit(
      id: 1,
      nom: 'Beure aigua',
      color: Colors.blue.toARGB32(),
      datesCompletades: [],
    ),

    Habit(
      id: 2,
      nom: 'Fer exercici',
      color: Colors.orange.toARGB32(),
      datesCompletades: [],
    ),

    Habit(
      id: 3,
      nom: 'Llegir',
      color: Colors.green.toARGB32(),
      datesCompletades: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Construïm la pantalla principal de l'aplicació

    return Scaffold(
      // Estructura bàsica de la pantalla

      appBar: AppBar(
        title: const Text('Els meus hàbits'),
        // Títol de la barra superior
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),
          // Deixem un espai vertical

          const Text(
            'Benvingut!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Tens ${habits.length} hàbits registrats',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          Expanded(
            // Permet que la llista ocupi l'espai disponible

            child: ListView.builder(
              // Creem una llista dinàmica amb els hàbits

              itemCount: habits.length,
              // Indiquem quants elements tindrà la llista

              itemBuilder: (context, index) {
                // Construïm cada element de la llista

                final habit = habits[index];
                // Obtenim l'hàbit de la posició actual

                return ListTile(
                  // Mostrem la informació de cada hàbit

                  leading: CircleAvatar(
                    backgroundColor: Color(habit.color),
                    // Mostrem el color de l'hàbit
                  ),

                  title: Text(habit.nom),
                  // Mostrem el nom de l'hàbit

                  trailing: Checkbox(
                    // Casella per marcar l'hàbit com a completat

                    value: false,
                    // De moment tots els hàbits apareixen sense completar

                    onChanged: (valor) {
                      // Aquí implementarem el canvi d'estat de l'hàbit
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
