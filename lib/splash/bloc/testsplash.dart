import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/home/home.dart';
import 'package:qr_generator/splash/bloc/splash_bloc.dart';
import 'package:qr_generator/splash/bloc/splash_state.dart';

class SplashUi extends StatelessWidget {
  const SplashUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashStarted()),
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is LocationGranted || state is CameraGranted) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(), // Change to your main page
                  ),
                );
              });
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "QR Code App",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
                  /// *State Handling UI*
                  if (state is SplashLoading)
                    Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Checking permissions...",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ],
                    ),

                  if (state is LocationDenied || state is CameraDenied)
                    Column(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 40),
                        SizedBox(height: 10),
                        Text(
                          state is LocationDenied ? state.msg : (state as CameraDenied).msg,
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<SplashBloc>(context).add(SplashStarted());
                          },
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),

                  if (state is LocationPermanentlyDenied || state is CameraPermanentlyDenied)
                    Column(
                      children: [
                        Icon(Icons.settings, color: Colors.orange, size: 40),
                        SizedBox(height: 10),
                        Text(
                          state is LocationPermanentlyDenied ? state.msg : (state as CameraPermanentlyDenied).msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                           BlocProvider.of<SplashBloc>(context).add(SplashStarted());
                          },
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),

                  if (state is LocationGranted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.check_circle, color: Colors.white, size: 24),
                        // SizedBox(width: 8),
                        // Text(
                        //   "Location Permission Granted",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),

                  if (state is CameraGranted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.check_circle, color: Colors.white, size: 24),
                        // SizedBox(width: 8),
                        // Text(
                        //   "Camera Permission Granted",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



