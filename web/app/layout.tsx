import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "TrackWeight – MacBook Trackpad Scale",
  description:
    "Turn your MacBook's Force Touch trackpad into a precision digital scale. Weighs objects with gram-level accuracy using Apple's multitouch pressure sensors.",
  openGraph: {
    title: "TrackWeight",
    description: "Turn your MacBook trackpad into a digital scale",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-white text-gray-900 antialiased">
        {children}
      </body>
    </html>
  );
}
