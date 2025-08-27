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
      backgroundColor: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 80,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                isSuccess ? "Payment Successful" : "Payment Failed",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Order ID: $orderId",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Amount: ₹$amount",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // You can also use pushNamed to go to a home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
