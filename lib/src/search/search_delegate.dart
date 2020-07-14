import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();

  String seleccion = '';

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America'
  ];

  final peliculasRecientes =[
    'Spiderman',
    'Capitan America'
  ] ;

  @override
   ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
      // Acciones del appbar (limpiar/cancelar busqueda)
      return [
        IconButton(
          icon: Icon(Icons.clear ), 
          onPressed: (){
            query = '';
          }
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del appbar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation
        ), 
        onPressed: () {
          close(context, null);
        }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados a mostrar
      return Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blueAccent,
          child: Text(seleccion),
        ),
      );
    }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Segerencias que se muestran al escribir
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) => ListTile(
              leading: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'), 
                image: NetworkImage(pelicula.getPosterImg()),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: (){
                close(context, null);
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            )).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Segerencias que se muestran al escribir
  //   final listaSugerida = (query.isEmpty) ? peliculasRecientes : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         trailing: Icon(Icons.arrow_right),
  //         title: Text(listaSugerida[i]),
  //         onTap: () {
  //           seleccion = listaSugerida[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }

}