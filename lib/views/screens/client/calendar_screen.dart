import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/providers/booking_provider.dart';
import 'package:book_my_look/view_models/booking_view_model.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/services/user_service.dart';
import 'package:book_my_look/helpers/reward_helper.dart';
import 'package:book_my_look/views/widgets/booking/booking_summary.dart';
import 'package:book_my_look/views/widgets/booking/calendar_widget.dart';
import 'package:book_my_look/views/widgets/booking/time_slot_grid.dart';
import 'package:book_my_look/views/widgets/booking/payment_selector.dart';
import 'package:book_my_look/views/widgets/booking/voucher_selector.dart';
import 'package:book_my_look/views/widgets/booking/booking_success_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _selectedTime;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    Future.microtask(() => _fetchSlots());
  }

  void _fetchSlots() {
    if (!mounted) return;

    final bookingProv = context.read<BookingProvider>();
    final bookingVM = context.read<BookingViewModel>();
    final selectedService = bookingProv.selectedService;

    if (selectedService != null && bookingProv.selectedBarberId != null) {
      bookingVM.fetchAvailableSlots(
        barberId: bookingProv.selectedBarberId!,
        selectedDate: _selectedDay!,
        serviceDuration: selectedService.duration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = context.watch<BookingViewModel>();
    final bookingProv = context.watch<BookingProvider>();
    final userProv = context.watch<UserProvider>();

    final ServiceModel? service = bookingProv.selectedService;
    final UserModel? barber = bookingProv.selectedBarber;
    final UserVoucherModel? selectedVoucher = bookingProv.selectedVoucher;

    if (service == null || barber == null || userProv.user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: Text("Eroare: Selecție incompletă", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final double finalPrice = selectedVoucher != null
        ? RewardHelper.calculateFinalPrice(
            type: selectedVoucher.rewardType,
            originalPrice: service.price,
            rewardValue: selectedVoucher.rewardValue,
          )
        : service.price;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPrimaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Finalizare Rezervare",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookingSummary(
              serviceName: service.name,
              barberName: barber.name,
              price: finalPrice,
            ),
            CalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedTime = null;
                });
                _fetchSlots();
              },
            ),
            
            FutureBuilder<List<UserVoucherModel>>(
              future: UserService().getUserVouchers(userProv.user!.uid),
              builder: (context, snapshot) {
                final vouchers = snapshot.data?.where((v) => !v.isUsed).toList() ?? [];
                return VoucherSelector(
                  vouchers: vouchers,
                  selectedServiceId: service.id,
                  selectedVoucher: selectedVoucher,
                  onVoucherSelected: (v) => bookingProv.selectVoucher(v),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "ORE DISPONIBILE",
              style: TextStyle(
                color: kPrimaryGold,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            bookingVM.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: CircularProgressIndicator(color: kPrimaryGold)),
                  )
                : TimeSlotGrid(
                    slots: bookingVM.availableSlots,
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) => setState(() => _selectedTime = time),
                  ),
            PaymentSelector(
              selectedPaymentMethod: _selectedPaymentMethod,
              onPaymentMethodChanged: (method) => setState(() => _selectedPaymentMethod = method),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_selectedTime != null && !bookingVM.isLoading)
                      ? kPrimaryGold
                      : Colors.white10,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (_selectedTime == null || bookingVM.isLoading)
                    ? null
                    : () => _handleConfirmBooking(bookingVM, bookingProv, service, barber, userProv.user!),
                child: bookingVM.isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "Confirmă rezervarea",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirmBooking(
    BookingViewModel vm,
    BookingProvider prov,
    ServiceModel service,
    UserModel barber,
    UserModel user,
  ) async {
    final booking = BookingModel(
      id: '',
      clientId: user.uid,
      clientName: user.name,
      clientPhone: user.phone,
      serviceId: service.id,
      serviceName: service.name,
      duration: service.duration,
      priceAtBooking: service.price,
      barberId: barber.uid,
      barberName: barber.name,
      scheduledAt: _selectedTime!,
      paymentMethod: _selectedPaymentMethod,
      isPaid: _selectedPaymentMethod == PaymentMethod.card,
      earnedPoints: 0,
    );

    bool success;
    if (prov.selectedVoucher != null) {
      success = await vm.confirmBookingWithVoucher(
        booking: booking,
        voucher: prov.selectedVoucher!,
      );
    } else {
      success = await vm.confirmBooking(booking);
    }

    if (success && mounted) {
      // ✅ REMOVED: Punctele NU se adaugă la confirmare - doar la scanare NFC!
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const BookingSuccessDialog(),
      );
      
      if (!mounted) return;
      prov.resetBooking();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/client_tab_screen',
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? "Eroare la salvare"),
          backgroundColor: const Color(0xFFC70404),
        ),
      );
    }
  }
}