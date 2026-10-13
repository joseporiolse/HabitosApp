import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bienvenida(),
    );
  }
}

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController objetivoController = TextEditingController(); // Ens permet interactuar dins i llegeix lo que hem ficat
  final PreferenciasService preferencias = PreferenciasService(); // Creem un objecte per accedir a les funcions del servei

  @override
  Widget build(BuildContext context) {
    //Crea lo que mostrara flutter es a dir la pantalla

    return Scaffold( //Es com la estructura basica per a tenir un ordre
      appBar: AppBar(
        title: const Text('Habit App'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        //Deixem un espai de 20 pixels en aquest cas en tots els costats de espai

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //fiquem .center degut a que el column es vertical i centra tot verticalment

          children: [ //fiquem tot lo que volem dins del column

            const Text(
              'Bienvenido a Habit App donde tus habitos suman puntos',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, //.bold es per ficar-ho amb negreta
              ),
            ),

            const SizedBox(height: 30),

            TextField( //Caixa on podra escriure el usuari
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: objetivoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Objetivo diario',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: guardaDatos,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> guardaDatos() async {
// Funció que s'executa quan premem el botó Continuar

    String nombre = nombreController.text.trim();
// Agafem el nom i eliminem els espais del principi i del final

    int? objetivo = int.tryParse(objetivoController.text.trim());
// Intentem convertir l'objectiu introduït a un número enter

    if (nombre.isEmpty || objetivo == null || objetivo <= 0) {
// Comprovem que el nom no estigui buit i que l'objectiu sigui vàlid

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introdueix un numero i nom valid'),

        ),
      );

      return;
// Aturem la funció si les dades són incorrectes
    }

    await preferencias.guardarNombre(nombre);
// Guardem el nom de l'usuari i esperem que acabi

    await preferencias.guardarObjetivo(objetivo);
// Guardem l'objectiu diari i esperem que acabi

  }
}
