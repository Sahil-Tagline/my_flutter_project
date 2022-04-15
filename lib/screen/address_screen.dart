import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class Addresspage extends StatefulWidget {
  final ValueChanged<String> add;
  Addresspage(this.add, {Key? key}) : super(key: key);

  @override
  _AddresspageState createState() => _AddresspageState();
}

class _AddresspageState extends State<Addresspage> {
  double latitude = 21;
  double longitude = 80;
  String location = "Search Location";
  String address = "";
  //String googleApikey = "AIzaSyBrSRBCPR2KHGD5AeFXUnLQNC5CoACG_BA";
  String googleApikey = "AIzaSyATRWDV9VZre0084fpbyYlc_z6WieX9o5M";
  late GoogleMapController myController;

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng _center = LatLng(latitude, longitude);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 23.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Center(
            child: Text(
          "Delivery_Address".tr(),
          style: GoogleFonts.josefinSans(fontSize: 22.sp),
        )),
        backgroundColor: Colors.black,
        actions: [
          Icon(
            Icons.local_grocery_store_outlined,
            color: Colors.black,
            size: 50.sp,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 4.5,
                    tilt: 0,
                    bearing: 0,
                  ),
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  markers: latitude != 21
                      ? {Marker(markerId: MarkerId('Home'), position: _center)}
                      : {},
                ),
                Positioned(
                  bottom: 20.h,
                  child: Container(
                    width: 360.w,
                    child: Center(
                      child: FloatingActionButton(
                        onPressed: () async {
                          //print("calling done");
                          LocationPermission permission;
                          permission = await Geolocator.requestPermission();
                          //print("permision granted");
                          Position? position =
                              await Geolocator.getCurrentPosition();
                          setState(() {
                            latitude = position.latitude;
                            longitude = position.longitude;
                          });
                          myController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(latitude, longitude),
                                zoom: 16,
                                tilt: 0,
                                bearing: 0,
                              ),
                            ),
                          );

                          List<Placemark> newPlace =
                              await placemarkFromCoordinates(
                                  latitude, longitude);

                          //print("$newPlace");
                          Placemark placeMark = newPlace[0];
                          String? street = placeMark.street;
                          String? name = placeMark.name;
                          String? subLocality = placeMark.subLocality;
                          String? locality = placeMark.locality;
                          String? administrativeArea =
                              placeMark.administrativeArea;
                          String? postalCode = placeMark.postalCode;
                          String? country = placeMark.country;

                          setState(() {
                            address =
                                "${street}, ${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
                          });
                          if (address.isNotEmpty) {
                            location = address;
                          }
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    //search input bar
                    top: 10,
                    child: InkWell(
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApikey,
                              mode: Mode.overlay,
                              types: [],
                              strictbounds: false,
                              //components: [Component(Component.country, 'np')],
                              //google_map_webservice package
                              onError: (err) {
                                print(err);
                              });

                          if (place != null) {
                            setState(() {
                              location = place.description.toString();
                            });

                            //form google_maps_webservice package
                            final plist = GoogleMapsPlaces(
                              apiKey: googleApikey,
                              apiHeaders:
                                  await const GoogleApiHeaders().getHeaders(),
                              //from google_api_headers package
                            );
                            String placeid = place.placeId ?? "0";
                            final detail =
                                await plist.getDetailsByPlaceId(placeid);
                            final geometry = detail.result.geometry!;
                            final lat = geometry.location.lat;
                            final lang = geometry.location.lng;
                            var newlatlang = LatLng(lat, lang);

                            address = detail.result.formattedAddress.toString();
                            //print("search address : ${detail.result.formattedAddress}");

                            setState(() {
                              latitude = lat;
                              longitude = lang;
                            });

                            //move map camera to selected place with animation
                            myController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: newlatlang, zoom: 17)));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Card(
                            child: Container(
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width - 40,
                                child: ListTile(
                                  title: Text(
                                    location,
                                    style:
                                        GoogleFonts.josefinSans(fontSize: 18),
                                  ),
                                  trailing: const Icon(Icons.search),
                                  dense: true,
                                )),
                          ),
                        ))),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (address.isNotEmpty) {
                widget.add(address);
                Navigator.pop(context);
              } else {
                snackbar(context, "Please_select_address".tr());
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 50.h,
              width: double.infinity,
              color: Colors.green,
              child: Center(
                child: Text(
                  "CONTINUE".tr(),
                  style: GoogleFonts.josefinSans(
                      fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
