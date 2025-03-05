import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:programming_challenge/screens/prime_number.dart';

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
  int? _randomNumber;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });

    _apiCallTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchRandomNumber();
    });
  }

  Future<void> _fetchRandomNumber() async {
    try {
      final response = await http.get(
        Uri.parse('http://www.randomnumberapi.com/api/v1.0/random'),
      );
      final data = json.decode(response.body);
      setState(() {
        _randomNumber = data[0];
        if (_isPrime(_randomNumber!)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrimeNumber(primeNumber: _randomNumber!),
            ),
          );
        }
      });
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  bool _isPrime(int n) {
    if (n <= 1) return false;
    for (int i = 2; i <= n / 2; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

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
            Text(
              _randomNumber != null
                  ? 'Random number: $_randomNumber'
                  : 'Fetching random number...',
            ),
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
