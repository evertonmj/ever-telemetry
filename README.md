# ever-telemetry

A compact system telemetry widget for the Omarchy bar. It displays live CPU,
RAM, and temperature readings at a glance, with load average and root-disk usage
available in the tooltip.

## Features

- CPU usage
- Memory usage
- CPU temperature
- One-minute load average
- Root filesystem usage
- Refreshes every three seconds
- Left-click opens `btop` in a floating terminal
- Right-click refreshes the readings immediately

## Install

```bash
omarchy plugin add https://github.com/evertonmj/ever-telemetry.git --enable
```

The widget is placed in the right section of the bar by default. Move it with:

```bash
omarchy bar move ever.telemetry --section right
```

Valid sections are `left`, `center`, and `right`.

## Requirements

- Omarchy with shell plugin support
- `bash`, `awk`, and `df`
- `lm_sensors` for temperature readings
- `btop` for the click action

The widget continues to work if no supported temperature sensor is detected;
the temperature is shown as `--`.

## Update

```bash
omarchy plugin update ever.telemetry
```

## Remove

```bash
omarchy plugin remove ever.telemetry
```

## Validate a local checkout

```bash
omarchy plugin validate .
```

## Security

Omarchy plugins run as unsandboxed user code. This plugin reads Linux system
telemetry from `/proc`, `df`, and `sensors`; it does not use `sudo`, access the
network, or write system data.
