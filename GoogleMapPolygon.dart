import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/**
 * Este componente unicamente sirve para mostrar una zona previamente seleccionada
 */
class GoogleMapPolygon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GoogleMapPolygon();
  }
}

class _GoogleMapPolygon extends State<GoogleMapPolygon> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  final Map<String, Circle> _circles = {};
  final Map<String, Polygon> _polygon = {};
  bool isLoading = true;
  static final CameraPosition initPosition = CameraPosition(
    target: LatLng(13.702335, -89.2210908),
    zoom: 16,
  );

  @override
  void initState() {
    List<LatLng> puntos = new List();
    puntos.add(LatLng(13.684349, -89.274266));
    puntos.add(LatLng(13.681235, -89.274342));
    puntos.add(LatLng(13.681529, -89.270591));
    puntos.add(LatLng(13.680130, -89.267041));
    puntos.add(LatLng(13.680244, -89.263624));
    puntos.add(LatLng(13.682773, -89.263979));
    puntos.add(LatLng(13.682773, -89.266436));
    puntos.add(LatLng(13.684651, -89.269454));
    puntos.add(LatLng(13.684349, -89.274266));
    _polygon["1"] = Polygon(
      polygonId: PolygonId("sabana1"),
      points: puntos,
      strokeWidth: 0,
      fillColor: Color.fromRGBO(250, 10, 30, 0.3),
    );
    // TODO: implement initState
    super.initState();
    const position = LatLng(13.683273694338183, -89.27006397396326);
    this._goToUserPosition(position);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final googleMapView = GoogleMap(
        mapType: MapType.normal,
        compassEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: initPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers.values.toSet(),
        circles: _circles.values.toSet(),
        polygons: _polygon.values.toSet());
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Stack(children: <Widget>[
            googleMapView,
            Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text("La Sabana",
                                    style: Theme.of(context).textTheme.title),
                              ),
                              Text("Ciudad Meriot / La Libertad",
                                  style: Theme.of(context).textTheme.subtitle)
                            ]))))
          ]));
  }

  Future<void> _goToUserPosition(LatLng position) async {
    setState(() {
      final Circle circle = Circle(
          circleId: CircleId("1"),
          radius: 200,
          strokeWidth: 0,
          fillColor: Color.fromRGBO(250, 10, 30, 0.3),
          center: LatLng(position.latitude, position.longitude));
      final Marker marker = Marker(
        markerId: MarkerId("2"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "Tu posicion", snippet: 'Tu estas aquí'),
        onTap: () {},
      );
      _markers["2"] = marker;
      isLoading = false;
    });
    CameraPosition userPosition = CameraPosition(
        //bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        //tilt: 59.440717697143555,
        zoom: 16);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(userPosition));
  }
}
