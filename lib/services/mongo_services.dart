import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Para emulador Android usa: http://10.0.2.2:3000/api
// Para dispositivo físico usa: http://TU_IP_LOCAL:3000/api
const String baseUrl = 'http://TU_IP_LOCAL:3000/api';

Future<List> getVideoJuegos() async {
  final response = await http.get(Uri.parse('$baseUrl/videojuegos'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List videojuegos = data['data'];
    // Renombramos _id a uid para mantener compatibilidad con el resto de la app
    for (var item in videojuegos) {
      item['uid'] = item['_id'];
    }
    return videojuegos;
  } else {
    throw Exception('Error al obtener videojuegos');
  }
}

Future<void> addVideoJuego(
  String nombre,
  String precio,
  String estado,
  String imagenUrl,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/videojuegos'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nombre': nombre,
      'precio': precio,
      'estado': estado,
      'imagen': imagenUrl,
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Error al crear el videojuego');
  }
}

Future<void> updateVideoJuego(
  String uid,
  String newNombre,
  String newPrecio,
  String newEstado,
  String? newImagen,
) async {
  final response = await http.put(
    Uri.parse('$baseUrl/videojuegos/$uid'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nombre': newNombre,
      'precio': newPrecio,
      'estado': newEstado,
      'imagen': newImagen ?? '',
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar el videojuego');
  }
}

Future<void> deleteVideoJuego(String uid) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/videojuegos/$uid'),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al eliminar el videojuego');
  }
}

Future<List> searchVideoJuegos(String query) async {
  final response = await http.get(
    Uri.parse('$baseUrl/videojuegos/buscar?q=$query'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List resultados = data['data'];
    for (var item in resultados) {
      item['uid'] = item['_id'];
    }
    return resultados;
  } else {
    throw Exception('Error en la búsqueda');
  }
}

Future<String> uploadImagen(File imageFile) async {
  final uri = Uri.parse('$baseUrl/videojuegos/upload');
  final request = http.MultipartRequest('POST', uri);
  
  request.files.add(
    await http.MultipartFile.fromPath('imagen', imageFile.path),
  );

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  final data = jsonDecode(responseBody);

  if (response.statusCode == 200) {
    return data['url'];
  } else {
    throw Exception('Error al subir la imagen');
  }
}