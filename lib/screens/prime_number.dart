import 'package:flutter/material.dart';
import 'package:programming_challenge/screens/clock.dart';

class PrimeNumber extends StatefulWidget {
  static String routeName = '/prime_number';
  final int randomNumber;
  final Duration elapsedTime;

  const PrimeNumber({
    super.key,
    required this.randomNumber,
    required this.elapsedTime,
  });

  @override
  State<PrimeNumber> createState() => _PrimeNumberState();
}

class _PrimeNumberState extends State<PrimeNumber> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 12, 2),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 12, 2),
        elevation: 0,
        centerTitle: true,
        title: Container(
          width: 34,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Congrats!',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Prime number: ${widget.randomNumber}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Time since last prime: ${_formatDuration(widget.elapsedTime)}',
                  style: const TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, ClockPage.routeName);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
