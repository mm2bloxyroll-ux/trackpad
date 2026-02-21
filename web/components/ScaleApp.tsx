"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { RotateCcw, Home, Settings, X } from "lucide-react";
import Link from "next/link";
import CartoonScale from "./CartoonScale";

type State = "welcome" | "waitingForFinger" | "waitingForItem" | "weighing" | "result";

const HISTORY = 10;
const FINGER_HOLD_MS = 3000;
const STABILITY_MS = 3000;
const STABILITY_DELAY_MS = 1000;
const STABILITY_THRESHOLD_G = 5;
const RATE_THRESHOLD_G = 12;
const DEFAULT_CAL = 500; // grams at pressure=1.0

export default function ScaleApp() {
  const [appState, setAppState] = useState<State>("welcome");
  const [displayWeight, setDisplayWeight] = useState(0);
  const [fingerProgress, setFingerProgress] = useState(0);
  const [stabilityProgress, setStabilityProgress] = useState(0);
  const [isStabilizing, setIsStabilizing] = useState(false);
  const [resultWeight, setResultWeight] = useState(0);
  const [hasTouch, setHasTouch] = useState(false);
  const [calibration, setCalibration] = useState(DEFAULT_CAL);
  const [showSettings, setShowSettings] = useState(false);

  // Mutable refs for event handlers (avoid stale closures)
  const stateRef = useRef<State>("welcome");
  const calRef = useRef(DEFAULT_CAL);
  const historyRef = useRef<number[]>([]);
  const baselineRef = useRef(0);
  const hasFingerRef = useRef(false);
  const hasItemRef = useRef(false);
  const fingerStartRef = useRef<number | null>(null);
  const fingerRafRef = useRef<number | null>(null);
  const stabilityStartRef = useRef<number | null>(null);
  const stableWeightRef = useRef(0);
  const stabilityRafRef = useRef<number | null>(null);
  const isStabilizingRef = useRef(false);

  const syncState = (s: State) => { stateRef.current = s; setAppState(s); };
  useEffect(() => { calRef.current = calibration; }, [calibration]);

  const cancelFingerRaf = useCallback(() => {
    if (fingerRafRef.current) { cancelAnimationFrame(fingerRafRef.current); fingerRafRef.current = null; }
    fingerStartRef.current = null;
    setFingerProgress(0);
  }, []);

  const cancelStabilityRaf = useCallback(() => {
    if (stabilityRafRef.current) { cancelAnimationFrame(stabilityRafRef.current); stabilityRafRef.current = null; }
    stabilityStartRef.current = null;
    stableWeightRef.current = 0;
    isStabilizingRef.current = false;
    setIsStabilizing(false);
    setStabilityProgress(0);
  }, []);

  const completeWeighing = useCallback((weight: number) => {
    setResultWeight(weight);
    syncState("result");
    cancelStabilityRaf();
  }, [cancelStabilityRaf]);

  const startStabilityAnimation = useCallback((weight: number) => {
    if (stabilityRafRef.current) cancelAnimationFrame(stabilityRafRef.current);
    isStabilizingRef.current = true;
    setIsStabilizing(true);
    const remaining = STABILITY_MS - STABILITY_DELAY_MS;
    const t0 = performance.now();
    const animate = (now: number) => {
      const progress = Math.min((now - t0) / remaining, 1);
      setStabilityProgress(progress);
      if (progress >= 1) { completeWeighing(weight); return; }
      stabilityRafRef.current = requestAnimationFrame(animate);
    };
    stabilityRafRef.current = requestAnimationFrame(animate);
  }, [completeWeighing]);

  const startFingerAnimation = useCallback(() => {
    if (fingerRafRef.current) return;
    fingerStartRef.current = performance.now();
    const animate = (now: number) => {
      const progress = Math.min((now - (fingerStartRef.current ?? now)) / FINGER_HOLD_MS, 1);
      setFingerProgress(progress);
      if (progress >= 1) {
        hasFingerRef.current = true;
        const avg = historyRef.current.length
          ? historyRef.current.reduce((a, b) => a + b, 0) / historyRef.current.length
          : 0;
        baselineRef.current = avg;
        syncState("waitingForItem");
        fingerRafRef.current = null;
        return;
      }
      fingerRafRef.current = requestAnimationFrame(animate);
    };
    fingerRafRef.current = requestAnimationFrame(animate);
  }, []);

  const processPressure = useCallback((raw: number) => {
    const weight = raw * calRef.current;
    historyRef.current.push(weight);
    if (historyRef.current.length > HISTORY) historyRef.current.shift();
    const avg = historyRef.current.reduce((a, b) => a + b, 0) / historyRef.current.length;
    setDisplayWeight(avg);

    switch (stateRef.current) {
      case "waitingForFinger":
        if (!hasFingerRef.current) startFingerAnimation();
        break;

      case "waitingForItem":
        if (historyRef.current.length === HISTORY && !hasItemRef.current) {
          const roc = historyRef.current[HISTORY - 1] - historyRef.current[0];
          if (roc > RATE_THRESHOLD_G) {
            hasItemRef.current = true;
            baselineRef.current = historyRef.current[0];
            syncState("weighing");
            cancelStabilityRaf();
          }
        }
        break;

      case "weighing": {
        const diff = stabilityStartRef.current != null ? Math.abs(avg - stableWeightRef.current) : 0;
        if (stabilityStartRef.current == null) {
          stabilityStartRef.current = performance.now();
          stableWeightRef.current = avg;
        } else if (diff > STABILITY_THRESHOLD_G) {
          cancelStabilityRaf();
          stabilityStartRef.current = performance.now();
          stableWeightRef.current = avg;
        } else {
          const elapsed = performance.now() - stabilityStartRef.current;
          if (elapsed >= STABILITY_DELAY_MS && !isStabilizingRef.current) {
            startStabilityAnimation(avg);
          }
        }
        break;
      }
      default: break;
    }
  }, [startFingerAnimation, cancelStabilityRaf, startStabilityAnimation]);

  const handleNoTouch = useCallback(() => {
    setHasTouch(false);
    historyRef.current = [];
    setDisplayWeight(0);
    if (stateRef.current === "waitingForFinger" && !hasFingerRef.current) cancelFingerRaf();
    if (stateRef.current === "weighing") cancelStabilityRaf();
  }, [cancelFingerRaf, cancelStabilityRaf]);

  const startWeighing = useCallback(() => {
    cancelFingerRaf();
    cancelStabilityRaf();
    historyRef.current = [];
    hasFingerRef.current = false;
    hasItemRef.current = false;
    baselineRef.current = 0;
    stabilityStartRef.current = null;
    stableWeightRef.current = 0;
    isStabilizingRef.current = false;
    setDisplayWeight(0);
    setFingerProgress(0);
    setStabilityProgress(0);
    setIsStabilizing(false);
    setResultWeight(0);
    setHasTouch(false);
    syncState("waitingForFinger");
  }, [cancelFingerRaf, cancelStabilityRaf]);

  const restart = useCallback(() => {
    cancelFingerRaf();
    cancelStabilityRaf();
    historyRef.current = [];
    hasFingerRef.current = false;
    hasItemRef.current = false;
    baselineRef.current = 0;
    stabilityStartRef.current = null;
    stableWeightRef.current = 0;
    isStabilizingRef.current = false;
    setDisplayWeight(0);
    setFingerProgress(0);
    setStabilityProgress(0);
    setIsStabilizing(false);
    setResultWeight(0);
    setHasTouch(false);
    syncState("welcome");
  }, [cancelFingerRaf, cancelStabilityRaf]);

  // Pointer & webkit force event listeners
  useEffect(() => {
    const onMove = (e: PointerEvent) => {
      const s = stateRef.current;
      if (s === "welcome" || s === "result") return;
      if (e.pressure > 0.01 && e.pressure !== 0.5) {
        setHasTouch(true);
        processPressure(e.pressure);
      } else {
        handleNoTouch();
      }
    };
    const onUp = () => { if (stateRef.current !== "welcome" && stateRef.current !== "result") handleNoTouch(); };
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const onForce = (e: any) => {
      const s = stateRef.current;
      if (s === "welcome" || s === "result") return;
      const force = e.webkitForce ?? 0;
      if (force > 0.01) { setHasTouch(true); processPressure(force); }
    };
    window.addEventListener("pointermove", onMove);
    window.addEventListener("pointerup", onUp);
    window.addEventListener("webkitmouseforcechanged", onForce as EventListener);
    return () => {
      window.removeEventListener("pointermove", onMove);
      window.removeEventListener("pointerup", onUp);
      window.removeEventListener("webkitmouseforcechanged", onForce as EventListener);
    };
  }, [processPressure, handleNoTouch]);

  // Instruction text per state
  const instruction = {
    welcome: "",
    waitingForFinger: "Rest a finger gently on your trackpad and hold still…",
    waitingForItem: "Finger detected! Now place your object on the trackpad.",
    weighing: "Measuring — hold still…",
    result: "",
  }[appState];

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white flex flex-col select-none">
      {/* Top bar */}
      <div className="flex items-center justify-between px-6 py-4">
        <Link href="/" className="flex items-center gap-1.5 text-gray-400 hover:text-gray-700 transition-colors text-sm">
          <Home className="w-4 h-4" />
          <span>Home</span>
        </Link>
        <h1 className="font-bold text-gray-900 text-lg bg-gradient-to-r from-blue-600 to-teal-500 bg-clip-text text-transparent">
          TrackWeight
        </h1>
        <button
          onClick={() => setShowSettings(true)}
          className="flex items-center gap-1.5 text-gray-400 hover:text-gray-700 transition-colors text-sm"
        >
          <Settings className="w-4 h-4" />
          <span>Settings</span>
        </button>
      </div>

      {/* Main */}
      <div className="flex-1 flex flex-col items-center justify-center gap-8 px-6 pb-12">
        {appState === "welcome" ? (
          <WelcomeScreen onBegin={startWeighing} />
        ) : appState === "result" ? (
          <ResultScreen weight={resultWeight} onRestart={restart} />
        ) : (
          <>
            {/* Scale */}
            <CartoonScale
              weight={displayWeight}
              hasTouch={hasTouch}
              isWeighing={appState === "weighing"}
            />

            {/* Progress indicators */}
            {appState === "waitingForFinger" && fingerProgress > 0 && (
              <ProgressRing progress={fingerProgress} label="Hold still…" color="#3b82f6" />
            )}
            {isStabilizing && (
              <ProgressRing progress={stabilityProgress} label="Stabilising…" color="#14b8a6" />
            )}

            {/* Instruction */}
            <p className="text-center text-gray-500 text-sm max-w-xs">{instruction}</p>

            {/* Zero button */}
            {appState === "waitingForItem" && (
              <button
                onClick={() => { baselineRef.current = historyRef.current[0] ?? 0; }}
                className="flex items-center gap-2 bg-gradient-to-r from-blue-600 to-teal-500 text-white text-sm font-semibold px-6 py-2.5 rounded-full shadow-md hover:opacity-90 transition-opacity"
              >
                <RotateCcw className="w-4 h-4" />
                Zero Scale
              </button>
            )}

            {/* Restart */}
            <button onClick={restart} className="text-xs text-gray-400 hover:text-gray-600 transition-colors underline underline-offset-2 mt-2">
              Restart
            </button>
          </>
        )}
      </div>

      {/* Settings Modal */}
      {showSettings && (
        <SettingsModal
          calibration={calibration}
          onChange={setCalibration}
          onClose={() => setShowSettings(false)}
        />
      )}
    </div>
  );
}

function WelcomeScreen({ onBegin }: { onBegin: () => void }) {
  return (
    <div className="text-center max-w-sm">
      <div className="text-7xl mb-6">⚖️</div>
      <h2 className="text-2xl font-bold text-gray-900 mb-3">Ready to Weigh?</h2>
      <p className="text-gray-500 text-sm mb-3 leading-relaxed">
        This uses your trackpad's Force Touch pressure sensors via{" "}
        <code className="bg-gray-100 px-1 rounded text-xs">PointerEvent.pressure</code>.
      </p>
      <p className="text-amber-600 text-xs bg-amber-50 border border-amber-200 rounded-xl px-4 py-3 mb-8">
        Works best in <strong>Safari on macOS</strong> with a Force Touch trackpad.
        Chrome may return limited pressure data.
      </p>
      <div className="space-y-3 text-left text-sm text-gray-600 bg-white rounded-2xl p-5 border border-gray-100 shadow-sm mb-8">
        <Step n={1} text="Click Begin, then rest a finger lightly on your trackpad" />
        <Step n={2} text="Hold still for 3 seconds to set the zero baseline" />
        <Step n={3} text="Place your object on the trackpad while keeping finger contact" />
        <Step n={4} text="Hold steady — the scale locks the reading automatically" />
      </div>
      <button
        onClick={onBegin}
        className="bg-gradient-to-r from-blue-600 to-teal-500 text-white font-semibold px-10 py-3.5 rounded-full shadow-lg shadow-blue-200 hover:opacity-90 transition-opacity"
      >
        Begin →
      </button>
    </div>
  );
}

function Step({ n, text }: { n: number; text: string }) {
  return (
    <div className="flex items-start gap-3">
      <span className="w-5 h-5 rounded-full bg-gradient-to-br from-blue-500 to-teal-400 text-white text-[10px] font-bold flex items-center justify-center shrink-0 mt-0.5">
        {n}
      </span>
      <span>{text}</span>
    </div>
  );
}

function ResultScreen({ weight, onRestart }: { weight: number; onRestart: () => void }) {
  return (
    <div className="text-center">
      <div className="text-5xl mb-4">🎉</div>
      <p className="text-gray-400 text-sm mb-2 uppercase tracking-widest font-semibold">Result</p>
      <p className="text-7xl font-bold text-gray-900 mb-1">{weight.toFixed(1)}</p>
      <p className="text-2xl text-gray-400 mb-10">grams</p>
      <button
        onClick={onRestart}
        className="flex items-center gap-2 mx-auto bg-gradient-to-r from-blue-600 to-teal-500 text-white font-semibold px-8 py-3 rounded-full shadow-lg hover:opacity-90 transition-opacity"
      >
        <RotateCcw className="w-4 h-4" />
        Weigh Again
      </button>
    </div>
  );
}

function ProgressRing({ progress, label, color }: { progress: number; label: string; color: string }) {
  const r = 36;
  const circ = 2 * Math.PI * r;
  const offset = circ * (1 - progress);
  return (
    <div className="flex flex-col items-center gap-2">
      <svg width="88" height="88" viewBox="0 0 88 88">
        <circle cx="44" cy="44" r={r} fill="none" stroke="#e5e7eb" strokeWidth="6" />
        <circle
          cx="44" cy="44" r={r} fill="none"
          stroke={color} strokeWidth="6"
          strokeDasharray={circ} strokeDashoffset={offset}
          strokeLinecap="round"
          transform="rotate(-90 44 44)"
          style={{ transition: "stroke-dashoffset 0.1s linear" }}
        />
        <text x="44" y="49" textAnchor="middle" fill={color} fontSize="13" fontWeight="bold" fontFamily="monospace">
          {Math.round(progress * 100)}%
        </text>
      </svg>
      <p className="text-xs text-gray-400">{label}</p>
    </div>
  );
}

function SettingsModal({
  calibration, onChange, onClose,
}: { calibration: number; onChange: (v: number) => void; onClose: () => void }) {
  return (
    <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6">
        <div className="flex items-center justify-between mb-6">
          <h2 className="font-bold text-gray-900 text-lg">Settings</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-700 transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="space-y-5">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">
              Calibration Factor
            </label>
            <p className="text-xs text-gray-400 mb-3">
              Grams at maximum trackpad pressure (pressure = 1.0). Adjust based on your MacBook model.
            </p>
            <div className="flex items-center gap-3">
              <input
                type="range" min={100} max={1500} step={10}
                value={calibration}
                onChange={(e) => onChange(Number(e.target.value))}
                className="flex-1 accent-teal-500"
              />
              <span className="text-sm font-mono text-gray-900 w-16 text-right">{calibration} g</span>
            </div>
          </div>

          <div className="bg-blue-50 rounded-xl p-4 text-xs text-blue-700 leading-relaxed">
            <strong>Tip:</strong> Place a known object (e.g. a 100 g weight) and adjust the calibration
            until the reading matches. Default 500 g is a good starting point for most MacBook Force
            Touch trackpads.
          </div>
        </div>

        <button
          onClick={onClose}
          className="mt-6 w-full bg-gray-900 text-white font-semibold py-3 rounded-xl hover:bg-gray-800 transition-colors"
        >
          Done
        </button>
      </div>
    </div>
  );
}
