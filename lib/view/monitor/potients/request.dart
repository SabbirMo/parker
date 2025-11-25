import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patients_list_provider.dart';
import 'package:provider/provider.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientsListProvider>(
        context,
        listen: false,
      ).fetchPatientsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientsListProvider = Provider.of<PatientsListProvider>(context);
    return Scaffold(
      body: patientsListProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : patientsListProvider.errorMessage != null
          ? Center(child: Text(patientsListProvider.errorMessage!))
          : patientsListProvider.patients.isEmpty
          ? Center(child: Text('No patients found'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: patientsListProvider.patients.map((patient) {
                    Color? statusColor;
                    Color? textColor;

                    if (patient.status.toLowerCase() == 'accepted' ||
                        patient.status.toLowerCase() == 'connected') {
                      statusColor = AppColors.greenOpca;
                      textColor = AppColors.greenOp;
                    } else if (patient.status.toLowerCase() == 'pending') {
                      statusColor = AppColors.yellow;
                      textColor = AppColors.yellow2;
                    } else if (patient.status.toLowerCase() == 'declined') {
                      statusColor = AppColors.redOpacity;
                      textColor = AppColors.textRed;
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: RequestCard(
                        title: patient.fullName,
                        subtitle: patient.email,
                        status: patient.status,
                        color: statusColor,
                        textColor: textColor,
                        requestId: patient.requestId,
                        onAccept: patient.status.toLowerCase() == 'pending'
                            ? () async {
                                await patientsListProvider.respondToRequest(
                                  patient.requestId,
                                  'accept',
                                );
                              }
                            : null,
                        onDecline: patient.status.toLowerCase() == 'pending'
                            ? () async {
                                await patientsListProvider.respondToRequest(
                                  patient.requestId,
                                  'decline',
                                );
                              }
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

class RequestCard extends StatefulWidget {
  const RequestCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.status,
    this.color,
    this.textColor,
    required this.requestId,
    this.onAccept,
    this.onDecline,
  });

  final String title;
  final String subtitle;
  final String? status;
  final Color? color;
  final Color? textColor;
  final int requestId;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isAccepting = false;
  bool isDeclining = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: FontManager.loginStyle.copyWith(color: AppColors.black1),
          ),
          Text(
            widget.subtitle,
            style: FontManager.subtitle.copyWith(
              color: AppColors.black1,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onAccept != null && widget.onDecline != null) ...[
                GestureDetector(
                  onTap: isDeclining || isAccepting
                      ? null
                      : () async {
                          setState(() => isDeclining = true);
                          widget.onDecline?.call();
                          await Future.delayed(Duration(milliseconds: 500));
                          if (mounted) setState(() => isDeclining = false);
                        },
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.redOpacity,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Center(
                      child: isDeclining
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textRed,
                              ),
                            )
                          : Text(
                              'Decline',
                              style: FontManager.bodyText.copyWith(
                                color: AppColors.textRed,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: isAccepting || isDeclining
                      ? null
                      : () async {
                          setState(() => isAccepting = true);
                          widget.onAccept?.call();
                          await Future.delayed(Duration(milliseconds: 500));
                          if (mounted) setState(() => isAccepting = false);
                        },
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.greenOpca,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Center(
                      child: isAccepting
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.greenOp,
                              ),
                            )
                          : Text(
                              'Accept',
                              style: FontManager.bodyText.copyWith(
                                color: AppColors.greenOp,
                              ),
                            ),
                    ),
                  ),
                ),
              ] else if (widget.status != null)
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.redOpacity,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: Text(
                      widget.status?.toLowerCase() == 'accepted' ||
                              widget.status?.toLowerCase() == 'connected'
                          ? 'Connected'
                          : widget.status?.toLowerCase() == 'pending'
                          ? 'Pending'
                          : widget.status?.toLowerCase() == 'rejected' ||
                                widget.status?.toLowerCase() == 'declined'
                          ? 'Declined'
                          : widget.status ?? '',
                      style: FontManager.bodyText.copyWith(
                        color: widget.textColor ?? AppColors.textRed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
