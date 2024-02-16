import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AgeCalculationScreen(),
    );
  }
}

class AgeCalculationScreen extends StatefulWidget {
  @override
  _AgeCalculationScreenState createState() => _AgeCalculationScreenState();
}

class _AgeCalculationScreenState extends State<AgeCalculationScreen> {
  DateTime? _selectedDate;
  String _ageDetails = 'Select your birthdate';

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
                _updateAgeDetails();
              });
            },
          ),
        );
      },
    );
  }

  void _updateAgeDetails() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      final age = _calculateAge(_selectedDate!, now);

      setState(() {
        _ageDetails = 'Your age is ${age['years']} years, ${age['months']} months, and ${age['days']} days';
      });
    }
  }

  Map<String, int> _calculateAge(DateTime birthdate, DateTime currentDate) {
    int years = currentDate.year - birthdate.year;
    int months = currentDate.month - birthdate.month;
    int days = currentDate.day - birthdate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }

    if (days < 0) {
      final lastMonth = currentDate.subtract(Duration(days: currentDate.day));
      days = currentDate.difference(lastMonth).inDays + birthdate.day;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age Calculation App',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'ageDetails',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  _ageDetails,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Pick your birthdate',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
            ),
          ],
        ),
      ),
    );
  }
}
