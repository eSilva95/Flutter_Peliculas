import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class SwiperCard extends StatelessWidget {
  final List<Pelicula> peliculas;

  SwiperCard({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, int index){
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
            },
            child: Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                )
              ),
            ),
          );
        },
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}