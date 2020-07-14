import 'package:flutter/material.dart';

import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => HomePage(),
        'detalle' : (BuildContext context) => DetallePeliculaPage(),
        // 'search' : (BuildContext contex) => SearchPage(),

      },
    );
  }
}