"use client";

interface Props {
  weight: number;
  hasTouch: boolean;
  isWeighing: boolean;
}

export default function CartoonScale({ weight, hasTouch, isWeighing }: Props) {
  const compression = Math.min(weight / 500, 0.2);
  const platformOffset = compression * 15;
  const legOffset = compression * 3;
  const happy = hasTouch && weight > 5;

  return (
    <div className="flex flex-col items-center" style={{ transition: "all 0.3s ease" }}>
      <svg
        width="260"
        height="220"
        viewBox="0 0 260 220"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        style={{ overflow: "visible" }}
      >
        {/* Platform (top tray) */}
        <rect
          x="55"
          y={18 + platformOffset}
          width="150"
          height="14"
          rx="7"
          fill="url(#platGrad)"
          style={{ transition: "y 0.3s cubic-bezier(0.34,1.56,0.64,1)" }}
        />

        {/* Body */}
        <rect
          x="40"
          y="32"
          width="180"
          height="130"
          rx="20"
          fill="url(#bodyGrad)"
          style={{
            filter: "drop-shadow(0 8px 16px rgba(0,0,0,0.12))",
          }}
        />

        {/* Screen background */}
        <rect x="60" y="48" width="140" height="64" rx="10" fill="#0f172a" />

        {/* Screen glow overlay */}
        <rect
          x="63"
          y="51"
          width="134"
          height="58"
          rx="8"
          fill="url(#screenGrad)"
          style={{
            filter: isWeighing ? "drop-shadow(0 0 8px rgba(20,184,166,0.7))" : "none",
            transition: "filter 0.5s ease",
          }}
        />

        {/* Weight value */}
        <text
          x="130"
          y="85"
          textAnchor="middle"
          fill="white"
          fontFamily="ui-monospace, monospace"
          fontWeight="bold"
          fontSize="26"
          style={{ transition: "all 0.1s ease" }}
        >
          {weight.toFixed(1)}
        </text>

        {/* Unit */}
        <text
          x="130"
          y="102"
          textAnchor="middle"
          fill="rgba(255,255,255,0.65)"
          fontFamily="system-ui, sans-serif"
          fontSize="11"
          fontWeight="500"
        >
          grams
        </text>

        {/* Status dot */}
        {hasTouch && (
          <circle cx="190" cy="54" r="5" fill="#14b8a6">
            <animate attributeName="opacity" values="1;0.4;1" dur="1.5s" repeatCount="indefinite" />
          </circle>
        )}

        {/* Face – eyes */}
        <circle cx="110" cy="143" r="5" fill="#1e293b" />
        <circle cx="150" cy="143" r="5" fill="#1e293b" />

        {/* Face – mouth */}
        {happy ? (
          <path
            d="M 117 157 Q 130 170 143 157"
            stroke="#1e293b"
            strokeWidth="2.5"
            strokeLinecap="round"
            fill="none"
          />
        ) : (
          <rect x="122" y="158" width="16" height="2.5" rx="1.25" fill="#1e293b" />
        )}

        {/* Legs */}
        <rect
          x="72"
          y={162 + legOffset}
          width="14"
          height="28"
          rx="5"
          fill="#94a3b8"
          style={{ transition: "y 0.3s ease" }}
        />
        <rect
          x="174"
          y={162 + legOffset}
          width="14"
          height="28"
          rx="5"
          fill="#94a3b8"
          style={{ transition: "y 0.3s ease" }}
        />

        <defs>
          <linearGradient id="platGrad" x1="55" y1="18" x2="205" y2="32" gradientUnits="userSpaceOnUse">
            <stop stopColor="#cbd5e1" />
            <stop offset="1" stopColor="#94a3b8" />
          </linearGradient>
          <linearGradient id="bodyGrad" x1="40" y1="32" x2="220" y2="162" gradientUnits="userSpaceOnUse">
            <stop stopColor="#f1f5f9" />
            <stop offset="1" stopColor="#dde3ed" />
          </linearGradient>
          <linearGradient id="screenGrad" x1="63" y1="51" x2="197" y2="109" gradientUnits="userSpaceOnUse">
            <stop stopColor="#0d9488" stopOpacity="0.9" />
            <stop offset="1" stopColor="#1d4ed8" stopOpacity="0.7" />
          </linearGradient>
        </defs>
      </svg>
    </div>
  );
}
