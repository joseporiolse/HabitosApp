
import 'package:shared_preferences/shared_preferences.dart';
// Importem la llibreria per guardar i recuperar dades localment

class PreferenciesService {
  // Classe que gestiona les dades guardades de l'aplicació

  static const String clauNom = 'nom';
  // Clau per identificar el nom

  static const String clauObjectiu = 'objectiu';
  // Clau per identificar l'objectiu diari

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
}
