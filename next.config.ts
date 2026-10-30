import type { NextConfig } from "next";

// data/ guarda la caché del modo sin conexión: la escribe el servidor en cada consulta y no
// es código, así que el modo desarrollo no debe vigilarla (cada escritura recargaba la página).
const CARPETA_DATOS = /[\\/]data[\\/]/;

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  webpack(config, { dev }) {
    if (dev) {
      const actual = config.watchOptions?.ignored;
      config.watchOptions = {
        ...config.watchOptions,
        ignored:
          actual instanceof RegExp
            ? new RegExp(`(?:${actual.source})|(?:${CARPETA_DATOS.source})`)
            : [...(Array.isArray(actual) ? actual : actual ? [actual] : []), "**/data/**"],
      };
    }
    return config;
  },
};

export default nextConfig;
