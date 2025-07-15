import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

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
                    fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  'Have a project in mind? Let\'s work together!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 40 : 60),
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
                          Expanded(
                            flex: 2,
                            child: _buildContactForm(isMobile, isTablet),
                          ),
                          SizedBox(width: isTablet ? 30 : 40),
                          Expanded(
                            child: _buildSocialLinks(isMobile, isTablet),
                          ),
                        ],
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
                onTap: _submitForm,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
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
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
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
            'linkedin.com/in/johndeveloper',
            () {},
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'GitHub',
            Icons.code,
            'github.com/johndeveloper',
            () {},
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'Email',
            Icons.email,
            'john@developer.com',
            () {},
          ),
          const SizedBox(height: 20),
          _buildSocialLink(
            'Twitter',
            Icons.alternate_email,
            '@johndeveloper',
            () {},
          ),
        ],
      ),
    );
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
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  handle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }
}
