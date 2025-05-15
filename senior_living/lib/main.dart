import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:senior_living/repository.dart';
import 'package:senior_living/model.dart'; // Add this import for Blog class
import 'screens/opening_screen.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/success_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/health/health_record_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'models/schedule_item.dart';
import 'models/health_record.dart';

const String healthRecordsBoxName = 'health_records';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ScheduleItemAdapter());
  Hive.registerAdapter(HealthRecordAdapter());

  // Open boxes
  await Hive.openBox<ScheduleItem>('schedules');
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
    setState(() {});
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
      ),
      home: Scaffold(
        body: ListView.separated(
          itemBuilder: (context, index) {
            return Container(child: Text(listblog[index].title));
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: listblog.length,
        ),
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
        '/home': (context) {
          final arguments =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final String name = arguments?['name'] ?? 'Pengguna';
          final int age = arguments?['age'] ?? 0;
          final String status = arguments?['status'] ?? 'Tidak Diketahui';
          return HomePage(userName: name, userAge: age, healthStatus: status);
        },
        '/schedule': (context) => const ScheduleScreen(),
        '/health': (context) => const HealthRecordScreen(),
        '/history': (context) => const HistoryScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
