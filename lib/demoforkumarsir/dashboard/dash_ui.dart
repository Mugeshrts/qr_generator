import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/bloc/daah_bloc.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/bloc/daah_event.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/bloc/daah_state.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/genqr.dart';
import 'package:qr_generator/demoforkumarsir/registerpage/scannerpage.dart';
import 'package:qr_generator/demoforkumarsir/validation/validation.dart';
import 'package:qr_generator/qrscanners/qrscanner/qrscanui.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboardData()),
      child: Scaffold(
        backgroundColor: Colors.teal,
        // appBar: AppBar(title: Text("Dashboard"), backgroundColor: Colors.teal[700]),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              // return Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (state is DashboardLoaded) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashboardCard(title: "QR Generate", icon: Icons.qr_code, onTap: () => Get.to(QRGeneratorScreen1())),
                      SizedBox(height: 20),
                      DashboardCard(title: "Register", icon: Icons.app_registration_rounded, onTap: () => Get.to(QRScannerScreen())),
                      SizedBox(height: 20),
                      DashboardCard(title: "Validation", icon: Icons.person, onTap: () =>Get.to(() => QRValidationScreen())),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text("Something went wrong", style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}

/// 📌 **Reusable Card Widget**
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.teal),
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
