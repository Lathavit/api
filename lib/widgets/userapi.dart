import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/wines.dart';

class CallApi extends StatefulWidget {
  const CallApi({Key? key}) : super(key: key);

  @override
  State<CallApi> createState() => _CallApiState();
}

class _CallApiState extends State<CallApi> {
  List<Wine>? _wines;

  @override
  void initState() {
    super.initState();
    _fetchCodingResources();
  }

  Future<void> _fetchCodingResources() async {
    var dio = Dio(BaseOptions(
      responseType: ResponseType.plain,
      validateStatus: (status) {
        return status! < 500; // Allow insecure connections
      },
    ));
    var response = await dio.get('https://api.sampleapis.com/wines/reds');

    setState(() {
      List<dynamic> decodedData = jsonDecode(response.data.toString());
      _wines = decodedData.map((item) => Wine.fromJson(item)).toList();
    });
  }

  void _showWine(Wine wine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(wine.winery ?? ''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Displaying description
              Text('wine: ${wine.wine ?? ''}'),
              SizedBox(height: 10),
              // Displaying types
              Text('average rating: ${wine.average ?? ''}'),
              SizedBox(height: 10),
              // Displaying types
              Text('location: \n${wine.location ?? ''}'),
              
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine'),
        backgroundColor: Colors.grey.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: _wines == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _wines!.length,
                    itemBuilder: (context, index) {
                      var wine = _wines![index]; // Fixed variable name
                      return ListTile(
                        title: Text(wine.winery ?? ''),
                        subtitle: Text(wine.wine ?? ''),
                        trailing: wine.image == ''
                            ? null
                            : Image.network(
                                wine.image ?? '',
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  );
                                },
                              ),
                        onTap: () {
                          _showWine(wine);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CallApi(),
  ));
}
