import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons/primary_button.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(AppSizing.paddingLarge),
              child: Row(
                children: [
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppTheme.neutralGray900,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.flash_on_outlined),
                    tooltip: 'Toggle Flash',
                  ),
                ],
              ),
            ),

            // Scanner Area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Scanner Frame
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppTheme.neutralGray100,
                        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                        border: Border.all(
                          color: AppTheme.primaryTeal,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Corner decorations
                          Positioned(
                            top: 0,
                            left: 0,
                            child: _buildCorner(true, true),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _buildCorner(true, false),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: _buildCorner(false, true),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: _buildCorner(false, false),
                          ),
                          // Center icon
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 80,
                                  color: AppTheme.neutralGray400,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Position QR code here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.neutralGray600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Instructions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        'Scan the QR code on your water filter to register it or check service status.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.neutralGray600,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Open Camera Button
                    PrimaryButton(
                      text: 'Open Camera',
                      icon: Icons.camera_alt,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Camera functionality will be available once integrated with mobile_scanner'),
                            backgroundColor: AppTheme.primaryTeal,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Manual Entry
                    TextButton.icon(
                      onPressed: () {
                        _showManualEntryDialog(context);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Enter code manually'),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Info
            Container(
              padding: const EdgeInsets.all(AppSizing.paddingLarge),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: AppSizing.paddingMedium),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register Your Filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                        Text(
                          'Get service reminders and warranty coverage',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.neutralGray600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppTheme.primaryTeal, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppTheme.primaryTeal, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppTheme.primaryTeal, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppTheme.primaryTeal, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Enter Filter Code',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., WF-12345-ABC',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Submit',
            size: ButtonSize.small,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code submitted: ${controller.text}'),
                  backgroundColor: AppTheme.primaryTeal,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
