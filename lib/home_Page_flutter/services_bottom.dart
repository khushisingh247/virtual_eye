import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesBottom extends StatefulWidget {
  const ServicesBottom({super.key});

  @override
  State<ServicesBottom> createState() => _ServicesBottomState();
}

class _ServicesBottomState extends State<ServicesBottom> {
  final List<Map<String, String>> contacts = [
    {'name': 'Police', 'number': '+91112'},
    {'name': 'Fire Department', 'number': '+911234567890'},
    {'name': 'Ambulance', 'number': '+919876543210'},
    {'name': 'Person', 'number': '+917068766697'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF373856),
      appBar: AppBar(
        title: const Text(
          'Services',
          //backgroundColor: Color(0xFF373856),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF404165),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact['name']!),
            subtitle: Text(contact['number']!),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://tse1.mm.bing.net/th?id=OIP.8um7Q6EtY4wdtOT-DS0q2gHaHa&pid=Api&P=0&h=180',
              ),
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              child: Text('Call'),
              onPressed: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: contact['number']);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch phone dialer')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}



// import 'package:url_launcher/url_launcher.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Phone Call'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Text('Phone Call'),
//         centerTitle: true,
//       ),
//       body:Center(child: buildButton(),) ,
//     );
//   }
//
//   Widget buildButton() {
//     const number='+917068766697';
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(horizontal: 48,vertical: 12),
//         textStyle: TextStyle(fontSize: 24),
//       ),
//       child: const Text('call'),
//       onPressed: ()async{
//         launch('tel://$number');
//       },
//     );
//   }
//
// }


// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ServicesBottom extends StatefulWidget {
//   const ServicesBottom({super.key});
//
//   @override
//   State<ServicesBottom> createState() => _ServicesBottomState();
// }
//
// class _ServicesBottomState extends State<ServicesBottom> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Services',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body:Center(child: buildButton(),) ,
//     );
//   }
//
//  Widget buildButton() {
//    const number='+917068766697';
//
//    return ListTile(
//      title: const Text('Police'),
//      subtitle: const Text(number),
//      leading: const CircleAvatar(
//        backgroundImage: NetworkImage('https://tse1.mm.bing.net/th?id=OIP.8um7Q6EtY4wdtOT-DS0q2gHaHa&pid=Api&P=0&h=180'),
//      ),
//      trailing: TextButton(
//        style: TextButton.styleFrom(
//          padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 12),
//          shape: const RoundedRectangleBorder(
//            side: BorderSide(color: Colors.blue),
//          )
//        ),
//        child: const Text('Call'),
//        onPressed: ()async {
//          launch('tel://$number');
//        },
//      ),
//
//    );
//  }
// }
//
//
//
// // import 'package:url_launcher/url_launcher.dart';
// //
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const MyHomePage(title: 'Phone Call'),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});
// //
// //
// //   final String title;
// //
// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title:const Text('Phone Call'),
// //         centerTitle: true,
// //       ),
// //       body:Center(child: buildButton(),) ,
// //     );
// //   }
// //
// //   Widget buildButton() {
// //     const number='+917068766697';
// //     return ElevatedButton(
// //       style: ElevatedButton.styleFrom(
// //         padding: EdgeInsets.symmetric(horizontal: 48,vertical: 12),
// //         textStyle: TextStyle(fontSize: 24),
// //       ),
// //       child: const Text('call'),
// //       onPressed: ()async{
// //         launch('tel://$number');
// //       },
// //     );
// //   }
// //
// // }
