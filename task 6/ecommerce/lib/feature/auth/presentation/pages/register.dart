import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/network/network_info.dart';
import '../../data/datasource/local_data_source.dart';
import '../../data/datasource/remote_data_source.dart';
import '../../data/repositories/register_repo.dart';
import '../../domain/usecases/register_usecase.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/register_bloc/register_state.dart';
import '../bloc/register_bloc/register_event.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RegisterBloc>(
      future: _createRegisterBloc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        return BlocProvider<RegisterBloc>(
          create: (context) => snapshot.data!,
          child: _buildUI(),
        );
      },
    );
  }

  Future<RegisterBloc> _createRegisterBloc() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final connectivity = Connectivity();
      final httpClient = http.Client();

      final networkInfo = NetworkInfoImpl(connectivityChecker: connectivity);

      final localDataSource = LocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      final remoteDataSource = RemoteDataSourceImpl(client: httpClient);

      final registerRepository = RegisterRepo(
        localDataSource: localDataSource,
        remoteDatasource: remoteDataSource,
        networkInfo: networkInfo,
      );

      final registerUsecase = RegisterUsecase(repository: registerRepository);

      return RegisterBloc(registerUsecase: registerUsecase);
    } catch (e) {
      throw Exception('Failed to initialize RegisterBloc: $e');
    }
  }

  Widget _buildUI() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
        ),
        actions: [
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  "ECOM",
                  style: TextStyle(
                    color: Color.fromARGB(255, 15, 83, 201),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.greenAccent,
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
          if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            bool isPasswordVisible = false;
            bool isConfirmPasswordVisible = false;
            bool isTermsAccepted = false;
            bool isLoading = state is RegisterLoading;

            if (state is RegisterFormState) {
              isPasswordVisible = state.isPasswordVisible;
              isConfirmPasswordVisible = state.isConfirmPasswordVisible;
              isTermsAccepted = state.isTermsAccepted;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Create Your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.length <= 5) {
                                  return "Name must have atleast have 5 charachters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "ex: yubi",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email adress.";
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "ex: yubi@gmail.com",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter password.";
                                }
                                if (value.length < 8) {
                                  return "Password must be at least 8 characters long.";
                                }
                                if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
                                ).hasMatch(value)) {
                                  return "Password must contain uppercase, lowercase, number and special character.";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
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
                                  onPressed: () {
                                    context.read<RegisterBloc>().add(
                                      TogglePasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              "Confirm Password",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: !isConfirmPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != _passwordController.text) {
                                  return "Password don't match";
                                }
                                return null;
                              },
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<RegisterBloc>().add(
                                      ToggleConfirmPasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  side: const BorderSide(
                                    width: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  value: isTermsAccepted,
                                  onChanged: (bool? value) {
                                    context.read<RegisterBloc>().add(
                                      ToggleTermsAcceptance(),
                                    );
                                  },
                                  activeColor: Colors.blueAccent,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<RegisterBloc>().add(
                                        ToggleTermsAcceptance(),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 1.0),
                                      child: Text(
                                        "I understood the terms and policy",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    isTermsAccepted && !isLoading
                                        ? () => _handleRegister(context)
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
                                        )
                                        : const Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),

                            const SizedBox(height: 100),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text(
                                      "Login IN",
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
            );
          },
        ),
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          name: _nameController.text,
          confirmPassword: _confirmPasswordController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}