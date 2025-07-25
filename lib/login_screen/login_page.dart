import 'package:flutter/material.dart';

import 'package:example_code/products_page/views/mobile/products_page/product_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53), Color(0xFFFFB347)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw8PDQ0NDw8NDQ0NDQ4NDQ0NDQ8NDQ0NFREWFhURFRUYHSggGBolGxUVITEhJSkuLjAuFx8zODUtNygtLjcBCgoKDg0OFxAQGi0dHR0rLSsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLy0tLf/AABEIALcBEwMBEQACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAABAAIDBAUGB//EAEcQAAIBAgIECQkFBgMJAAAAAAABAgMRBCEFEjFRBhNBUmFxkaGxFCIjMnKBksHRM0JzgrIkNFOiwuFio/EHFRYlQ4OTs9L/xAAbAQEBAAIDAQAAAAAAAAAAAAAAAQIDBAUGB//EADYRAQABAgIGBwcEAwEBAAAAAAABAhEDIQQFEjFRcTJhgaGxwdEVIjNBUpHwExQ04SNTckIk/9oADAMBAAIRAxEAPwDeR6F54hckAhUJFSwMjYqIRCM1yNiolgGxBLDNUsVEsQSwzXIWALFEMc1yDQBYoCAaGa5KtFFSKjJmZKtEVRgQKGiZijKAioM1VaAqB0ja0IAgQBAQhAbANgIENgGwEsBLASwEsAWALBRYAIqAVaCgCrAGFVIoZBVhVWQAFWFVYAFRhVQOkZtKFRCCyFi5KiAIsXILkIQEWW6FRAISxdBYuhRCCCy3DQRVhQyWW4YFWFZYUFqqVSWpF+qlHXqTW9RusultdFzXNWdqc2cU5XqyWVCnPKnN672QqwUNZ7lJSav12JtVU51Rl1MtmmcqZz62CGHlK+yKi7SlN6kYvdny9CzMpriGNNEyt5I36kqdVr7sHLX90ZJN+65jNcfOJhlsT8piWszKzC6jCqgRkst1WBUoCMgLDoo2tBsAhJIEARcIQgQpYgIRAGxRAJYCEEAAqEuBoCrQUNEVkw9NNuUleEFrSWzWzso+92913yGFdVotG+WdFN5vO6GKrNyk5S2v3LoSXIugyppimLQk1TM3kUqWtJK9lm5PbqxSu32Eqq2YutNO1Nmxj6nGKFRXS86m4t3tJZ6z6WmrvlaZqwo2Zmmef5ybMSraiKo5fnNo5rNXTWaayaZu3tbNivOUavLO6nbZxqtd+9NPrbNdGUzTw3cv6Z15xFXHfz/tq2M2CrRFAFWgqrRABUKroGxoKFkuQEBARZEKEBQsXJUQBIECFEIIC6FAAEst0JYDAqwrLPKlBcs5Sm/Zj5se/XNcZ1z1ef5Dbe1Edfl+S1mZtbKsqUny1JKH5Y2lLvcOw1znXEcM/L1bYyomeOXn6CjnTrR3KFVdcZavhN9gryqpns+5RnTVHb9muzYwZaOdOrHco1F1xdn3TfYa68qqZ7Pu2U501R2/ZrMyYBiyqkFWBVksqoVCjomxpkhCBBcsQhKpFxAiyKiECLrYoIQhJdbIUARBdQLrYMqAioyXWyrAyYvbCPNpU12x133yZro+c9c+nk2YnyjhEevm12Z3YMlf1aS/wOT63J59iia6c6qp7O7+22rKmmO3v/oYP15LfSrL/Kk13pDE6PbHiYfSt1T4Nc2NbLhPXa306se2nK3fY1Yk+79vFtw+lbn4NZmxgGQDRLslWBVgVIJYK6BtaSEIEASoUVSEKCEBQCiBCECAQCAQAChlFQIRVWBlx32tTcpyiupOy8DXhdCG3F6c/m5rMza2TF+vbmxpx96gk+9GvD3X4zPi24m+3CI8Ewf2n5Kv/qkTF6M9niuF0o7fBrGxrZcH9rDrfgzXi9CW3B6cNc2SwVMQMKqQVYFWFAV0TY0kZpkQEBAS5iIIUEIzXIhCghCkGSBCFQmZkCoABjNlkeLe7vRbSw26RxUt3ehY26WXC0W6tNWydSCea5yMMSJimZ6meHVTNcR1w14J1Iqos1USmne11JXv3liiYiIKsSmZlHh5bl2ouzLHbpXxFGUqk5K1pTk1nyN5GFFFUUxDZXi0zVMwrCDgqlSXqwpVG7ZvOLiu+SMcSmbRzjxZYVdMzPVE+DG8NLo7TZsy1/qUrUKEoy1nbJS5eVxaXfYxrw5qpmGeHi001RMtPGWow15tKN1HK7zZZplIrpnJp/7yo85/CzG0s7wvRxMJtqLu1m8mgRLKRVWM1VZBUo6BsalkEkgICghKIgEqEBAUwhILWJeOK2lBeC0oUQIhbFxYCrCtimsl1GbirWF1syYfKpTbaSU45vrv8u41Y0+5VyluwKf8lM8JjxamBpONGlF5OFOMGtzirPvRsiqJi8MKqZiZiWbVLdLJqi5ZixcG6UorN1J0YWXN42MpN9Fod5rrm9VPPyluwotTXPV5wu4my7VYNEWzjcKcsN/3IfMlW5lR0nk1I1t13U0HK8qnsx8SStO91jFmGBVhVQOgZ2a7lFRYIRYuUAhCLLclsl0KhFh7yilqQ9mPgfOMWqdurnL19Ee7HJkbyfUaplnDyXCRelh+Ev1SN2DuWve47RvYjVdm+Rbe/wCj7DKmiqq9ovZjMxG9imYMmvUbJeS0Nd61tbPVva/Tl9V2mynb2Zqi9oYTs3sxub3vtZdurjJsxwelovzI+yvA95hx7lPKHia59+rnPivcymIgiZnKFdb7zvqpZK2dt9t73dS3kiLZs9/uxuMW7Z7W23bZdu78SxFosxmq83Ny2Li4sbUjWFi6Nkst1WyWW7i8Kn+zr8WPgyTuZU73k7mLY6ugJefU9iPiY1QyonOXZbMbNtwwKkFbiyt82NJQutiLpMFFRZC5Yi5YlQgQXgsWWEl72n6sepeB81r6U83sKd0I5LMxsyeV4R/aU/w/6mb8GMlrnNyGbmIp1GqlNcjlaS5HdNfNm3R65jFpj5TlLDEiNiZ4MFRWbXJd26jHFo2a6qeErTVeIlgqmlkphFrOVN+rKE8tzvFp9qRytCvXXOHO6Ylqxso2vnDQUnsZptNmV3qKb82PUvA+gYfRjlDw9fSnnK7jddbzW9LO3h3id7Km8R1zl6i9/ZX8z39X+u4b5us5RaO30Ny3Y2lLlBcAuS8MrSLi4GyK4vCr93j+LHwkSZZU73lLMwvDY6nB77Sp7C8SVMsPfLuGDaGiXWyrAqUb5m1IUKAsgFBCEWQCUQqIB72GxdSPmlW+Xso3FvIxWHluEf2lP2H4m/A3SV73HN7Bhqu06b3TXiSibYtM9cLVF6ZgYlec+s5OmRbGq/Pk1YM3ohrVTiNyuj5Wqv2JeKOTq74/ZPk06R8NqYXA1cRiY0KMXOpNuy5Ix5ZSfIlvJsTVXNMcZSZtES+waH0LSw8I3UalVJa1WUb57o32I9Bi6TXiZXtHB1mBomHhZ2vPH0cLhplLCxlJSq1J13JRuo+TRWSa5bSlT28rfIcnV0TNU8PNxtZ2jDjjfucG527pEuRRcgLhRcKLiVDZiricLH+zx/Fj+mRJZRveUTIydbg4/SVPYX6jGtswt8u8a24MKoBAN0yYEqFAKGZkQiyKhQFkEQqIUe7Te4+aTZ7It5GKvMcI/Xp+w/E5GBukr3uQb2DDiY3iaq4ZwKmavvzObpdW3NNfGmHHwYtE08JalbYcNuZtCYGpiKzp0lrTcOXKMVrK8m+RHK1daMaZ6vOGrSOhEdb2+EwlHRtNUqetKvKrh3iK2onKrF1IpwitqXnZLp23udzouiRETPG/3zddpGkWtHXHjDtV9L0qeH8om3GF3FRylKc02tWNm1JtrkMowapr2IzllOLTFG3OUPDY/GTxFaVeotVyioQpp3VKkm2o35Xdtt/RHd6Pgfo02+fzef0rSf16r7ojcwXOQ4ouBLmObKLBsLkrcAuSWUBsxzZZOHwrfoIfix/TILDywHY4OW42p+H/AFI113bsK15d5mDeqwAigDcNjUUAgJUKAUEWAsghKIVHuz5m9mjIrzPCL1qXsy8UcjB3Sle9xzcwEldMxqhYli+73Gyar0RHC/54pbOZ4tKuzTLJ6r/Z3jFDyiElGMZzpJVNknUd0oN7tlumXSc/V/8A77Pz84uPj/J6nhFi6FHDyqV5uEIzpSWrbjJzhUU4wjvbcfE7P9aMGJrnhPfFnErwv1LU9cT9pifJ4vSGkKmJqcbVeauqdNO8KUXyLe98uXoVkeh0fR6cKnLfxeb0rS6serhEboa9ze4ouBLkVmwUFKrCMldO91s5Gzh6xxa8LRsTEom0xGX3hzNBw6cXSKKK4vE+kuq8DSz8zYm3nJ5JX2LNnj6NbadXVFMYmc9Uej086s0SmLzR3z6qeRUn9y3Q9ZNPc09hni6z07Cq2asTuj0KNXaJVF4o759Q8DS5vfL6mv2xpv8As7o9GXszRfo759VXgaXN75fUntfTPr7o9D2Zov0d8+rXxeiMPVjapT1oxetZOo3e3Iou7eew2Yes9NxKopprznqj0SrV+i0ReaO+fVq/8M4L+Avjq/Ules9Noqmma846o9Fp1fotUXijx9XKxOjqNDESVKGonBfelLdvZ2eqtNx9IxKoxKrxEcI49ThadouFg0xOHFryGd461VgDCqhW8ZtSXIG4QlCmBa4shTKiyAsLIUPkfN7m581jc9mq+sDzfCL1qXVLxRvwd0sa3Gub2CaxFYZVNVtNXjLuLExG/cS0K0o8raXRG77P7mExTff+fnWXljx+mkqCw9KLp01LXk271Kk+c2tmxZLcjbOL7mxTFo75a5jO8ufpLT1fFzjKvUdR04asL5RiuV2XK+VmWJiVVx7zXTaJyerTyPoMQ8Pc3AlwsSlyWW7Y0a/TU+uX6Wddrb+Fi8vOHP1Z/Lw+c+EvQ4d+kh7S8TwujxfFo5w9lidGeTm1qjjjq8L+bUUaq6JaqTORptNsars8GGDN6IbLOG2hhWbAfax6Nb9LOTocXx6fz5NWN0JcmNXUxWIo/d4yU4rdd3fiTSIti181w592HK0x+8v8NfI7XUXxa+Xm6/Wfw6efk02z0rpQ2LKq2FVuBvmbSCqQhQCBZMqEhZZFQoIvDautEqn3ZWmM4e3ufN3skewg81wj20uqfyN+D80rcZm9rVbAxTJKtWvTujAcjE4S98iwwmGrHDWNm9hZ7OLPorwcLXIouFFwrZ0a/TU+uX6Wdbrf+Fi8vOHP1Z/Lw+c+EvQUZefH2l4nhcDLFo5x4vZ19GeTmaW83HUpck6bj703/Y52saf8kTxjwadHn3W6da5KrYRmwD9Iup+BzNAj/PHb4NWP0JcLGP8A5lVXQu+MWTS/j19nhBhfDhoaY/eX+GvkdlqP4tfLzcHWfw6efk02eldMGyijZFFwOgZ2akKiBTclgplQhFkwpuEWTKi9L1o+0vEwxOhPKVo6Uc3tj5y9ij2ElYec4R/9L8/yN+D82FbiNnIYKtgY5MxkYKjMValQQjVlHM2U72E7npEfRXgYNyWhbyLixcXCtnRr9NT/ADfpZ1ut/wCFi8o8Ydhqv+Xh858Jd5O2e53PBRVMTE8HtZi+TQ07nKjPlhUt7n/odvrCImimqPy8OJo+UzDbWxHTuWGW4z6PV5voi33o5urovjdktGkdDtcCT19I4iW5qPYkvka9Km+NXPX5RDLCyohoaaf7S/YXgjs9R/Fq/wCfOHB1n8Onn5NNs9K6ZVsqq3JJAuRXRNrTckuIEQqlELFC5YmTEpkFkxcsyUX58Paj4mGLP+OrlPgyoj36ecPa3PnT16N9YsrzvCN/Zfn/AKTfgxvYVuG2b2CrYGORJGCqYSrWmIRhaz2o20R70NdW6XoLPc+w+iXeCinIZhQS5EILsrNjRj9PT/N+lnW63/hYvKPGHP1X/Lw+3wl3meBe2amPjrRXb2HZ7f6middP54OLbZxebYg8kdZLkowrb0fJQhia0vVpUr/mbyXcdhoExTNdc7oj88HH0iLxFLy+hc6lWo83KTu+na/E4lWd5n5tscGlpx/tP5V4Hcaj+LV/z5w67WXw6eflLSbPSunDYutlWyCtwOqbWmyAsgLABuA3CFMBuVCmBsYJa1Wkt9SPZc4+l17GBiVcKZ8G3Ap2sWiOuHsFI+fvWMkFfbsMJlXB0/Tyhf7spLtX9jkYMsanFdNbjewUcFuAxygtxJGKcFuRgrXlFbkVFKcE5xVlnKK2dJyNGp2sainjVHi049WzhV1cInweniz3cvHwtcjJLhUCsmG9de/wZ1utv4mJ2eMObq/+TR2+EtuTPDvVMVRXXejbhYk0TPCd7GqnaEJWedu0xqp4TdYnitOrFZylGK3tkilbuXpjTcZ0/JqF3Fu85cs5b30dBvmv3dinKPFq+d53nRNDUgr7Xm+s1SzhxeEM7YqPTZf5bfyO51H8Wv8A584ddrLoU8/KWk5HpnUWUcgDWIJrCw7Jm1AohAXGZklyolwHWJmWOuUsmsEs39Cq+Ih0a0v5X9TrtbV7OiV9do73M0Cm+PT1XnuespxbPEzMPSM6Ncq5PCGHo9bpi/fs+ZuwZzY1bnnGzlMFGwMciDHIxVgkETCK9WHtX7MzsNW07WlYcdd/tEy4WsKtnRq56rfebPQI9m8vBuTNlklwG4VkwudSK6/BnW62y0PE7PGHO1f/ACaO3wlvOl09x4e8PU2VdHp7hcsx1MMmrPYWKizQqaFpt3MttjsslHRkI7EuwTWuy2VSsY3WzxvC2ajiabfJUgu2nJHe6j+LX/z5w6zWXQp5+UudLFR3npbS6i8KPFR3ixeFfLI7xaS8K+WQ3i0m1D1FjNpumqC51AXPFAunEhLp5OQunkzFjaTyVixtJ5I95F2m3oqXEVHUa1/McUr22tO/ccDWGiV6ThRRTNs759rlaJpNODXtVRfKztR07Hlpz9zi/Gx0U6h0j5VU9/o7ONa4PCe71ZI6epcsKq/LD/6NVWo9KjhPazjWeBPH7MOkdK0alGcFr6zXmpweb6zCnVGmU1X2O+PVn7Q0eY6XdPo885Pmy7jkxqzSvp749Wv9/gfV3Sq3Lmy/l+pnGqtJ4R909oYHHuUetzX2x+pl7H0jq+/9MfaOD1/b+1JQnzV8X9h7Fx+NP3n0T2nhcJ7vVjdCe6PxP6GcakxfnVHexnWeH9Mr4SnKE1KSTSvlF3d/fY5+g6tnR8WMSqq9on5OHpmmRjYWxTFs4dFYxc2f8v1O6vDqtiT5bHmz7I/UXhdmU8tjul8IvBsynlsP8XwSJeFtLa0biYSqxSbvaW2Ml9170dXrmf8A46+zxhz9WxP7mnt8JddniXqFbgDYFWwKtgVZR8/4fN8Y7ck6ezk9GzvdRZY8zxpnxh1etPhRzjwl5JOXOfaesvDoLlQfOfaLwl1lRe/vJtQtjxD3942oNmX0hRMVXUSZF2RRDGZXVMtxdQCXWVMF1lSKi3FELpxQtC3TiS2QcSAcSSy3DpCxdXiwlxxYstw6ZLLtB0y2LquALjUJZbyq4CxcahS41CWW41SbK3SLcXdNxe+LafcYV4VGJTs1xeOtlTiVUTembSt5RU/iVP8AyS+px/2Gjf66ftDb+7xvrn7jyip/EqfHIns/Rv8AXH2X93jfXKeU1P4k/jkT2fo30R9l/eY31SPKanPn8TJ7O0b6IX95jfVIeJqc+fxMeztG+iF/eY/1SjxVTnz7SezdG+iD97j/AFS0cVg6dWevUiqknbObb2KxvwtHw8KLURZqxMavE6c3Y1o6itlKn8KNtmF11gqf8On8ERsrdPJYcyHwxFi58nhzY/Ci2S7opGTXZZFsi8QjImQsumVismUXUgWKmCya5RNcFhxhLwtlXMqBzAq5Euthri5ZVzBYOQuWV1iXWyrkUGsCwciXhdlVyFywchcGsS62VbJeFsGy3LC5JksLi8LYOQuWFwIS62FxcsNYpYXJdbJcXLP/2Q==',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.shopping_bag_outlined, size: 35, color: Colors.white);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Cartify', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                      SizedBox(height: 4),
                      Text(
                        'Your Cartify Companion',
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: Offset(0, -5))],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Welcome Text
                              Text(
                                'Welcome Back!',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Sign in to continue cartify',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 24),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 2))],
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    hintText: 'Enter your email',
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF6B35).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(Icons.email_outlined, color: Color(0xFFFF6B35), size: 18),
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 2))],
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  validator: _validatePassword,
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF6B35).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(Icons.lock_outline, color: Color(0xFFFF6B35), size: 18),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)]),
                                  boxShadow: [BoxShadow(color: Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6))],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child:
                                      _isLoading
                                          ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                          )
                                          : Text(
                                            'Sign In',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                                          ),
                                ),
                              ),

                              SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account? ", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 4)),
                                    child: Text('Sign Up', style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold, fontSize: 14)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
