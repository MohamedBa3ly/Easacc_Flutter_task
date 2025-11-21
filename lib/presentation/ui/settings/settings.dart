import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/logout/logout.dart';
import '../../../data/repository/task_repository_impl.dart';
import '../../../navigation/screens.dart';
import '../../manager/cubits/settings_cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(repository: TaskRepositoryImpl())..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            urlController.text = state.url;

            return Scaffold(
              appBar: AppBar(
                title: Center(child: const Text("Settings",style: TextStyle(color: Colors.white70, fontSize: 28))),
                backgroundColor: const Color(0xFF203A43),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: LogoutButton(),
                  ),
                ],
              ),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight, // Take at least full screen height
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Center(
                                //   child: const Text(
                                //     "Settings",
                                //     style: TextStyle(
                                //       fontSize: 28,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: 20),

                                // Website URL
                                const Text("Website URL", style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: urlController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white12,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Enter website URL',
                                    hintStyle: const TextStyle(color: Colors.white54),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => context.read<SettingsCubit>().saveUrl(urlController.text),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Center(child: Text("Save URL")),
                                ),
                                const SizedBox(height: 50),

                                // WiFi printers
                                const Text("Available WiFi printers", style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: state.selectedWifi,
                                  hint: const Text(
                                    "Select WiFi Printer",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  dropdownColor: Colors.blueGrey,
                                  items: state.wifiDevices
                                      .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: const TextStyle(color: Colors.white)),
                                  ))
                                      .toList(),
                                  onChanged: (val) => context.read<SettingsCubit>().selectWifi(val),
                                ),
                                const SizedBox(height: 20),

                                // Bluetooth printers
                                const Text("Available Bluetooth printers", style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: state.selectedBluetooth,
                                  hint: const Text(
                                    "Select Bluetooth Printer",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  dropdownColor: Colors.blueGrey,
                                  items: state.bluetoothDevices
                                      .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: const TextStyle(color: Colors.white)),
                                  ))
                                      .toList(),
                                  onChanged: (val) => context.read<SettingsCubit>().selectBluetooth(val),
                                ),
                                const SizedBox(height: 40),

                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).push(InitialScreens.webview);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: const Text("Open WebView"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );

          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        },
      ),
    );
  }
}
