import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {

  static const String claveNombre = 'nombre'; //Clau per identificar nom

  static const String claveObjetivo = 'objetivo';

  Future<void> guardarNombre(String nombre) async {
    //Funcio que guarda el nom d'usuari

    final prefs = await SharedPreferences.getInstance(); //Obtenim preferencies de la app

    await prefs.setString(claveNombre, nombre); //Guardem el nom com a String

  }

    Future<void> guardarObjetivo(int objetivo) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(claveObjetivo, objetivo);

    }

    Future<void> obtenerNombre(String nombre) async{

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(claveNombre);

    }

  Future<void> obtenerObjetivo(int objetivo) async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(ClaveObjetivo, objetivo);

  }

}