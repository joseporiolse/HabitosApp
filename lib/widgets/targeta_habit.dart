import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  // Guardem les dades de l'hàbit i les accions dels botons
  final String nom;
  final bool completat;
  final Color color;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const HabitTile({
    super.key,
    required this.nom,
    required this.completat,
    required this.color,
    required this.onChanged,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    // Mostrem el color, el nom i les opcions de cada hàbit
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
      ),

      title: Text(nom),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botó per editar l'hàbit
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar hàbit',
            onPressed: onEditar,
          ),

          // Botó per eliminar l'hàbit
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar hàbit',
            onPressed: onEliminar,
          ),

          // Casella per marcar l'hàbit
          Checkbox(
            value: completat,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}