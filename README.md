# Clock App

This Flutter application displays the current time and fetches random numbers periodically. If a prime number is found, it stops the request and navigates to a new screen displaying the number and elapsed time.

## Patterns & Libraries Used

### Patterns:
- **Stateful Widget**: Used to manage the state of the clock and fetch random numbers since these data need to be updated regularly.
- **Navigator & Routing**: Used for navigating between `ClockPage` and `PrimeNumber` screens.

### Libraries:
- **intl**: For formatting date and time.
- **http**: For fetching random numbers from an API.
- **async**: For running timers and periodically updating information.
- **convert**: For processing JSON responses from the API.

## Design Assumptions
- The user should see the current time updating every second, so `Timer.periodic` is used.
- Random numbers should be fetched every 10 seconds. If a prime number is found, the request stops, and the app navigates to a new screen displaying the found prime number and the elapsed time.
- The app’s performance should remain stable, so `mounted` is used to check the screen state before using `Navigator.push`.
- Displaying the elapsed time since the last prime number is essential, so `DateTime.difference` is used for calculation.
