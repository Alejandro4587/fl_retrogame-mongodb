import 'package:fl_retrogame/screens/screens.dart';
import 'package:fl_retrogame/services/mongo_services.dart';
import 'package:flutter/material.dart';

class HomeGame extends StatefulWidget {
  const HomeGame({super.key});

  @override
  State<HomeGame> createState() => _HomeGameState();
}

class _HomeGameState extends State<HomeGame> {
  late Future<List> _videojuegosFuture;

  @override
  void initState() {
    super.initState();
    _videojuegosFuture = getVideoJuegos();
  }

  void _refresh() {
    setState(() {
      _videojuegosFuture = getVideoJuegos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true, // Para que el gradiente suba hasta arriba
      appBar: AppBar(
        title: const Text(
          'Videojuegos Retro',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.black, size: 30),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InsertScreenVideojuegos(),
            ),
          );
          _refresh();
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F),
              Color(0xFF1A2E1B),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 10),
          child: FutureBuilder(
            future: _videojuegosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar datos', style: TextStyle(color: Colors.white)),
                );
              }

              if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return const Center(
                  child: Text('No hay juegos disponibles', style: TextStyle(color: Colors.white)),
                );
              }

              final List juegos = snapshot.data!;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, 
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: juegos.length,
                itemBuilder: (context, index) {
                  final item = juegos[index];
                  String? imagenUrl = item['imagen'];
                  bool tieneImagen = imagenUrl != null && imagenUrl.isNotEmpty;

                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateScreenVideojuegos(
                            uid: item['uid'],
                            nombre: item['nombre'],
                            precio: item['precio'],
                            estado: item['estado'],
                            imagen: item['imagen'],
                          ),
                        ),
                      );
                      _refresh();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                        image: tieneImagen
                            ? DecorationImage(
                                image: NetworkImage(imagenUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[900],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nombre'] ?? 'Sin nombre',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item['precio'] ?? '0'} €',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item['estado'] ?? '??',
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}