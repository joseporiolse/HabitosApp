
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habitos.dart';

// Gestionem les dades que es guarden localment a l'aplicació
class PreferenciesService {

  // Claus per identificar les diferents dades guardades
  static const String clauNom = 'nom';
  static const String clauObjectiu = 'objectiu';
  static const String clauHabits = 'habits';
  static const String clauApertures = 'apertures';
  static const String clauHistorialApertures = 'historial_apertures';
  static const String clauTemaFosc = 'tema_fosc';
  static const String clauMidaLletra = 'mida_lletra';
  static const String clauOcultarCompletats = 'ocultar_completats';

  Future<void> guardarNom(String nom) async {
    // Guardem el nom de l'usuari

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(clauNom, nom);
  }

  Future<void> guardarObjectiu(int objectiu) async {
    // Guardem l'objectiu diari de l'usuari

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(clauObjectiu, objectiu);
  }

  Future<String?> obtenirNom() async {
    // Recuperem el nom guardat o null si no existeix

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(clauNom);
  }

  Future<int?> obtenirObjectiu() async {
    // Recuperem l'objectiu guardat o null si no existeix

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(clauObjectiu);
  }

  Future<void> guardarHabits(List<Habit> habits) async {
    // Convertim els hàbits a JSON per poder guardar-los

    final prefs = await SharedPreferences.getInstance();

    final llistaJson = habits.map((habit) => habit.toJson()).toList();
    final textJson = jsonEncode(llistaJson);

    await prefs.setString(clauHabits, textJson);
  }

  Future<bool> existeixenHabitsGuardats() async {
    // Comprovem si ja existeix una llista d'hàbits guardada

    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(clauHabits);
  }

  Future<List<Habit>> obtenirHabits() async {
    // Recuperem els hàbits guardats

    final prefs = await SharedPreferences.getInstance();
    final textJson = prefs.getString(clauHabits);

    // Si no hi ha hàbits guardats, retornem una llista buida
    if (textJson == null) {
      return [];
    }

    // Convertim el JSON en una llista d'objectes Habit
    final llistaJson = jsonDecode(textJson) as List<dynamic>;

    return llistaJson.map((element) {
      return Habit.fromJson(element as Map<String, dynamic>);
    }).toList();
  }

  Future<void> esborrarTotalDades() async {
    // Esborrem totes les dades guardades de l'aplicació

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> registrarObertura() async {
    // Actualitzem el comptador i l'historial d'obertures

    final prefs = await SharedPreferences.getInstance();

    final aperturesActuals = prefs.getInt(clauApertures) ?? 0;
    await prefs.setInt(clauApertures, aperturesActuals + 1);

    // Afegim la data i hora actuals a l'historial
    final historial = prefs.getStringList(clauHistorialApertures) ?? [];
    historial.add(DateTime.now().toIso8601String());

    await prefs.setStringList(clauHistorialApertures, historial);
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
  }

  Future<bool> obtenirTemaFosc() async {
    // Recuperem el tema guardat o utilitzem el clar per defecte

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(clauTemaFosc) ?? false;
  }

  Future<void> guardarMidaLletra(double valor) async {
    // Guardem la mida de la lletra i les icones

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(clauMidaLletra, valor);
  }

  Future<double> obtenirMidaLletra() async {
    // Recuperem la mida guardada o utilitzem la normal per defecte

    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(clauMidaLletra) ?? 1.0;
  }

  Future<void> guardarOcultarCompletats(bool valor) async {
    // Guardem si volem ocultar els hàbits completats

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(clauOcultarCompletats, valor);
  }

  Future<bool> obtenirOcultarCompletats() async {
    // Recuperem si volem ocultar els hàbits completats

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(clauOcultarCompletats) ?? false;
  }
}
