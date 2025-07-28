#!/bin/bash

compare_clocksource_timing() {
    echo "🔁 Available clock sources:"
    cat /sys/devices/system/clocksource/clocksource0/available_clocksource
    echo

    for source in tsc hpet; do
        echo "🧪 Testing with clocksource: $source"
        if echo "$source" | sudo tee /sys/devices/system/clocksource/clocksource0/current_clocksource >/dev/null; then
            current=$(cat /sys/devices/system/clocksource/clocksource0/current_clocksource)
            echo "✅ Switched to: $current"
        else
            echo "❌ Failed to switch to: $source (may require root or not supported)"
            continue
        fi

        sleep 0.1  # short delay to stabilize

        start=$(date +%s%N)
        sleep 1
        end=$(date +%s%N)
        elapsed_ns=$((end - start))
        elapsed_ms=$((elapsed_ns / 1000000))

        echo "⏱️ Elapsed time with $source: $elapsed_ms ms"
        echo "----------------------------------------"
    done
}

compare_clocksource_timing