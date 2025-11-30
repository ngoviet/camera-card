/**
 * Lazy loader for vis-timeline and vis-data libraries.
 * These libraries are large (~500KB+) and should only be loaded when timeline component is actually used.
 */

let timelineModule: typeof import('vis-timeline') | null = null;
let dataModule: typeof import('vis-data') | null = null;
let loadingPromise: Promise<void> | null = null;

/**
 * Lazy load vis-timeline and vis-data modules.
 * This will only load them once, even if called multiple times.
 */
export async function loadTimelineModules(): Promise<{
  timeline: typeof import('vis-timeline');
  data: typeof import('vis-data');
}> {
  if (timelineModule && dataModule) {
    return { timeline: timelineModule, data: dataModule };
  }

  if (loadingPromise) {
    await loadingPromise;
    return { timeline: timelineModule!, data: dataModule! };
  }

  loadingPromise = (async () => {
    const [timeline, data] = await Promise.all([
      import('vis-timeline'),
      import('vis-data'),
    ]);
    timelineModule = timeline;
    dataModule = data;
  })();

  await loadingPromise;
  return { timeline: timelineModule!, data: dataModule! };
}

/**
 * Get the already-loaded timeline module, or null if not loaded yet.
 */
export function getTimelineModule(): typeof import('vis-timeline') | null {
  return timelineModule;
}

/**
 * Get the already-loaded data module, or null if not loaded yet.
 */
export function getDataModule(): typeof import('vis-data') | null {
  return dataModule;
}

