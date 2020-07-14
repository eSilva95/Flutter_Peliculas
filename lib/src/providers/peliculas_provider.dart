import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey   = 'f45763701f9e6890486c06a68ce2b244';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-MX';

  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'language' : _language
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Actor>> getCasting(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key'  : _apikey,
      'language' : _language
    });

    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);

    final casting = new Casting.fromJsonList(decodedData['cast']);

    return casting.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });
    return await _procesarRespuesta(url);
  }
}