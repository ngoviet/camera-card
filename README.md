<!-- markdownlint-disable first-line-heading -->
<!-- markdownlint-disable fenced-code-language -->
<!-- markdownlint-disable no-inline-html -->

[![GitHub Release](https://img.shields.io/github/release/ngoviet/camera-card.svg?style=flat-square)](https://github.com/ngoviet/camera-card/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/ngoviet/camera-card/build.yml?style=flat-square)](https://github.com/ngoviet/camera-card/actions/workflows/build.yml)
[![License](https://img.shields.io/github/license/ngoviet/camera-card.svg?style=flat-square)](LICENSE)
[![HACS](https://img.shields.io/badge/HACS-default-orange.svg?style=flat-square)](https://hacs.xyz)

<a href="https://my.home-assistant.io/redirect/hacs_repository/?owner=ngoviet&repository=camera-card&category=frontend" target="_blank">
  <img src="https://my.home-assistant.io/badges/hacs_repository.svg" alt="Open this repository in HACS" style="height: 24px;">
</a>

<a href="https://buymeacoffee.com/ngoviet" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 217px !important;" >
</a>

<img src="https://raw.githubusercontent.com/dermotduffy/advanced-camera-card/main/docs/images/advanced-camera-card.png" alt="Advanced Camera Card" width="500px">

# Advanced Camera Card

Formerly known as: `Frigate Card`

A comprehensive camera card for Home Assistant - **Optimized for performance** with lazy loading, native JavaScript helpers, and Home Assistant-specific optimizations.

## Features

### Core Features
- **Live viewing** of multiple cameras with support for various live providers (HLS, WebRTC, JSMPEG, Image, go2rtc)
- **Timeline view** for browsing events and recordings across multiple cameras with lazy loading optimization
- **Media gallery** for clips and snapshot browsing with automatic updates
- **Media viewer** with video scrubbing and seeking capabilities
- **Grid or carousel** layout for multiple cameras with swipeable navigation
- **Fullscreen mode** with optimized rendering
- **Direct media downloads** from the card interface

### Advanced Features
- **Picture Elements support** - Full compatibility with Home Assistant Picture Elements
- **Automations** - Trigger actions based on conditions (fullscreen, keyboard input, entity states, etc.)
- **Custom elements** - Add custom HTML/CSS elements to the card
- **Menu system** - Access arbitrary entities, cameras, and custom actions
- **Status bar** - Display custom information and entity states
- **Folders** - Organize cameras and media into folders
- **Overrides** - Dynamic configuration changes based on conditions
- **Profiles** - Pre-configured sets of defaults for easy setup
- **2-way audio** - Microphone support for cameras
- **Casting** - Cast camera feeds to media players
- **PTZ controls** - Pan, tilt, zoom controls for supported cameras
- **Keyboard shortcuts** - Customizable keyboard navigation
- **Theme friendly** - Adapts to Home Assistant themes
- **Lovelace visual editor** - Edit configuration visually

### Performance Optimizations
- **Lazy loading** for timeline components (vis-timeline, vis-data) - reduces initial bundle size by ~759KB
- **Native JavaScript helpers** - Replaced lodash functions to reduce bundle size
- **Optimized caching** - Tuned cache sizes for better memory usage in HA context
- **State watching optimization** - Deduplicated entity subscriptions
- **WebSocket request infrastructure** - Prepared for request batching and caching
- **Smart card sizing** - Improved getCardSize() estimation for better Lovelace layout

## Installation

### Via HACS (Recommended)

**Option 1: Add Custom Repository**

1. Open HACS in Home Assistant
2. Go to **Frontend** > **Three dots menu (⋮)** > **Custom repositories**
3. Add repository with:
   - **Repository**: `ngoviet/camera-card`
   - **Category**: `Frontend` (Lovelace)
4. Click **Add**
5. Go back to **Frontend** and search for **Advanced Camera Card**
6. Click **Download**

**Option 2: Use HACS Button**

<a href="https://my.home-assistant.io/redirect/hacs_repository/?owner=ngoviet&repository=camera-card&category=frontend" target="_blank">
  <img src="https://my.home-assistant.io/badges/hacs_repository.svg" alt="Open this repository in HACS" style="height: 24px;">
</a>

**Note**: If you get "Repository not found" error, make sure:
- Repository is public on GitHub
- You have at least one release/tag (v0.1.0 or later)
- You're using the correct repository name: `ngoviet/camera-card`

### Manual Installation

See [Advanced Installation](https://card.camera/advanced-installation) for manual installation instructions.

## Quick Start

### Minimal Configuration

```yaml
type: custom:advanced-camera-card
cameras:
  - camera_entity: camera.office
```

### Multi-Camera Grid

```yaml
type: custom:advanced-camera-card
cameras:
  - camera_entity: camera.office
  - camera_entity: camera.kitchen
live:
  display:
    mode: grid
```

### Timeline with Scrubbing

```yaml
type: custom:advanced-camera-card
cameras:
  - camera_entity: camera.office
profiles:
  - scrubbing
```

## Documentation

📖 **[Full Documentation](https://card.camera/)** - Complete configuration guide, examples, and usage instructions

### Key Documentation Sections
- [Configuration](https://card.camera/configuration/) - All configuration options
- [Cameras](https://card.camera/configuration/cameras/) - Camera setup and engines
- [Live View](https://card.camera/configuration/live/) - Live streaming configuration
- [Timeline](https://card.camera/configuration/timeline/) - Event and recording timeline
- [Examples](https://card.camera/examples/) - Configuration examples
- [Usage](https://card.camera/usage/) - Advanced usage scenarios
- [Performance](https://card.camera/configuration/performance/) - Performance tuning options

## Supported Camera Engines

- **Frigate** - Full integration with Frigate NVR
- **Generic** - Works with any Home Assistant camera entity
- **Reolink** - Optimized for Reolink cameras
- **MotionEye** - MotionEye integration

## Live Providers

- **HLS** - HTTP Live Streaming (default for most cameras)
- **WebRTC** - Low-latency WebRTC streaming
- **JSMPEG** - MJPEG streaming
- **Image** - Static image updates
- **go2rtc** - go2rtc integration

## Support

If you find this project useful, please consider supporting development:

<a href="https://buymeacoffee.com/ngoviet" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 217px !important;" >
</a>

## License

MIT License - See [LICENSE](LICENSE) file for details.
