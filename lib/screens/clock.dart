import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:programming_challenge/screens/find_prime_number.dart';

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
  DateTime? lastPrimeTime;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    lastPrimeTime = DateTime.now();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });

    _apiCallTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchRandomNumber();
    });
  }

  @override
  void dispose() {
    _timeUpdateTimer.cancel();
    _apiCallTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchRandomNumber() async {
    final response = await http.get(
      Uri.parse('http://www.randomnumberapi.com/api/v1.0/random'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> numberList = json.decode(response.body);
      randomNumber = numberList[0];
      if (_isPrime(randomNumber!)) {
        _apiCallTimer.cancel();
        DateTime now = DateTime.now();
        Duration elapsed = now.difference(lastPrimeTime ?? now);
        lastPrimeTime = now;
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (BuildContext context) => PrimeNumber(
                    randomNumber: randomNumber!,
                    elapsedTime: elapsed,
                  ),
            ),
          );
        }
      }
    } else {
      throw Exception('Failed to load random number');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Clock
            Text(
              _formattedTime,
              style: const TextStyle(fontSize: 64, color: Colors.white),
            ),
            const SizedBox(height: 8),

            _buildDateAndCalendarWeek(),
            // Center(child: Text(randomNumber.toString())),
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
