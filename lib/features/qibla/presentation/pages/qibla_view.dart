// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:islamic_app/core/static_files/app_colors.dart';
// import 'package:islamic_app/features/qibla/data/services/qibla_service.dart';
// import 'package:islamic_app/features/qibla/presentation/widgets/qibla_compass_widget.dart';
// import 'package:islamic_app/features/qibla/presentation/widgets/qibla_info_card.dart';

// /// Degrees of tolerance to consider the user facing the Qibla.
// const double _kQiblaTolerance = 5.0;

// /// Minimum heading change (°) required to trigger a setState — prevents
// /// constant repaints from tiny sensor noise while the phone is stationary.
// /// Keep small (0.5°) so the animated compass feels responsive.
// const double _kDeadzone = 0.5;

// /// Main Qibla screen – compass, Qibla bearing, device heading.
// class QiblaView extends StatefulWidget {
//   const QiblaView({super.key});

//   @override
//   State<QiblaView> createState() => _QiblaViewState();
// }

// class _QiblaViewState extends State<QiblaView> {
//   double? _qiblaBearing;
//   bool _loading = true;
//   String? _error;

//   double _deviceHeading = 0;
//   bool _isOnQibla = false;

//   StreamSubscription<CompassEvent>? _compassSub;
//   bool _toastShown =
//       false; // avoid repeated toasts in the same "aligned" window

//   @override
//   void initState() {
//     super.initState();
//     _loadQibla();
//     _startCompass();
//   }

//   @override
//   void dispose() {
//     _compassSub?.cancel();
//     super.dispose();
//   }

//   // ── Compass stream ─────────────────────────────────────────────────────────

//   void _startCompass() {
//     _compassSub = FlutterCompass.events?.listen((event) {
//       if (!mounted || event.heading == null) return;

//       final newHeading = event.heading!;

//       // Deadzone: ignore updates smaller than _kDeadzone
//       final delta = (_angularDiff(newHeading, _deviceHeading)).abs();
//       if (delta < _kDeadzone) return;

//       final aligned =
//           _qiblaBearing != null &&
//           _angularDiff(newHeading, _qiblaBearing!).abs() <= _kQiblaTolerance;

//       setState(() {
//         _deviceHeading = newHeading;
//         _isOnQibla = aligned;
//       });

//       // Show toast once per alignment window
//       if (aligned && !_toastShown) {
//         _toastShown = true;
//         _showQiblaToast();
//       } else if (!aligned) {
//         _toastShown = false;
//       }
//     });
//   }

//   /// Shortest angular difference between two bearings (signed, –180…180).
//   double _angularDiff(double a, double b) {
//     double diff = (a - b) % 360;
//     if (diff > 180) diff -= 360;
//     if (diff < -180) diff += 360;
//     return diff;
//   }

//   // ── Load Qibla bearing from GPS ───────────────────────────────────────────

//   Future<void> _loadQibla() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     final bearing = await QiblaService.getQiblaBearing();

//     if (!mounted) return;

//     if (bearing == null) {
//       setState(() {
//         _error = 'تعذّر تحديد الموقع.\nتأكد من تفعيل GPS وأذونات الموقع.';
//         _loading = false;
//       });
//     } else {
//       setState(() {
//         _qiblaBearing = bearing;
//         _loading = false;
//       });
//     }
//   }

//   // ── Toast ─────────────────────────────────────────────────────────────────

//   void _showQiblaToast() {
//     if (!mounted) return;
//     final overlay = Overlay.of(context);
//     final entry = OverlayEntry(builder: (_) => const _QiblaToast());
//     overlay.insert(entry);
//     Future.delayed(const Duration(seconds: 3), () => entry.remove());
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             const Spacer(),
//             _buildHint(),
//             const SizedBox(height: 32),
//             _buildCompassArea(),
//             const SizedBox(height: 40),
//             _buildInfoRow(),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Header ────────────────────────────────────────────────────────────────

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).maybePop(),
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1A1A),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.chevron_right,
//                 color: Colors.white,
//                 size: 22,
//               ),
//             ),
//           ),
//           const Text(
//             'اتجاه القبلة',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontFamily: 'Tajawal',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 36),
//         ],
//       ),
//     );
//   }

//   // ── Hint ──────────────────────────────────────────────────────────────────

//   Widget _buildHint() {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 400),
//       child: Text(
//         _isOnQibla
//             ? '🕌  أنت تتجه نحو القبلة'
//             : 'وجّه أعلى الجهاز نحو السهم الذهبي',
//         key: ValueKey(_isOnQibla),
//         style: TextStyle(
//           color: _isOnQibla
//               ? AppColors.primaryColor
//               : Colors.white.withValues(alpha: 0.45),
//           fontSize: 13,
//           fontFamily: 'Tajawal',
//           fontWeight: _isOnQibla ? FontWeight.w600 : FontWeight.w400,
//         ),
//       ),
//     );
//   }

//   // ── Compass ───────────────────────────────────────────────────────────────

//   Widget _buildCompassArea() {
//     if (_loading) {
//       return const SizedBox(
//         width: 280,
//         height: 280,
//         child: Center(
//           child: CircularProgressIndicator(
//             color: AppColors.primaryColor,
//             strokeWidth: 2,
//           ),
//         ),
//       );
//     }

//     if (_error != null) return _buildErrorState();

//     return QiblaCompassWidget(
//       qiblaBearing: _qiblaBearing!,
//       deviceHeading: _deviceHeading,
//       isOnQibla: _isOnQibla,
//     );
//   }

//   Widget _buildErrorState() {
//     return SizedBox(
//       width: 280,
//       height: 280,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.location_off_outlined,
//             color: Colors.white.withValues(alpha: 0.3),
//             size: 48,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _error!,
//             style: TextStyle(
//               color: Colors.white.withValues(alpha: 0.55),
//               fontSize: 14,
//               fontFamily: 'Tajawal',
//               height: 1.6,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: _loadQibla,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: AppColors.primaryColor.withValues(alpha: 0.4),
//                 ),
//               ),
//               child: const Text(
//                 'إعادة المحاولة',
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontFamily: 'Tajawal',
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Info row ──────────────────────────────────────────────────────────────

//   Widget _buildInfoRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           QiblaInfoCard(title: 'اتجاه القبلة', value: _qiblaBearing),
//           const SizedBox(width: 16),
//           QiblaInfoCard(title: 'اتجاه الجهاز', value: _deviceHeading),
//         ],
//       ),
//     );
//   }
// }

// // ── Qibla Toast Overlay ───────────────────────────────────────────────────────

// class _QiblaToast extends StatefulWidget {
//   const _QiblaToast();

//   @override
//   State<_QiblaToast> createState() => _QiblaToastState();
// }

// class _QiblaToastState extends State<_QiblaToast>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _opacity;
//   late final Animation<double> _slide;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//     _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _slide = Tween<double>(
//       begin: 30,
//       end: 0,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _ctrl.forward();

//     // Fade out before removal
//     Future.delayed(const Duration(milliseconds: 2500), () {
//       if (mounted) _ctrl.reverse();
//     });
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 120,
//       left: 0,
//       right: 0,
//       child: AnimatedBuilder(
//         animation: _ctrl,
//         builder: (_, child) => Opacity(
//           opacity: _opacity.value,
//           child: Transform.translate(
//             offset: Offset(0, _slide.value),
//             child: child,
//           ),
//         ),
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(
//                 color: AppColors.primaryColor.withValues(alpha: 0.6),
//                 width: 1.2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primaryColor.withValues(alpha: 0.25),
//                   blurRadius: 20,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.mosque_outlined,
//                   color: AppColors.primaryColor,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'أنت متجه نحو القبلة الصحيحة',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontFamily: 'Tajawal',
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
