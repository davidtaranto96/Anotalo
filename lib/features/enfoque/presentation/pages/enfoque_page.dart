import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';

class EnfoquePage extends StatelessWidget {
  const EnfoquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('Enfoque', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
            backgroundColor: AppTheme.surfaceBase,
          ),
          const SliverFillRemaining(
            child: Center(
              child: Text('Enfoque — próximamente', style: TextStyle(color: AppTheme.colorNeutral)),
            ),
          ),
        ],
      ),
    );
  }
}
