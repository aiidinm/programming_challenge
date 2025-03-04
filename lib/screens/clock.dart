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
  DateTime? _lastPrimeTime;
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
        Uri.parse(
          'http://www.randomnumberapi.com/api/v1.0/randomredditnumber?min=1&max=1000&count=1',
        ),
      );

      final data = json.decode(response.body);
      setState(() {
        _randomNumber = data;
        if (_isPrime(_randomNumber!)) {
          _showPrimeDialog(_randomNumber!);
        }
      });
    } on http.ClientException catch (e) {
      print('خطا در دریافت عدد تصادفی: ${e.message}');
      // می‌توانید در اینجا یک دیالوگ خطا به کاربر نمایش دهید.
    } catch (e) {
      print('خطای ناشناخته: $e');
      // می‌توانید در اینجا یک دیالوگ خطای عمومی به کاربر نمایش دهید.
    }
  }

  bool _isPrime(int n) {
    if (n <= 1) return false;
    for (int i = 2; i <= n / 2; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _showPrimeDialog(int primeNumber) {
    final now = DateTime.now();
    final elapsedTime =
        _lastPrimeTime != null ? now.difference(_lastPrimeTime!) : null;
    setState(() {
      _lastPrimeTime = now;
    });
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تبریک!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('شما یک عدد اول پیدا کردید، عدد آن: $primeNumber'),
                if (elapsedTime != null)
                  Text('زمان از آخرین عدد اول: ${elapsedTime.inSeconds} ثانیه'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('بستن'),
              ),
            ],
          ),
    );
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
                  ? 'عدد تصادفی: $_randomNumber'
                  : 'در حال دریافت عدد...',
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
