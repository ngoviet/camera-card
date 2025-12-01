import commonjs from '@rollup/plugin-commonjs';
import image from '@rollup/plugin-image';
import json from '@rollup/plugin-json';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import replace from '@rollup/plugin-replace';
import terser from '@rollup/plugin-terser';
import typescript from '@rollup/plugin-typescript';
import gitInfo from 'rollup-plugin-git-info';
import serve from 'rollup-plugin-serve';
import styles from 'rollup-plugin-styler';
import svgo from 'rollup-plugin-svgo';
import { visualizer } from 'rollup-plugin-visualizer';

const watch = process.env.ROLLUP_WATCH === 'true' || process.env.ROLLUP_WATCH === '1';
const dev = watch || process.env.DEV === 'true' || process.env.DEV === '1';

/**
 * @type {import('rollup-plugin-serve').ServeOptions}
 */
const serveopts = {
  contentBase: ['./dist'],
  host: '0.0.0.0',
  port: 10001,
  allowCrossOrigin: true,
  headers: {
    'Access-Control-Allow-Origin': '*',
  },
};

/**
 * @type {import('rollup').RollupOptions['plugins']}
 */
const plugins = [
  gitInfo.default({ enableBuildDate: true, updateVersion: false }),
  styles({
    modules: false,
    // Behavior of inject mode, without actually injecting style
    // into <head>.
    mode: ['inject', () => undefined],
    sass: {
      includePaths: ['./node_modules/'],
    },
  }),
  svgo(),
  image({ exclude: '**/*.svg' }),
  nodeResolve({
    browser: true,
  }),
  commonjs({
    include: 'node_modules/**',
    sourceMap: false,
  }),
  typescript({
    sourceMap: dev,
    inlineSources: dev,
    exclude: ['dist/**', 'tests/**/*.test.ts'],
  }),
  json({ exclude: ['package.json', 'node_modules/**/package.json'] }),
  replace({
    preventAssignment: true,
    values: {
      'process.env.NODE_ENV': JSON.stringify(dev ? 'development' : 'production'),
      __ADVANCED_CAMERA_CARD_RELEASE_VERSION__:
        process.env.RELEASE_VERSION ?? (dev ? 'dev' : 'pkg'),
    },
  }),
  watch && serve(serveopts),
  !dev && terser(),
  visualizer({
    filename: 'visualizations/treemap.html',
    template: 'treemap',
  }),
];

const outputEntryTemplate = {
  entryFileNames: 'advanced-camera-card.js',
  dir: 'dist',
  chunkFileNames: (chunk) => {
    // Add "lang-" to the front of the language chunk names for readability.
    if (
      chunk.facadeModuleId &&
      chunk.facadeModuleId.match(/localize\/languages\/.*\.json/)
    ) {
      return 'lang-[name]-[hash].js';
    }
    return '[name]-[hash].js';
  },
  format: 'es',
  sourcemap: dev,
  manualChunks: (id) => {
    // Group large dependencies into separate chunks for better code splitting
    // vis-timeline and vis-data are already lazy loaded, but we still want to chunk them
    if (id.includes('vis-timeline') || id.includes('vis-data')) {
      return 'vis-timeline';
    }
    // jsmpeg-player for video playback
    if (id.includes('jsmpeg-player')) {
      return 'jsmpeg';
    }
    // masonry-layout for gallery grid layouts
    if (id.includes('masonry-layout')) {
      return 'masonry';
    }
    // embla-carousel for carousel functionality
    if (id.includes('embla-carousel')) {
      return 'embla';
    }
    // Group other large node_modules dependencies
    if (id.includes('node_modules')) {
      // Keep lodash-es in a separate chunk (though we've replaced many functions)
      if (id.includes('lodash-es')) {
        return 'lodash';
      }
      // Group other large dependencies
      if (
        id.includes('home-assistant-js-websocket') ||
        id.includes('ha-nunjucks') ||
        id.includes('date-fns')
      ) {
        return 'ha-deps';
      }
    }
  },
};

const CIRCULAR_DEPENDENCY_IGNORE_REGEXP = /(ha-nunjucks|ts-py-datetime)/;

/**
 * @type {import('rollup').RollupOptions}
 */
const config = {
  input: 'src/card.ts',
  // Specifically want a facade created as HACS will attach a hacstag
  // queryparameter to the resource. Without a facade when chunks re-import the
  // card chunk, they'll refer to a 'different' copy of the card chunk without
  // the hacstag, causing a re-download of the same content and functionality
  // problems.
  preserveEntrySignatures: 'strict',
  output: [
    outputEntryTemplate,

    // Continue to include the old file name for backwards compatibility.
    {
      ...outputEntryTemplate,
      entryFileNames: 'frigate-hass-card.js',
    },
  ],
  plugins: plugins,
  // These files use `this` at the toplevel, which causes rollup warning spam on
  // build: `this` has been rewritten to `undefined`.
  moduleContext: {
    './node_modules/@formatjs/intl-utils/lib/src/diff.js': 'window',
    './node_modules/@formatjs/intl-utils/lib/src/resolve-locale.js': 'window',
  },
  // Ignore circular dependencies from underlying libraries.
  onwarn: (warning, defaultHandler) => {
    if (
      warning.code === 'CIRCULAR_DEPENDENCY' &&
      warning.ids.some((id) => id.match(CIRCULAR_DEPENDENCY_IGNORE_REGEXP))
    ) {
      return;
    }
    defaultHandler(warning);
  },
};

export default config;
