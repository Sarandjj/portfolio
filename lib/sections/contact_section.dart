import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Add this import for json.encode()

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isSubmitting = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://formspree.io/f/xgvzozra'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Success
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent successfully! 🎉'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Clear form
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        }
      } else {
        // Handle error response
        throw Exception('Failed to send message');
      }
    } catch (e) {
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to send message. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _submitForm,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
        vertical: isMobile ? 40 : (isTablet ? 60 : 80),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? size.width - 40 : (isTablet ? 800 : 1000),
            ),
            child: Column(
              children: [
                Text(
                  'Get In Touch',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: isMobile ? 28 : (isTablet ? 32 : 40),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  'Looking for a freelance Flutter developer? Let\'s build something amazing together!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 30 : 50),
                isMobile
                    ? Column(
                        children: [
                          _buildContactForm(isMobile, isTablet),
                          const SizedBox(height: 30),
                          _buildSocialLinks(isMobile, isTablet),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildContactForm(isMobile, isTablet)),
                          SizedBox(width: isTablet ? 30 : 40),
                          Expanded(child: _buildSocialLinks(isMobile, isTablet)),
                        ],
                      ),
                SizedBox(height: isMobile ? 40 : 50),
                Text(
                  'I’m Sarankumar, a freelance Flutter developer. I build custom mobile apps for startups and businesses worldwide.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(bool isMobile, bool isTablet) {
    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 25 : 30)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send Message',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 30),
            _buildTextField(
              controller: _nameController,
              label: 'Your Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _messageController,
              label: 'Message',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: InkWell(
                onTap: _isSubmitting ? null : _submitForm, // Disable when submitting
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sending...',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Send Message',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      enabled: !_isSubmitting, // Disable form fields while submitting
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSocialLinks(bool isMobile, bool isTablet) {
    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 25 : 30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect With Me',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 30),
          _buildSocialLink(
            'LinkedIn',
            Icons.business,
            'linkedin.com/in/sarankuamr-g',
            () => _launchURL('https://linkedin.com/in/sarankuamr-g'),
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'GitHub',
            Icons.code,
            'github.com/Sarandjj',
            () => _launchURL('https://github.com/Sarandjj'),
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'Email',
            Icons.email,
            'kumar2004saran@gmail.com',
            () => _launchURL('mailto:kumar2004saran@gmail.com'),
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'WhatsApp',
            Icons.message,
            '+91 93448 98571',
            () => _launchURL('https://wa.me/919344898571'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSocialLink(
    String platform,
    IconData icon,
    String handle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(handle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
