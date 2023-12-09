import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class mealkategori extends StatefulWidget {
  @override
  _MealkategoriListState createState() => _MealkategoriListState();
}

class _MealkategoriListState extends State<mealkategori> {
  late Future<List<Map<String, dynamic>>> mealkategori;

  @override
  void initState() {
    super.initState();
    mealkategori = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final apiUrl =
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['meals'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: mealkategori,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var mealItem = snapshot.data![index];
                return MealkategoriItem(
                  mealItem: mealItem,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MealkategoriItem extends StatelessWidget {
  late final Map<String, dynamic> mealItem;

  MealkategoriItem({
    required this.mealItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mealItem['strMealThumb'],
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(mealItem['strMeal']),
                onTap: () {
                  print('${mealItem['strMeal']} tapped!');

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
