# Escriba

escriba.tlatoani.net

A web application to learn to write using 2-in-1 tablets and stylus input:
practice handwriting in foreign alphabets on a notepad lying on a wooden desk.
It is a Flutter web PWA (installable, offline-capable via Flutter's service
worker) using the [Flame](https://flame-engine.org) engine for the writing
canvas.

Status: UI shell only. The desk, notepad and sticky-note menu are in place;
exercises, stroke capture and lessons are placeholders.

## Run it locally

```bash
flutter pub get
flutter run -d web-server --web-port 8080   # then open http://localhost:8080
```

Checks: `flutter analyze`, `flutter test`, `flutter build web --release`.

## Code layout

```
lib/
  main.dart            entry point
  app/                 app root, theme, sections (menu entries)
  notepad/             UI shell: wood desk, notepad (paper, rules, spiral), sticky notes, pages
  ink/                 writing canvas (Flame) — stroke capture placeholder
  lessons/             lesson / alphabet models (placeholder data)
```

### Why Flame only for the canvas

The writing surface will become a real-time scene (live ink with pressure,
guide glyphs, stroke-order animation, feedback effects), which suits Flame's
game loop and component tree. The chrome around it (desk, notepad, sticky
notes) is static layout, so it stays plain Flutter widgets with
`CustomPainter`s: simpler, responsive, and accessible (the notes are semantic
buttons). Everything is painted procedurally; there are no image assets.

## Deploy

Cloudflare Workers (static assets, free tier) through Workers Builds connected
to this repository: production deploys from `main`, built with
`npm run build` (which fetches a pinned Flutter SDK) and deployed with
`npx wrangler deploy`. Nothing deploys until the repository is connected in
the Cloudflare dashboard; see [docs/deploy-cloudflare.md](docs/deploy-cloudflare.md).

## License

GPL-3.0, see [LICENSE](LICENSE).
