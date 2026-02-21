# TrackWeight Web

A Next.js website version of TrackWeight — includes a marketing landing page and an interactive browser-based scale that uses the [`PointerEvent.pressure`](https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pressure) API to read Force Touch pressure from a MacBook trackpad.

## Pages

| Route | Description |
|-------|-------------|
| `/` | Landing page — hero, how it works, tech stack, download links |
| `/scale` | Interactive scale app with full weighing state machine |

## Getting Started

```bash
cd web
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Browser Compatibility

| Browser | Pressure Support |
|---------|-----------------|
| Safari (macOS) | ✅ Full Force Touch via `webkitmouseforcechanged` + `PointerEvent.pressure` |
| Chrome (macOS) | ⚠️ Limited — trackpad pressure not reliably exposed |
| Firefox | ❌ No Force Touch support |

For the best experience, use **Safari on macOS** with a MacBook that has a Force Touch trackpad.

## How the Scale Works

The web version mirrors the native app's state machine:

```
welcome → waitingForFinger → waitingForItem → weighing → result
```

1. **waitingForFinger** — listens for sustained pointer pressure for 3 s to set a zero baseline
2. **waitingForItem** — detects a rate-of-change spike (object placed on trackpad)
3. **weighing** — applies a 10-sample moving average; locks result when weight is stable (±5 g) for 3 s
4. **result** — displays the final weight in grams

Pressure values (0–1) are multiplied by a user-adjustable **calibration factor** (default 500 g). Use the Settings panel to tune this for your specific MacBook model.

## Tech Stack

- **Next.js 14** (App Router)
- **TailwindCSS**
- **Lucide React** icons
- **PointerEvent API** + **WebKit Force Touch events**

## Limitations

- Requires a MacBook with a **Force Touch trackpad** (2015 MacBook Pro or newer)
- The native macOS app is significantly more accurate — it uses Apple's private `MultitouchSupport` framework which returns pressure values already calibrated in grams
- The web version is an approximation and requires manual calibration
