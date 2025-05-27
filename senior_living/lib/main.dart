import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:senior_living/repository.dart';
import 'package:senior_living/model.dart'; // Add this import for Blog class
import 'screens/opening_screen.dart';
import 'package:senior_living/screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/success_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/health/health_record_screen.dart';
import 'screens/health/health_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'models/schedule_item.dart';
import 'models/health_record.dart';

const String healthRecordsBoxName = 'health_records';
const String schedulesBoxName = 'schedules'; // Added constant

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ScheduleItemAdapter());
  Hive.registerAdapter(HealthRecordAdapter());

  // Open boxes
  await Hive.openBox<ScheduleItem>(schedulesBoxName);
  await Hive.openBox<HealthRecord>(healthRecordsBoxName);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Blog> listblog = [];
  Repository repository = Repository();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await repository.getdata();
    if (data != null) {
      setState(() {
        listblog = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senior Living',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID'), Locale('en', '')],
      locale: const Locale('id', 'ID'),
      initialRoute: '/opening',
      routes: {
        '/opening': (context) => const OpeningScreen(),
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/success': (context) => const SuccessScreen(),
        '/home_page': (context) {
          // Use the same route handling as '/home' but with updated route name
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return HomePage(
            userName: arguments?['name'] ?? 'Pengguna',
            userAge: arguments?['age'] ?? 0,
            healthStatus: arguments?['status'] ?? 'Tidak Diketahui',
          );
        },
        '/home': (context) {
          // Keep this for backward compatibility
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return HomePage(
            userName: arguments?['name'] ?? 'Pengguna',
            userAge: arguments?['age'] ?? 0,
            healthStatus: arguments?['status'] ?? 'Tidak Diketahui',
          );
        },
        '/schedule': (context) => const ScheduleScreen(),
        '/health': (context) => const HealthScreen(),
        '/history': (context) => const HistoryScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error Navigasi')),
            body: Center(
              child: Text('Halaman tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}
