import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Charges Predictor',
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.orangeAccent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();
  final TextEditingController smokerController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  String result = "";

  Future<void> makePrediction() async {
    final String apiUrl = "https://health-insurance-prediction-z4hv.onrender.com/predict";
    final Map<String, dynamic> data = {
      "age": int.tryParse(ageController.text) ?? 0,
      "sex": sexController.text,
      "bmi": double.tryParse(bmiController.text) ?? 0.0,
      "children": int.tryParse(childrenController.text) ?? 0,
      "smoker": smokerController.text,
      "region": regionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          result = "Predicted Insurance Charges: \$${responseData['predicted_insurance_charges']}";
        });
      } else {
        setState(() {
          result = "Error: ${response.body}";
        });
      }
    } catch (error) {
      setState(() {
        result = "An error occurred: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insurance Charges Predictor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter the following details:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 16),
              buildTextField("Age", ageController, "Enter your age (e.g., 30)"),
              buildTextField("Sex", sexController, "Enter male or female"),
              buildTextField("BMI", bmiController, "Enter your BMI (e.g., range of 10.0 to 50.0)"),
              buildTextField("Children", childrenController, "Number of children (e.g., 2)"),
              buildTextField("Smoker", smokerController, "Enter yes or no"),
              buildTextField("Region", regionController, "Enter region (e.g., northwest)"),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: makePrediction,
                  child: const Text("Predict"),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                result,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        keyboardType: label == "BMI" || label == "Age" || label == "Children"
            ? TextInputType.number
            : TextInputType.text,
      ),
    );
  }
}
