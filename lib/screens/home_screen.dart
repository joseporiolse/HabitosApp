
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

  Future<void> canviarEstatHabit(
      Habit habit,
      bool completat,
      ) async {
    // Marquem o desmarquem un hàbit del dia actual

    final dataAvui = obtenirDataAvui();

    setState(() {
      if (completat) {
        if (!habit.datesCompletades.contains(dataAvui)) {
          habit.datesCompletades.add(dataAvui);
        }
      } else {
        habit.datesCompletades.remove(dataAvui);
      }
    });

    await preferencies.guardarHabits(habits);
    // Guardem els canvis a les preferències
  }

  int obtenirSeguentId() {
    // Busquem un identificador que no estigui repetit

    if (habits.isEmpty) {
      return 1;
    }

    int idMaxim = 0;

    for (final habit in habits) {
      if (habit.id > idMaxim) {
        idMaxim = habit.id;
      }
    }

    return idMaxim + 1;
  }

  Future<void> mostrarFormulariHabit() async {
    // Mostrem el formulari per crear un hàbit

    final controladorNom = TextEditingController();

    Color colorSeleccionat = Colors.blue;

    final colorsDisponibles = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Afegir hàbit'),

          content: StatefulBuilder(
            builder: (context, actualitzarDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controladorNom,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'hàbit',
                      hintText: 'Exemple: Caminar',
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text('Selecciona un color:'),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: colorsDisponibles.map((color) {
                      final seleccionat = colorSeleccionat == color;

                      return InkWell(
                        onTap: () {
                          actualitzarDialog(() {
                            colorSeleccionat = color;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 20,
                          child: seleccionat
                              ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel·lar'),
            ),

            ElevatedButton(
              onPressed: () async {
                // Recuperem el nom introduït
                final nomHabit = controladorNom.text.trim();

                // Comprovem que el nom no estigui buit
                if (nomHabit.isEmpty) {
                  return;
                }

                // Creem un nou hàbit amb un identificador únic
                final nouHabit = Habit(
                  id: obtenirSeguentId(),
                  nom: nomHabit,
                  color: colorSeleccionat.toARGB32(),
                  datesCompletades: [],
                );

                // Afegim el nou hàbit a la llista
                if (!mounted) return;

                setState(() {
                  habits.add(nouHabit);
                });

                // Guardem la llista actualitzada
                await preferencies.guardarHabits(habits);

                // Tanquem el formulari
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    controladorNom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construïm la pantalla principal de l'aplicació

    final habitsCompletats = calcularHabitsCompletats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Els meus hàbits'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarFormulariHabit();
        },
        tooltip: 'Afegir hàbit',
        child: const Icon(Icons.add),
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
