# TODO

## Status Bar / SafeArea spacing fixes (HomeScreen)
- [ ] Update `lib/screens/home_screen.dart` to use correct SafeArea handling and remove duplicate top padding.
- [ ] Remove fixed `topInset + 16` ListView padding that can push content too far down.
- [ ] Ensure AppBar spacing doesn’t consume extra height (avoid empty AppBar + extendBodyBehindAppBar unless required).
- [ ] Set a per-screen `SystemUiOverlayStyle` so status bar icons remain readable across light/dark backgrounds.
- [ ] Keep consistent layout with notches/punch-hole devices by relying on `MediaQuery.padding` only once.


