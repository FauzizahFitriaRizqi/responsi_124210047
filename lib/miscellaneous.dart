import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KategoriMiscellaneous extends StatefulWidget {
  @override
  _KategoriMiscellaneousState createState() => _KategoriMiscellaneousState();
}

class _KategoriMiscellaneousState extends State<KategoriMiscellaneous> {
  late Future<List<Map<String, dynamic>>> kategoriList;

  @override
  void initState() {
    super.initState();
    kategoriList = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final apiUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Miscellaneous';
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
        title: Text('Miscellaneous Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: kategoriList,
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
                crossAxisCount: 2, // Jumlah kolom dalam grid
                crossAxisSpacing: 8.0, // Jarak antar kolom
                mainAxisSpacing: 8.0, // Jarak antar baris
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var kategoriItem = snapshot.data![index];
                return KategoriItem(
                  title: kategoriItem['strMeal'],
                  imageUrl: kategoriItem['strMealThumb'],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KategoriItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  KategoriItem({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Implementasi logika navigasi sesuai kebutuhan
          String mealId = ''; // Gantilah dengan id makanan yang sesuai
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(mealId: mealId)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String mealId;

  DetailPage({required this.mealId});

  // Implementasi halaman detail sesuai kebutuhan
  @override
  Widget build(BuildContext context) {
    // Contoh tampilan halaman detail
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Text('Meal ID: $mealId'),
      ),
    );
  }
}
