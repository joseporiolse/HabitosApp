
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

  String nom = '';
  int objectiu = 0; //Objectiu establert per l'usuari
  bool carregant = true;

  // Hàbits inicials de l'aplicació
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
    carregarDades();
  }

  Future<void> carregarDades() async {
    // Carreguem el nom i els hàbits guardats

    try {
      final nomGuardat = await preferencies.obtenirNom(); //Recuperem nom guardat

      final objectiuGuardat = await preferencies.obtenirObjectiu();

      final existeixen =
      await preferencies.existeixenHabitsGuardats();

      if (existeixen) {
        // Recuperem els hàbits, encara que la llista sigui buida
        final habitsGuardats = await preferencies.obtenirHabits();

        if (!mounted) return;

        setState(() {
          nom = nomGuardat ?? '';
          objectiu = objectiuGuardat ?? 0;
          habits = habitsGuardats;
          carregant = false;
        });
      } else {
        // Guardem els hàbits inicials només la primera vegada
        await preferencies.guardarHabits(habits);

        if (!mounted) return;

        setState(() {
          nom = nomGuardat ?? '';
          carregant = false;
        });
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        carregant = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en carregar les dades'),
        ),
      );
    }
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

    // Guardem els canvis
    await preferencies.guardarHabits(habits);
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

  Future<void> mostrarFormulariHabit({Habit? habitEditar}) async {
    // Formulari per crear o editar un hàbit

    final controladorNom = TextEditingController(
      text: habitEditar?.nom ?? '',
    );

    Color colorSeleccionat = habitEditar != null
        ? Color(habitEditar.color)
        : Colors.blue;

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
          title: Text(
            habitEditar == null
                ? 'Afegir hàbit'
                : 'Editar hàbit',
          ),

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
                    runSpacing: 10,
                    children: colorsDisponibles.map((color) {
                      final seleccionat =
                          colorSeleccionat.toARGB32() ==
                              color.toARGB32();

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

                if (nomHabit.isEmpty) {
                  return;
                }

                if (!mounted) return;

                if (habitEditar == null) {
                  // Creem un nou hàbit

                  final nouHabit = Habit(
                    id: obtenirSeguentId(),
                    nom: nomHabit,
                    color: colorSeleccionat.toARGB32(),
                    datesCompletades: [],
                  );

                  setState(() {
                    habits.add(nouHabit);
                  });
                } else {
                  // Editem l'hàbit existent
                  // Conservem l'identificador i les dates

                  setState(() {
                    habitEditar.nom = nomHabit;
                    habitEditar.color =
                        colorSeleccionat.toARGB32();
                  });
                }

                // Guardem els hàbits actualitzats
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

  Future<void> eliminarHabit(Habit habit) async {
    // Demanem confirmació abans d'eliminar un hàbit

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar hàbit'),

          content: Text(
            'Estàs segur que vols eliminar "${habit.nom}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel·lar'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si l'usuari cancel·la, no eliminem res
    if (confirmar != true || !mounted) return;

    // Eliminem l'hàbit de la llista
    setState(() {
      habits.removeWhere((element) => element.id == habit.id);
    });

    // Guardem la llista actualitzada
    await preferencies.guardarHabits(habits);
  }

  @override
  Widget build(BuildContext context) {
    // Construïm la pantalla principal

    final habitsCompletats = calcularHabitsCompletats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Els meus hàbits'),
      ),

      floatingActionButton: carregant
          ? null
          : FloatingActionButton(
        onPressed: () {
          mostrarFormulariHabit();
        },
        tooltip: 'Afegir hàbit',
        child: const Icon(Icons.add),
      ),

      body: carregant
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
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
            '$habitsCompletats de $objectiu hàbits completats',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: habits.length,

              itemBuilder: (context, index) {
                final habit = habits[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(habit.color),
                  ),

                  title: Text(habit.nom),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botó per editar l'hàbit
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar hàbit',
                        onPressed: () {
                          mostrarFormulariHabit(
                            habitEditar: habit,
                          );
                        },
                      ),

                      // Botó per eliminar l'hàbit
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Eliminar hàbit',
                        onPressed: () {
                          eliminarHabit(habit);
                        },
                      ),

                      // Casella per marcar l'hàbit
                      Checkbox(
                        value: estaCompletatAvui(habit),
                        onChanged: (valor) {
                          if (valor != null) {
                            canviarEstatHabit(habit, valor);
                          }
                        },
                      ),
                    ],
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
