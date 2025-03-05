import 'package:flutter/material.dart';
import 'package:programming_challenge/screens/clock.dart';

class PrimeNumber extends StatefulWidget {
  static String routeName = '/prime_number';
  final int primeNumber;
  const PrimeNumber({super.key, required this.primeNumber});

  @override
  State<PrimeNumber> createState() => _PrimeNumberState();
}

class _PrimeNumberState extends State<PrimeNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 12, 2),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 12, 2),
        elevation: 0,
        centerTitle: true,
        title: Container(
          width: 28,
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
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Congrats!',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                // const SizedBox(height: 10),
                Text(
                  'You obtained a prime number,it was: ${widget.primeNumber}',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                // const SizedBox(height: 10),
                Text(
                  'Time since last prime number <YY>',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, ClockPage.routeName);
                },
                child: Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
