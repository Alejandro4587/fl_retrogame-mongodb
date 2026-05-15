import 'package:flutter/material.dart';

class AppTheme {

  static const Color primary = Color(0xFF00E676); 
  

  static const Color background = Color(0xFF121212);
  

  static const Color cardColor = Color(0xFF1E1E1E);


  static final ThemeData gamerTheme = ThemeData.dark().copyWith(
    
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    
    cardColor: cardColor, 
    

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, 
      foregroundColor: primary, 
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: primary,
        letterSpacing: 2.0, 
      ),
      iconTheme: IconThemeData(color: primary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor, 
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white30),
      
      prefixIconColor: primary,
      suffixIconColor: primary,

      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white10),
        borderRadius: BorderRadius.circular(15),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary, 
        foregroundColor: Colors.black, 
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        elevation: 10,
        shadowColor: primary, 
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.black,
    ),
    
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white), 
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    
    iconTheme: const IconThemeData(
      color: primary,
    ),
  );
}