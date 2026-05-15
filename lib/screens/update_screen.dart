import 'dart:io';
import 'package:fl_retrogame/services/mongo_services.dart';
import 'package:fl_retrogame/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateScreenVideojuegos extends StatefulWidget {
  final String uid;
  final String nombre;
  final String precio;
  final String estado;
  final String imagen;

  const UpdateScreenVideojuegos({
    super.key,
    required this.uid,
    required this.nombre,
    required this.precio,
    required this.estado,
    required this.imagen,
  });

  @override
  State<UpdateScreenVideojuegos> createState() =>
      _UpdateScreenVideojuegosState();
}

class _UpdateScreenVideojuegosState extends State<UpdateScreenVideojuegos> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController estadoController;

  final _formKey = GlobalKey<FormState>();
  File? _newImageFile;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nombre);
    priceController = TextEditingController(text: widget.precio);
    estadoController = TextEditingController(text: widget.estado);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isUpdating = true);

    try {
      String? nuevaUrl;

      // Si se seleccionó nueva imagen, subirla a Cloudinary
      if (_newImageFile != null) {
        nuevaUrl = await uploadImagen(_newImageFile!);
      }

      await updateVideoJuego(
        widget.uid,
        nameController.text,
        priceController.text,
        estadoController.text,
        nuevaUrl ?? widget.imagen,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('¿Borrar juego?', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Esta acción es definitiva y no se puede deshacer.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await deleteVideoJuego(widget.uid);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(
                'BORRAR',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Editar Videojuego',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F0F), Color(0xFF1A2E1B)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 110, left: 25, right: 25, bottom: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Container(
                      height: 240,
                      width: 170,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _newImageFile != null ? primaryColor : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _newImageFile != null
                            ? Image.file(_newImageFile!, fit: BoxFit.cover)
                            : (widget.imagen.isNotEmpty
                                ? Image.network(widget.imagen, fit: BoxFit.cover)
                                : Icon(Icons.image, size: 60, color: primaryColor)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Toca la imagen para cambiarla',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 30),
                buildGamerField(
                  controller: nameController,
                  label: 'Nombre',
                  icon: Icons.videogame_asset,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20),
                buildGamerField(
                  controller: estadoController,
                  label: 'Estado',
                  icon: Icons.auto_awesome,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20),
                buildGamerField(
                  controller: priceController,
                  label: 'Precio (€)',
                  icon: Icons.payments,
                  primaryColor: primaryColor,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _isUpdating ? null : _update,
                    child: _isUpdating
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'GUARDAR CAMBIOS',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 2),
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => _confirmDelete(context),
                    child: const Text(
                      'ELIMINAR VIDEOJUEGO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}