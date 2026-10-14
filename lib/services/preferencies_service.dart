
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
}
