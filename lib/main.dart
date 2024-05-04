import 'package:flutter/material.dart';
import 'abir_chat_screen.dart';
import 'mehdi_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BMCC AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            // Text theme with white color for contrast
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
            ),
            // AppBar theme with dark background and white text
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            // Icon theme with white color
            iconTheme: const IconThemeData(color: Colors.white),
            // Adjust visualDensity based on your preference (optional)
            visualDensity: VisualDensity.adaptivePlatformDensity,

            //bottom sheet
            bottomSheetTheme: const BottomSheetThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              elevation: 16.0,
              modalElevation: 8.0,
              clipBehavior: Clip.antiAlias,
            ),
            useMaterial3: true),
        home: const Login());
  }
}

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  final _correctUsername = "mehdi.shakibapour53";
  final _correctPassword = "abcd";
  final _abircorrectUsername2 = "abir.mahmood001";
  final _abircorrectPassword2 = "abc";

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16.0),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'About Us',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  // Add your "About Us" content here
                  Text(
                    'This is a brief description of your app and its purpose.',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _greetUser() {
    if (username == _correctUsername && password == _correctPassword) {
      const firstName = "Mehdi";
      //Mehdi
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ChatHomePage(firstName: firstName)));
    } else if (username == _abircorrectUsername2 &&
        password == _abircorrectPassword2) {
      const firstName = "Abir";
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ChatHomePage(firstName: firstName)));
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Username or Password🙂"),
        backgroundColor: Colors.blueGrey,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Panther AI"),
      ),
      body: Center(
        child: SizedBox(
          width: 1000,
          height: 1000,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  onChanged: (value) => username = value.toLowerCase(),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                  onChanged: (value) => password = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _greetUser,
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () => _showModalBottomSheet(),
        child: const Text('About Us'),
      ),
    );
  }
}

// This is a placeholder for your actual home page
class ChatHomePage extends StatelessWidget {
  final String firstName;

  const ChatHomePage({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    if (firstName == "Mehdi") {
      return MehdiChatScreen(firstName: firstName); // Widget for Mehdi
    } else if (firstName == "Abir") {
      return AbirChatScreen(firstName: firstName); // Widget for Abir
    } else {
      return Text("$firstName is not a BMCC student.");
    }
  }
}
