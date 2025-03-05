import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ClockPage extends StatefulWidget {
  static String routeName = '/clock';
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer _timeUpdateTimer;
  late Timer _apiCallTimer;
  String _formattedTime = '';
  String _formattedDate = '';
  String _calendarWeek = '';
  int? randomNumber;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });

    _apiCallTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchRandomNumber();
    });
  }

  Future<void> fetchRandomNumber() async {
    try {
      final response = await http.get(
        Uri.parse('http://www.randomnumberapi.com/api/v1.0/random'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> numberList = json.decode(response.body);
        setState(() {
          randomNumber = numberList[0];
        });
      } else {
        throw Exception('Failed to load random number');
      }
    } catch (e) {
      print(e);
    }
  }

  // bool _isPrime(int n) {
  //   if (n <= 1) return false;
  //   for (int i = 2; i <= n / 2; i++) {
  //     if (n % i == 0) return false;
  //   }
  //   return true;
  // }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _formattedTime = DateFormat('HH:mm').format(now);
      _formattedDate = DateFormat('E. d. MMM.').format(now);
      int dayOfYear = int.parse(DateFormat("D").format(now));
      int weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
      _calendarWeek = 'KW $weekNumber';
    });
  }

  @override
  void dispose() {
    _timeUpdateTimer.cancel();
    _apiCallTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clock
            Text(
              _formattedTime,
              style: const TextStyle(fontSize: 64, color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Date and calendar week
            _buildDateAndCalendarWeek(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndCalendarWeek() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 28, color: Colors.white),
        children: <InlineSpan>[
          TextSpan(text: _formattedDate),
          TextSpan(text: ' '),
          TextSpan(text: _calendarWeek, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
