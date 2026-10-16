import 'package:flutter/material.dart';
import 'services/preferencies_service.dart';
import 'screens/home_screen.dart';
import 'screens/benvinguda_screen.dart';

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
  final objectiu = await preferencies.obtenirObjectiu();

  return nom != null &&
      nom.isNotEmpty &&
      objectiu != null &&
      objectiu > 0;
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
    if (!mounted) return;

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

          return Benvinguda(
            temaFosc: temaFosc,
            midaLletra: midaLletra,
            ocultarCompletats: ocultarCompletats,
            guardarAjustos: guardarAjustos,
          );
        },
      ),
    );
  }
}
