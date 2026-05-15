import 'dart:io';
import 'package:fl_retrogame/screens/screens.dart';
import 'package:fl_retrogame/services/mongo_services.dart';
import 'package:fl_retrogame/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InsertScreenVideojuegos extends StatefulWidget {
  const InsertScreenVideojuegos({super.key});

  @override
  State<InsertScreenVideojuegos> createState() =>
      _InsertScreenVideojuegosState();
}

class _InsertScreenVideojuegosState extends State<InsertScreenVideojuegos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una imagen')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Subir imagen a Cloudinary via nuestra API
      String urlImagen = await uploadImagen(_imageFile!);

      // 2. Guardar datos en MongoDB
      await addVideoJuego(
        nameController.text,
        priceController.text,
        estadoController.text,
        urlImagen,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Nuevo Videojuego',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          padding: const EdgeInsets.only(
            top: 110,
            left: 25,
            right: 25,
            bottom: 30,
          ),
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
                          color: _imageFile != null
                              ? primaryColor
                              : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 45,
                                  color: primaryColor,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Añadir Portada',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                buildGamerField(
                  controller: nameController,
                  label: 'Nombre del Videojuego',
                  icon: Icons.videogame_asset,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20),
                buildGamerField(
                  controller: estadoController,
                  label: 'Estado (Coleccionista, Usado...)',
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
                    onPressed: _isUploading ? null : _saveGame,
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'GUARDAR VIDEOJUEGO',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
