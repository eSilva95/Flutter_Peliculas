// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
import 'package:peliculas/src/widgets/swiper_card_widget.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Películas'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context, 
                delegate: DataSearch(),
                // query: 'Mandar un argumento a buscar'
              );
            },
          )
        ],
      ),
      // drawer: Container(
      //   child: ListTile(
      //     trailing: Icon(Icons.toys),
      //     title: Text('Pagina 1', style: TextStyle(color: Colors.white),),
      //   ),
      // ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _swiperCards(context),
            _footer(context),
          ],
        ),
      ),
    );
    return scaffold;
  }

  _swiperCards(context) {
    return Column(
      children: [
        Text('En Cartelera', style: Theme.of(context).textTheme.headline6,),
        SizedBox(height: 5.0,),
        FutureBuilder(
          future: peliculasProvider.getEnCines(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
             return SwiperCard(peliculas: snapshot.data); 
            } else {
              return Container(
                // height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: CircularProgressIndicator()
                ),
              );
            }
          },
        ),
      ],
    );
  }

  _footer(context) {
    peliculasProvider.getPopulares();

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text('Populares', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}