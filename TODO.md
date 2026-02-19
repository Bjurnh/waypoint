# Phase 1: Design System Foundation - TODO List

## Tasks:
- [x] 1. Create lib/utils/spacing.dart (NEW)
       - Spacing constants (xs, sm, md, lg, xl, 2xl, 3xl)
       - Border radius constants (sm, md, lg, xl, 2xl, 3xl)
       - Shadow/elevation definitions
       - Gap spacing utilities

- [x] 2. Enhance lib/theme/app_theme.dart (MODIFY)
       - Add full typography scale (displayLarge through labelSmall)
       - Add shadow/elevation system
       - Add dark theme (darkTheme)
       - Export/use spacing from spacing.dart

- [x] 3. Modify lib/main.dart (MODIFY)
       - Import app_theme.dart
       - Apply lightTheme and darkTheme to MaterialApp
