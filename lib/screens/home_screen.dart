
import 'package:flutter/material.dart';
import '../models/habitos.dart';
import '../services/preferencies_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PreferenciesService preferencies = PreferenciesService();
  // Servei per recuperar i guardar les dades

  String nom = '';
  // Nom de l'usuari

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
  void initState() {
    super.initState();
    carregarNom();
    carregarHabits();
    // Carreguem el nom i els hàbits guardats
  }

  Future<void> carregarHabits() async {
    // Recuperem els hàbits guardats a les preferències

    final habitsGuardats = await preferencies.obtenirHabits();

    if (!mounted) return;
    // Comprovem que la pantalla encara estigui activa

    if (habitsGuardats.isNotEmpty) {
      setState(() {
        habits = habitsGuardats;
      });
    } else {
      await preferencies.guardarHabits(habits);
      // Guardem els hàbits inicials si encara no hi ha dades
    }
  }

  Future<void> carregarNom() async {
    // Recuperem el nom guardat de l'usuari

    final nomGuardat = await preferencies.obtenirNom();

    if (!mounted) return;
    // Comprovem que la pantalla encara estigui activa

    setState(() {
      nom = nomGuardat ?? '';
    });
  }

  String obtenirDataAvui() {
    // Obtenim la data actual sense l'hora

    final avui = DateTime.now();

    return '${avui.year}-${avui.month}-${avui.day}';
  }

  bool estaCompletatAvui(Habit habit) {
    // Comprovem si l'hàbit està completat avui

    return habit.datesCompletades.contains(obtenirDataAvui());
  }

  int calcularHabitsCompletats() {
    // Comptem els hàbits completats avui

    return habits.where((habit) {
      return estaCompletatAvui(habit);
    }).length;
  }

  Future<void> canviarEstatHabit(Habit habit, bool completat) async {
    // Marquem o desmarquem un hàbit del dia actual

    final dataAvui = obtenirDataAvui();

    setState(() {
      if (completat) {
        // Si l'hàbit està completat, guardem la data d'avui

        if (!habit.datesCompletades.contains(dataAvui)) {
          habit.datesCompletades.add(dataAvui);
        }
      } else {
        // Si desmarquem l'hàbit, eliminem la data d'avui

        habit.datesCompletades.remove(dataAvui);
      }
    });

    await preferencies.guardarHabits(habits);
    // Guardem els canvis a les preferències
  }

  @override
  Widget build(BuildContext context) {
    // Construïm la pantalla principal de l'aplicació

    final habitsCompletats = calcularHabitsCompletats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Els meus hàbits'),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            'Benvingut, $nom!',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '$habitsCompletats de ${habits.length} hàbits completats',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          Expanded(
            // Permet que la llista ocupi l'espai disponible

            child: ListView.builder(
              // Creem una llista dinàmica amb els hàbits

              itemCount: habits.length,

              itemBuilder: (context, index) {
                // Construïm cada element de la llista

                final habit = habits[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(habit.color),
                  ),

                  title: Text(habit.nom),

                  trailing: Checkbox(
                    value: estaCompletatAvui(habit),

                    onChanged: (valor) {
                      if (valor != null) {
                        canviarEstatHabit(habit, valor);
                      }
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
