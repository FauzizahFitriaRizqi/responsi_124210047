import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi/detailsmodel.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<DetailMeal>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = fetchMeals();
  }

  Future<List<DetailMeal>> fetchMeals() async {
    final response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.id}"));
    if (response.statusCode == 200) {
      List<DetailMeal> meals = (json.decode(response.body)['meals'] as List)
          .map((data) => DetailMeal.fromJson(data))
          .toList();
      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Detail"),
      ),
      body: FutureBuilder<List<DetailMeal>>(
        future: _meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No meals found.'),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.network(
                    snapshot.data![0].strMealThumb,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${snapshot.data![0].strMeal}",
                    style: const TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category : ${snapshot.data![0].strCategory}"),
                      Text("Area : ${snapshot.data![0].strArea}"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Center(
                        child: Text(
                          "Ingredients",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (snapshot.data![0].strIngredient1 != null &&
                          snapshot.data![0].strIngredient1 != "") (
                          Text("${snapshot.data![0].strIngredient1}")
                      ),
                      if (snapshot.data![0].strIngredient2 != null &&
                          snapshot.data![0].strIngredient2 != "") (
                          Text("${snapshot.data![0].strIngredient2}")
                      ),
                      // ... Add more ingredient Text widgets as needed
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Center(
                        child: Text(
                          "Instructions",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("${snapshot.data![0].strInstructions}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
