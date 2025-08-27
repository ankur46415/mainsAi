import 'package:mains/app_imports.dart';
import '../../../common/decider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Get.offAll(() => const Decider());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To',
                style: GoogleFonts.poppins(
                  fontSize: isSmallDevice ? 18 : 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 1.1,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: isSmallDevice ? 20 : 30),

              // Logo 
              Image.asset(
                'assets/images/mains-logo.png',
                width: isSmallDevice ? size.width * 0.3 : size.width * 0.25,
                filterQuality: FilterQuality.high,
              ),

              SizedBox(height: isSmallDevice ? 10 : 15),

              // App name
              Text(
                'Mains',
                style: GoogleFonts.poppins(
                  fontSize: isSmallDevice ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: isSmallDevice ? 30 : 50),

              // Tagline
              Text(
                'Books That Think, Talk and Teach',
                style: GoogleFonts.poppins(
                  fontSize: isSmallDevice ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 1.05,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
