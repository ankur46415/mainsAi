import '../../../app_imports.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool isSuccess;
  final Map<String, dynamic> paymentData;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    required this.paymentData,
  });

  @override
  Widget build(BuildContext context) {
    final orderId = paymentData['orderId']?.toString() ?? 'N/A';
    final amount = paymentData['amount']?.toString() ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Animation (Success / Failed)
                SizedBox(
                  height: 160,
                  child: Lottie.asset(
                    isSuccess
                        ? 'assets/lottie/Done.json'
                        : 'assets/lottie/not_done.json',
                    fit: BoxFit.contain,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(const [
                          '**',
                        ], value: isSuccess ? Colors.green : Colors.red),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Title
                Text(
                  isSuccess ? "Payment Successful" : "Payment Failed",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Order ID: $orderId",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 40),

                // ✅ Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess ? Colors.green : Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
