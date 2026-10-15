
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habitos.dart';

// Importem la llibreria per guardar i recuperar dades localment

class PreferenciesService {
  // Classe que gestiona les dades guardades de l'aplicació

  static const String clauNom = 'nom';
  // Clau per identificar el nom

  static const String clauObjectiu = 'objectiu';
  // Clau per identificar l'objectiu diari

  static const String clauHabits = 'habits';
  // Clau per identificar la llista d'hàbits guardats

  static const String clauApertures = 'apertures';
// Clau per guardar el nombre d'obertures

  static const String clauHistorialApertures = 'historial_apertures';
// Clau per guardar les dates i hores d'obertura

  static const String clauTemaFosc = 'tema_fosc';
// Clau per guardar el tema clar o fosc

  static const String clauMidaLletra = 'mida_lletra';
// Clau per guardar la mida de la lletra i les icones

  static const String clauOcultarCompletats = 'ocultar_completats';
// Clau per guardar si ocultem els hàbits completats

  Future<void> guardarNom(String nom) async {
    // Funció que guarda el nom de l'usuari

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    await prefs.setString(clauNom, nom);
    // Guardem el nom com a String
  }

  Future<void> guardarObjectiu(int objectiu) async {
    // Funció que guarda l'objectiu diari

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    await prefs.setInt(clauObjectiu, objectiu);
    // Guardem l'objectiu com a número enter
  }

  Future<String?> obtenirNom() async {
    // Funció que recupera el nom guardat
    // String? indica que pot retornar un text o null

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    return prefs.getString(clauNom);
    // Retornem el nom guardat o null si no existeix
  }

  Future<int?> obtenirObjectiu() async {
    // Funció que recupera l'objectiu diari
    // int? indica que pot retornar un enter o null

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    return prefs.getInt(clauObjectiu);
    // Retornem l'objectiu guardat o null si no existeix
  }

  Future<void> guardarHabits(List<Habit> habits) async {
    // Funció que guarda la llista d'hàbits

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    final llistaJson = habits.map((habit) => habit.toJson()).toList();
    // Convertim cada hàbit en un mapa

    final textJson = jsonEncode(llistaJson);
    // Convertim la llista en un String JSON

    await prefs.setString(clauHabits, textJson);
    // Guardem els hàbits a les preferències
  }

  Future<bool> existeixenHabitsGuardats() async {
    // Comprovem si ja existeix una llista d'hàbits guardada

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    return prefs.containsKey(clauHabits);
    // Retornem si existeix la clau dels hàbits
  }

  Future<List<Habit>> obtenirHabits() async {
    // Funció que recupera la llista d'hàbits guardats

    final prefs = await SharedPreferences.getInstance();
    // Obtenim les preferències de l'aplicació

    final textJson = prefs.getString(clauHabits);
    // Recuperem el text JSON guardat

    if (textJson == null) {
      // Si no hi ha hàbits guardats, retornem una llista buida
      return [];
    }

    final llistaJson = jsonDecode(textJson) as List<dynamic>;
    // Convertim el text JSON en una llista

    return llistaJson.map((element) {
      return Habit.fromJson(element as Map<String, dynamic>);
    }).toList();
    // Reconstruïm els objectes Habit
  }

  Future<void> esborrarTotalDades() async{

    final prefs = await SharedPreferences.getInstance(); //Obtenim preferencies de l'app

    await prefs.clear(); //Esborrem totes les dades

  }

  Future<void> registrarObertura() async {
    // Registrem una nova obertura de l'aplicació

    final prefs = await SharedPreferences.getInstance();

    final aperturesActuals = prefs.getInt(clauApertures) ?? 0;
    // Recuperem les obertures anteriors

    await prefs.setInt(clauApertures, aperturesActuals + 1);
    // Incrementem el comptador

    final historial = prefs.getStringList(clauHistorialApertures) ?? [];
    // Recuperem les dates d'obertura

    historial.add(DateTime.now().toIso8601String());
    // Afegim la data i hora actuals

    await prefs.setStringList(clauHistorialApertures, historial);
    // Guardem l'historial actualitzat
  }

  Future<int> obtenirApertures() async {
    // Recuperem el nombre total d'obertures

    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(clauApertures) ?? 0;
  }

  Future<DateTime?> obtenirUltimaObertura() async {
    // Recuperem la data i hora de l'última obertura

    final prefs = await SharedPreferences.getInstance();

    final historial = prefs.getStringList(clauHistorialApertures) ?? [];

    if (historial.isEmpty) {
      return null;
    }

    return DateTime.tryParse(historial.last);
  }


  Future<void> guardarTemaFosc(bool valor) async {
    // Guardem si l'usuari vol utilitzar el tema fosc

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(clauTemaFosc, valor);
    // Guardem el valor com a bool
  }

  Future<bool> obtenirTemaFosc() async {
    // Recuperem el tema guardat

    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(clauTemaFosc) ?? false;
    // Si no existeix, utilitzem el tema clar
  }

  Future<void> guardarMidaLletra(double valor) async {
    // Guardem la mida de la lletra i les icones

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(clauMidaLletra, valor);
    // Guardem el valor com a double
  }

  Future<double> obtenirMidaLletra() async {
    // Recuperem la mida guardada

    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(clauMidaLletra) ?? 1.0;
    // Si no existeix, utilitzem la mida normal
  }

  Future<void> guardarOcultarCompletats(bool valor) async {
    // Guardem si volem ocultar els hàbits completats

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(clauOcultarCompletats, valor);
    // Guardem el valor com a bool
  }

  Future<bool> obtenirOcultarCompletats() async {
    // Recuperem si volem ocultar els hàbits completats

    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(clauOcultarCompletats) ?? false;
    // Per defecte, mostrem tots els hàbits
  }
}
