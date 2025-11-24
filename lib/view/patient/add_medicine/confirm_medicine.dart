import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/upload_prescription/save_scan_prescription_provider.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';
import 'package:provider/provider.dart';

class ConfirmMedicine extends StatefulWidget {
  final List<MedicineData>? medicines;

  const ConfirmMedicine({super.key, this.medicines});

  @override
  State<ConfirmMedicine> createState() => _ConfirmMedicineState();
}

class _ConfirmMedicineState extends State<ConfirmMedicine> {
  Future<void> _saveMedicines() async {
    if (widget.medicines == null || widget.medicines!.isEmpty) {
      CustomSnackBar.showError(context, 'No medicines to save');
      return;
    }

    final provider = Provider.of<SaveScanPrescriptionProvider>(
      context,
      listen: false,
    );
    bool success = await provider.saveScanPrescription(widget.medicines!);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(context, 'Medicines saved successfully');
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(
        context,
        provider.errorMessage ?? 'Failed to save medicines',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppSpacing.h14,
              Text('Confirm Medicine', style: FontManager.connect),
              AppSpacing.h24,
              Expanded(
                child: widget.medicines != null && widget.medicines!.isNotEmpty
                    ? ListView.separated(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                        itemCount: widget.medicines!.length,
                        separatorBuilder: (context, index) => AppSpacing.h14,
                        itemBuilder: (context, index) {
                          final medicine = widget.medicines![index];
                          return MedicineCart(
                            num: '${index + 1}.',
                            medicineName: medicine.name,
                            mg: medicine.dosage,
                            time: medicine.frequency,
                            days: '${medicine.durationDays} days',
                            color: AppColors.white,
                            index: index % 4,
                            times: medicine.times,
                          );
                        },
                      )
                    : const Center(child: Text('No medicines to display')),
              ),
              AppSpacing.h14,
              Consumer<SaveScanPrescriptionProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: 'Save Medicine',
                          onTap: _saveMedicines,
                        );
                },
              ),
              AppSpacing.h38,
            ],
          ),
        ),
      ),
    );
  }
}
