import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_handler/network_handler.dart';
import 'package:network_handler/network_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_service.dart';
import '../models/locations_model.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<LocationsModel>> _savedLocationsModel;
  late List<LocationsModel>? _locationsModel = [];

  @override
  void initState() {
    super.initState();
    _savedLocationsModel = _prefs.then(
      (SharedPreferences prefs) {
        return LocationsModelFromJson(prefs.getString('locations') ?? "");
      },
    );
  }

  String dropdownValue = 'name a-z';
  final items = [
    'name a-z',
    'name z-a',
  ];
  String inputText = "";

  NetworkStatus _status = NetworkStatus.unknown;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Type your start point...',
                ),
                onChanged: (inputData) {
                  _locationsModel = null;
                  inputData.isEmpty ? inputText = "" : inputText = inputData;
                  setState(() {});
                  getData(inputData);
                  if (kDebugMode) {
                    print("t::$inputData");
                  }
                },
              ),
            ),
            //sort dropdown
            /*DropdownButton<String>(
              hint: const Text("choisir votre domaine"),
              value: dropdownValue,
              iconSize: 36,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: items.map(buildMenuItem).toList(),
              onChanged: (String? newValue) {
                setState(
                  () {
                    dropdownValue = newValue!;
                  },
                );
              },
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),*/
            NetworkHandler(
              onChanged: (NetworkStatus status) {
                setState(() {
                  _status = status;
                });
              },
              child: _status == NetworkStatus.connected
                  ? Expanded(
                      child: inputText.isEmpty
                          ? const Center(
                              child: Text("Search results are displayed here"),
                            )
                          : _locationsModel == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _locationsModel!.isEmpty
                                  ? Center(
                                      child: Image.asset(
                                          "assets/Location_not_found.png"),
                                    )
                                  : Scrollbar(
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        itemCount: _locationsModel!.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: Column(
                                              children: [
                                                // ignore: prefer_interpolation_to_compose_strings
                                                Text(
                                                  "Name : ${_locationsModel![index].name}",
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  "Type : ${_locationsModel?[index].type}",
                                                  overflow: TextOverflow.fade,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    "Possibly the locality of the match : ${_locationsModel![index].isBest}"),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    " parent name : ${_locationsModel?[index].parent?.name}"),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                    )
                  : Expanded(
                      //child: Center(
                      child: Column(
                        children: [
                          const Text("you are offline"),
                          Expanded(
                            child:
                                //Text("network error"),
                                FutureBuilder<List<LocationsModel>>(
                              future: _savedLocationsModel,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<LocationsModel>>
                                      snapshot) {
                                return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    if (kDebugMode) {
                                      print("snapshot::$snapshot");
                                    }
                                    return Card(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Name : ${snapshot.data![index].name}",
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "Type : ${snapshot.data?[index].type}",
                                            overflow: TextOverflow.fade,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                              "Possibly the locality of the match : ${snapshot.data![index].isBest}"),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                              " parent name : ${snapshot.data?[index].parent?.name}"),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      //),
                    ),
            ),
            /*Expanded(
              child: _locationsModel == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _locationsModel!.isEmpty
                      ? const Center(
                          child: Text("no search matches"),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: _locationsModel!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  children: [
                                    /*Text(_locationsModel?[index].id ?? "id"),
                                  const SizedBox(
                                    height: 10.0,
                                  ),*/
                                    Text(
                                      _locationsModel?[index].name ?? "name",
                                      overflow: TextOverflow.visible,
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      _locationsModel?[index]
                                              .disassembledName ??
                                          "disassembledName",
                                      overflow: TextOverflow.fade,
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    // Text(_locationsModel?[index].matchQuality??),
                                    // Text(_locationsModel?[index].isBest??),
                                    //  Text(_locationsModel?[index].coord??),
                                    /*Text(
                                    _locationsModel?[index].type ?? "type",
                                    overflow: TextOverflow.ellipsis,
                                  ),*/
                                    /*Text(_locationsModel?[index].parent?.id ??
                                      "id"),
                                  const SizedBox(
                                    height: 10.0,
                                  ),*/
                                    Text(_locationsModel?[index].parent?.name ??
                                        "name"),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    /*Text(_locationsModel?[index].parent?.type ??
                                      "type"),
                                  const SizedBox(
                                    height: 20.0,
                                  ),*/
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),
          */
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ), // Text
      ); // DropdownMenuItem

  void getData(String startPoint) async {
    final SharedPreferences prefs = await _prefs;
    _locationsModel = (await ApiService().getLocations(startPoint));
    _locationsModel?.sort(((a, b) => a.name!.compareTo(b.name!)));

    if (_locationsModel != null && _locationsModel!.isNotEmpty) {
      _savedLocationsModel = _prefs.then((SharedPreferences prefs) {
        return LocationsModelFromJson(prefs.getString('locations') ?? "");
      });
    }
    if (kDebugMode) {
      print("_locationsModel:::$_locationsModel");
    }
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }
}
