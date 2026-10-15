
import 'package:flutter/material.dart';
import 'services/preferencies_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialitzem Flutter abans d'utilitzar les preferències

  final preferencies = PreferenciesService();

  await preferencies.registrarObertura();
  // Registrem una obertura en iniciar l'aplicació

  runApp(const MyApp());
}

// Comprovem si l'usuari ja ha guardat les seves dades
Future<bool> teDadesGuardades() async {

  final preferencies = PreferenciesService();


  final nom = await preferencies.obtenirNom();
  // Recuperem el nom guardat

  final objectiu = await preferencies.obtenirObjectiu();


  return nom != null && nom.isNotEmpty && objectiu != null && objectiu > 0;
  // Retornem true si les dues dades són vàlides
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PreferenciesService preferencies = PreferenciesService();

  bool temaFosc = false;
  double midaLletra = 1.0;
  bool ocultarCompletats = false;

  late Future<bool> dadesGuardades;

  @override
  void initState() {
    super.initState();

    // Comprovem les dades guardades només una vegada
    dadesGuardades = teDadesGuardades();

    // Carreguem la configuració de l'usuari
    carregarAjustos();
  }

  Future<void> carregarAjustos() async {
    // Recuperem els ajustos guardats
    final temaGuardat = await preferencies.obtenirTemaFosc();
    final midaGuardada = await preferencies.obtenirMidaLletra();
    final ocultarGuardat =
    await preferencies.obtenirOcultarCompletats();

    if (!mounted) return;

    setState(() {
      temaFosc = temaGuardat;
      midaLletra = midaGuardada;
      ocultarCompletats = ocultarGuardat;
    });
  }

  Future<void> guardarAjustos(
      bool nouTema,
      double novaMida,
      bool nouOcultar,
      ) async {
    // Actualitzem la configuració de l'aplicació
    setState(() {
      temaFosc = nouTema;
      midaLletra = novaMida;
      ocultarCompletats = nouOcultar;
    });

    // Guardem els ajustos amb SharedPreferences
    await preferencies.guardarTemaFosc(nouTema);
    await preferencies.guardarMidaLletra(novaMida);
    await preferencies.guardarOcultarCompletats(nouOcultar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit App',
      debugShowCheckedModeBanner: false,

      // Seleccionem el tema clar o fosc
      themeMode: temaFosc ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        // Modifiquem la mida de les icones
        iconTheme: IconThemeData(
          size: 24 * midaLletra,
        ),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),

        iconTheme: IconThemeData(
          size: 24 * midaLletra,
        ),
      ),

      // Modifiquem la mida dels textos
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(midaLletra),
          ),
          child: child!,
        );
      },

      home: FutureBuilder<bool>(
        future: dadesGuardades,
        builder: (context, resultat) {
          if (resultat.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (resultat.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error en carregar les dades'),
              ),
            );
          }

          if (resultat.data == true) {
            return HomeScreen(
              temaFosc: temaFosc,
              midaLletra: midaLletra,
              ocultarCompletats: ocultarCompletats,
              guardarAjustos: guardarAjustos,
            );
          }

          return const Benvinguda();
        },
      ),
    );
  }
}

class Benvinguda extends StatefulWidget {
  // Creem la pantalla de benvinguda

  const Benvinguda({super.key});

  @override
  State<Benvinguda> createState() => _BenvingudaState();
// Creem l'estat que gestionarà la pantalla de benvinguda
}

class _BenvingudaState extends State<Benvinguda> {

  final TextEditingController nomController = TextEditingController();
  // Permet controlar el text introduït al camp del nom

  final TextEditingController objectiuController = TextEditingController();
  

  final PreferenciesService preferencies = PreferenciesService();
  // Creem un objecte per accedir a les funcions que guarden les dades

  @override
  Widget build(BuildContext context) {
    // Construeix la interfície visual de la pantalla

    return Scaffold(
      // Estructura bàsica de la pantalla

      appBar: AppBar(
        title: const Text('Habit App'),
        // Títol de la barra superior
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        // Deixem un espai de 20 píxels a tots els costats

        child: Center(
          child: SingleChildScrollView(
            // Permet desplaçar la pantalla si no hi ha prou espai

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centrem verticalment els elements de la columna

              children: [

                const Text(
                  'Benvingut a Habit App, on els teus hàbits sumen punts',

                  style: TextStyle(
                    fontSize: 30,
                    // Mida del text

                    fontWeight: FontWeight.bold,
                    // Posem el text en negreta
                  ),
                ),

                const SizedBox(height: 30),
                // Deixem un espai vertical de 30 píxels

                TextField(
                  // Caixa on l'usuari pot escriure el nom

                  controller: nomController,
                  // Relacionem el camp amb el controlador del nom

                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    // Text que identifica el camp

                    border: OutlineInputBorder(),
                    // Afegim una vora al camp de text
                  ),
                ),

                const SizedBox(height: 20),
                // Deixem un espai entre els dos camps

                TextField(
                  // Caixa on l'usuari introdueix l'objectiu diari

                  controller: objectiuController,
                  // Relacionem el camp amb el controlador de l'objectiu

                  keyboardType: TextInputType.number,
                  // Mostrem el teclat numèric quan sigui possible

                  decoration: const InputDecoration(
                    labelText: 'Objectiu diari',

                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  // Creem el botó per continuar

                  onPressed: guardarDades,
                  // Quan premem el botó executem la funció guardarDades

                  child: const Text('Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> guardarDades() async {
    // Funció asíncrona que s'executa quan premem Continuar

    String nom = nomController.text.trim();
    // Agafem el nom i eliminem els espais del principi i del final

    int? objectiu = int.tryParse(objectiuController.text.trim());
    // Intentem convertir l'objectiu introduït a un número enter
    // Si no és un número vàlid, retornarà null

    if (nom.isEmpty || objectiu == null || objectiu <= 0) {
      // Comprovem que el nom no estigui buit
      // i que l'objectiu sigui un número superior a zero

      ScaffoldMessenger.of(context).showSnackBar(
        // Mostrem un missatge d'error a la pantalla

        const SnackBar(
          content: Text('Introdueix un nom i un número vàlids'),
        ),
      );

      return;
      // Aturem la funció si les dades no són correctes
    }

    await preferencies.guardarNom(nom);
    // Guardem el nom i esperem que acabi l'operació

    await preferencies.guardarObjectiu(objectiu);
    // Guardem l'objectiu diari i esperem que acabi l'operació

    if (!mounted) return;
    // Comprovem que la pantalla encara estigui activa


    final estatApp = context.findAncestorStateOfType<_MyAppState>();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          temaFosc: estatApp?.temaFosc ?? false,
          midaLletra: estatApp?.midaLletra ?? 1.0,
          ocultarCompletats: estatApp?.ocultarCompletats ?? false,
          guardarAjustos: estatApp?.guardarAjustos,
        ),
      ),
    );

    // Substituïm la benvinguda per la pantalla principal
  }

  @override
  void dispose() {
    // Alliberem els recursos dels controladors quan s'elimina el widget

    nomController.dispose();
    // Alliberem el controlador del nom

    objectiuController.dispose();
    // Alliberem el controlador de l'objectiu

    super.dispose();
    // Executem el dispose de la classe pare
  }
}
