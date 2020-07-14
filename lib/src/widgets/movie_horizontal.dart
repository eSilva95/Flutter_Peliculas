import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() { 
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.24,
      child: PageView.builder(
        // pageSnapping: false, Sirve a para que las cards no tengan como un efecto de magnetismo al dejar de arrastrar
        controller: _pageController,
        // children: _tarjetas(context), no es necesario en el pageView.builder,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i]);
        }, //necesario solo en el pageView.builder
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';
    final _screenSize = MediaQuery.of(context).size;
    final tarjeta = Container(
        child: Column(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'), 
                  image: NetworkImage(pelicula.getPosterImg()),
                  fit: BoxFit.cover,
                  height: _screenSize.height * 0.2,
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: () {
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        },
      );
  }

//se dejo de usar por el item builder para que solo renderice las cards necesarias
  List<Widget> _tarjetas(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return peliculas.map((pelicula) {
      return Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'), 
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: _screenSize.height * 0.2,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}