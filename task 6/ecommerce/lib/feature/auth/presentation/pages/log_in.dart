import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/network/network_info.dart';
import '../../data/datasource/local_data_source.dart';
import '../../data/datasource/remote_data_source.dart';
import '../../data/repositories/login_repo.dart';
import '../../domain/usecases/login_usecase.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginBloc>(
      future: _createLoginBloc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocProvider<LoginBloc>(
          create: (context) => snapshot.data!,
          child: _buildSigninUI(),
        );
      },
    );
  }

  Future<LoginBloc> _createLoginBloc() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final connectivity = Connectivity();
      final httpClient = http.Client();
      final networkInfo = NetworkInfoImpl(connectivityChecker: connectivity);
      final localDatasource = LocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      final remoteDatasource = RemoteDataSourceImpl(client: httpClient);
      final loginRepository = LoginRepo(
        localDatasource: localDatasource,
        remoteDatasource: remoteDatasource,
        networkInfo: networkInfo,
      );

      final loginUsecase = LoginUsecase(repository: loginRepository);

      return LoginBloc(loginUsecase: loginUsecase);
    } catch (e) {
      throw Exception('Failed to initialize signin functionality: $e');
    }
  }

  Widget _buildSigninUI() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }

        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          bool isPasswordVisible = false;
          bool isLoading = state is LoginLoading;

          if (state is LoginFormState) {
            isPasswordVisible = state.isPasswordVisible;
          }

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "ECOM",
                            style: TextStyle(
                              color: Color.fromARGB(255, 15, 83, 201),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      "Log into Your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Section
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              enabled: !isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "ex: yubin@gmail.com",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Password Section
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !isLoading,
                              obscureText: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed:
                                      !isLoading
                                          ? () {
                                            context.read<LoginBloc>().add(
                                              TogglePasswordVisibility(),
                                            );
                                          }
                                          : null,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Log In Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    !isLoading
                                        ? () => _handleLogIn(context)
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                        : const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),

                            const SizedBox(height: 30),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        !isLoading
                                            ? () {
                                              Navigator.pushNamed(
                                                context,
                                                '/register',
                                              );
                                            }
                                            : null,
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLogIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}