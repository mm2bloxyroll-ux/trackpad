import Link from "next/link";
import {
  Scale,
  Hand,
  Download,
  Github,
  ChevronRight,
  AlertTriangle,
  Cpu,
  Layers,
  Activity,
  Terminal,
} from "lucide-react";

export default function Home() {
  return (
    <div className="min-h-screen bg-white">
      {/* Navbar */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-100">
        <div className="max-w-6xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-500 to-teal-400 flex items-center justify-center">
              <Scale className="w-4 h-4 text-white" />
            </div>
            <span className="font-bold text-gray-900 text-lg">TrackWeight</span>
          </div>
          <div className="flex items-center gap-4">
            <a
              href="https://github.com/krishkrosh/TrackWeight"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1.5 text-sm text-gray-600 hover:text-gray-900 transition-colors"
            >
              <Github className="w-4 h-4" />
              <span className="hidden sm:inline">GitHub</span>
            </a>
            <Link
              href="/scale"
              className="flex items-center gap-1.5 bg-gradient-to-r from-blue-500 to-teal-400 text-white text-sm font-medium px-4 py-2 rounded-full hover:opacity-90 transition-opacity"
            >
              Try in Browser
              <ChevronRight className="w-3.5 h-3.5" />
            </Link>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="pt-32 pb-24 px-6 text-center relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-blue-50/60 to-white pointer-events-none" />
        <div className="relative max-w-3xl mx-auto">
          {/* Animated scale illustration */}
          <div className="scale-float mb-10 flex justify-center">
            <ScaleIllustration />
          </div>

          <h1 className="text-5xl sm:text-6xl font-bold tracking-tight mb-6">
            <span className="bg-gradient-to-r from-blue-600 via-teal-500 to-cyan-500 bg-clip-text text-transparent">
              TrackWeight
            </span>
          </h1>
          <p className="text-xl text-gray-600 mb-4 max-w-xl mx-auto leading-relaxed">
            Turn your MacBook's Force Touch trackpad into a{" "}
            <strong className="text-gray-900">precision digital scale</strong>{" "}
            with gram-level accuracy.
          </p>
          <p className="text-sm text-gray-400 mb-10">
            macOS 13+ · MacBook Pro 2015+ · Force Touch required
          </p>

          <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
            <Link
              href="/scale"
              className="flex items-center gap-2 bg-gradient-to-r from-blue-600 to-teal-500 text-white font-semibold px-7 py-3.5 rounded-full shadow-lg shadow-blue-200 hover:opacity-90 transition-opacity"
            >
              Try in Browser
              <ChevronRight className="w-4 h-4" />
            </Link>
            <a
              href="https://github.com/krishkrosh/TrackWeight/releases"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-2 bg-gray-900 text-white font-semibold px-7 py-3.5 rounded-full hover:bg-gray-800 transition-colors"
            >
              <Download className="w-4 h-4" />
              Download App
            </a>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-20 px-6 bg-gray-50">
        <div className="max-w-5xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-4">
            How It Works
          </h2>
          <p className="text-gray-500 text-center mb-14 max-w-xl mx-auto">
            Leverages Apple's private MultitouchSupport framework to read
            raw Force Touch pressure values — already calibrated in grams.
          </p>

          <div className="grid sm:grid-cols-3 gap-8">
            {steps.map((step, i) => (
              <div key={i} className="text-center">
                <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-500 to-teal-400 flex items-center justify-center mx-auto mb-4 shadow-md shadow-blue-100">
                  <step.Icon className="w-6 h-6 text-white" />
                </div>
                <div className="text-xs font-bold text-blue-500 uppercase tracking-widest mb-1">
                  Step {i + 1}
                </div>
                <h3 className="font-semibold text-gray-900 mb-2">{step.title}</h3>
                <p className="text-sm text-gray-500 leading-relaxed">{step.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Tech */}
      <section className="py-20 px-6">
        <div className="max-w-5xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-14">
            Built With
          </h2>
          <div className="grid sm:grid-cols-3 gap-6">
            {tech.map((t, i) => (
              <div
                key={i}
                className="p-6 rounded-2xl border border-gray-100 hover:border-blue-100 hover:shadow-md transition-all"
              >
                <div className="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center mb-4">
                  <t.Icon className="w-5 h-5 text-blue-600" />
                </div>
                <h3 className="font-semibold text-gray-900 mb-1">{t.title}</h3>
                <p className="text-sm text-gray-500">{t.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Limitations */}
      <section className="py-20 px-6 bg-amber-50">
        <div className="max-w-2xl mx-auto">
          <div className="flex items-center justify-center gap-2 mb-6">
            <AlertTriangle className="w-5 h-5 text-amber-500" />
            <h2 className="text-2xl font-bold text-gray-900">Limitations</h2>
          </div>
          <div className="space-y-3">
            {limitations.map((l, i) => (
              <div
                key={i}
                className="flex items-start gap-3 bg-white rounded-xl px-5 py-4 border border-amber-100"
              >
                <l.Icon className="w-4 h-4 text-amber-500 mt-0.5 shrink-0" />
                <p className="text-sm text-gray-700">{l.text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Install */}
      <section className="py-20 px-6">
        <div className="max-w-2xl mx-auto text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Get Started</h2>
          <p className="text-gray-500 mb-10">Install the native macOS app for full accuracy.</p>

          <div className="grid sm:grid-cols-2 gap-4 mb-8">
            <a
              href="https://github.com/krishkrosh/TrackWeight/releases"
              target="_blank"
              rel="noopener noreferrer"
              className="flex flex-col items-center gap-2 p-6 rounded-2xl border-2 border-gray-900 hover:bg-gray-900 hover:text-white transition-colors group"
            >
              <Download className="w-6 h-6" />
              <span className="font-semibold">Download DMG</span>
              <span className="text-xs text-gray-400 group-hover:text-gray-300">
                Recommended
              </span>
            </a>
            <div className="p-6 rounded-2xl bg-gray-950 text-left">
              <div className="flex items-center gap-2 mb-3">
                <Terminal className="w-4 h-4 text-teal-400" />
                <span className="text-xs text-gray-400 font-mono">Homebrew</span>
              </div>
              <code className="text-xs text-teal-300 font-mono leading-relaxed">
                brew install --cask{" "}
                <br className="sm:hidden" />
                krishkrosh/apps/trackweight
              </code>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
            <a
              href="https://github.com/krishkrosh/TrackWeight"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900 transition-colors"
            >
              <Github className="w-4 h-4" />
              View on GitHub
            </a>
            <span className="text-gray-300 hidden sm:inline">·</span>
            <span className="text-sm text-gray-400">MIT License · macOS 13+</span>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 border-t border-gray-100 text-center text-sm text-gray-400">
        <p>
          TrackWeight is for experimental use only. Not a calibrated measurement instrument.
        </p>
        <p className="mt-1">
          Built by{" "}
          <a
            href="https://github.com/krishkrosh"
            className="text-blue-500 hover:underline"
            target="_blank"
            rel="noopener noreferrer"
          >
            Krish Shah
          </a>{" "}
          · MIT License
        </p>
      </footer>
    </div>
  );
}

function ScaleIllustration() {
  return (
    <svg width="200" height="160" viewBox="0 0 200 160" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Platform */}
      <rect x="60" y="20" width="80" height="12" rx="6" fill="url(#platformGrad)" />
      {/* Body */}
      <rect x="50" y="32" width="100" height="90" rx="16" fill="url(#bodyGrad)" />
      {/* Screen bg */}
      <rect x="65" y="44" width="70" height="44" rx="8" fill="#0f172a" />
      {/* Screen glow */}
      <rect x="67" y="46" width="66" height="40" rx="7" fill="url(#screenGrad)" opacity="0.9" />
      {/* Weight text */}
      <text x="100" y="69" textAnchor="middle" fill="white" fontFamily="monospace" fontWeight="bold" fontSize="18">0.0</text>
      <text x="100" y="82" textAnchor="middle" fill="rgba(255,255,255,0.7)" fontFamily="sans-serif" fontSize="9">grams</text>
      {/* Status dot */}
      <circle cx="127" cy="48" r="4" fill="#14b8a6" />
      {/* Face eyes */}
      <circle cx="88" cy="108" r="4" fill="#1e293b" />
      <circle cx="112" cy="108" r="4" fill="#1e293b" />
      {/* Mouth */}
      <rect x="94" y="120" width="12" height="2" rx="1" fill="#1e293b" />
      {/* Legs */}
      <rect x="68" y="122" width="10" height="20" rx="4" fill="#94a3b8" />
      <rect x="122" y="122" width="10" height="20" rx="4" fill="#94a3b8" />

      <defs>
        <linearGradient id="platformGrad" x1="60" y1="20" x2="140" y2="32" gradientUnits="userSpaceOnUse">
          <stop stopColor="#cbd5e1" />
          <stop offset="1" stopColor="#94a3b8" />
        </linearGradient>
        <linearGradient id="bodyGrad" x1="50" y1="32" x2="150" y2="122" gradientUnits="userSpaceOnUse">
          <stop stopColor="#f1f5f9" />
          <stop offset="1" stopColor="#e2e8f0" />
        </linearGradient>
        <linearGradient id="screenGrad" x1="67" y1="46" x2="133" y2="86" gradientUnits="userSpaceOnUse">
          <stop stopColor="#14b8a6" stopOpacity="0.8" />
          <stop offset="1" stopColor="#3b82f6" stopOpacity="0.6" />
        </linearGradient>
      </defs>
    </svg>
  );
}

const steps = [
  {
    Icon: Hand,
    title: "Place Your Finger",
    desc: "Rest a finger on the trackpad to activate the pressure sensors and establish a zero baseline.",
  },
  {
    Icon: Scale,
    title: "Place Your Object",
    desc: "While keeping finger contact, gently place the object you want to weigh on the trackpad.",
  },
  {
    Icon: Activity,
    title: "Read the Weight",
    desc: "The app detects the pressure spike, stabilises the reading and displays the weight in grams.",
  },
];

const tech = [
  {
    Icon: Layers,
    title: "SwiftUI + Combine",
    desc: "Reactive UI with smooth animations driven by Combine publishers.",
  },
  {
    Icon: Cpu,
    title: "MultitouchSupport",
    desc: "Apple's private framework via OpenMultitouchSupport for raw Force Touch pressure data.",
  },
  {
    Icon: Activity,
    title: "Moving Average",
    desc: "10-sample rolling average and stability detection (±2 g over 3 s) for accurate readings.",
  },
];

const limitations = [
  {
    Icon: Hand,
    text: "Finger contact is required at all times — the trackpad only sends pressure events when capacitance is detected.",
  },
  {
    Icon: Activity,
    text: "Pressure drift can occur immediately after placing an object; the app compensates with stability detection.",
  },
  {
    Icon: AlertTriangle,
    text: "Metal or magnetic objects may be detected as a second finger. Use paper or cloth as a barrier.",
  },
];
