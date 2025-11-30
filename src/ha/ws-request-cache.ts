/**
 * Cache for WebSocket requests to reduce redundant calls to Home Assistant.
 * This helps improve performance by avoiding duplicate requests for the same data.
 */

import { MessageBase } from 'home-assistant-js-websocket';
import { LRUCache } from '../cache/lru';

interface CachedRequest {
  request: MessageBase;
  timestamp: number;
}

// Cache size: 50 requests (enough for common use cases without using too much memory)
// TTL: 5 seconds (short enough to avoid stale data, long enough to batch similar requests)
const WS_REQUEST_CACHE_SIZE = 50;
const WS_REQUEST_CACHE_TTL_MS = 5000;

// Simple request key generator
function getRequestKey(request: MessageBase): string {
  return JSON.stringify({
    type: request.type,
    // Include relevant request parameters for uniqueness
    ...(request as Record<string, unknown>),
  });
}

class WSRequestCache {
  private _cache = new LRUCache<string, CachedRequest>(WS_REQUEST_CACHE_SIZE);

  /**
   * Get cached request if available and not expired.
   */
  get(key: string): MessageBase | null {
    const cached = this._cache.get(key);
    if (!cached) {
      return null;
    }

    const age = Date.now() - cached.timestamp;
    if (age > WS_REQUEST_CACHE_TTL_MS) {
      this._cache.delete(key);
      return null;
    }

    return cached.request;
  }

  /**
   * Store a request in cache.
   */
  set(key: string, request: MessageBase): void {
    this._cache.set(key, {
      request,
      timestamp: Date.now(),
    });
  }

  /**
   * Clear the cache.
   */
  clear(): void {
    this._cache.clear();
  }
}

// Global cache instance
const wsRequestCache = new WSRequestCache();

/**
 * Get cache key for a request.
 */
export function getWSRequestCacheKey(request: MessageBase): string {
  return getRequestKey(request);
}

/**
 * Get cached request if available.
 */
export function getCachedWSRequest(key: string): MessageBase | null {
  return wsRequestCache.get(key);
}

/**
 * Cache a request.
 */
export function cacheWSRequest(key: string, request: MessageBase): void {
  wsRequestCache.set(key, request);
}

/**
 * Clear WebSocket request cache.
 */
export function clearWSRequestCache(): void {
  wsRequestCache.clear();
}

