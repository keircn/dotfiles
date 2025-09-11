function battstat
    set bat0 (upower -i /org/freedesktop/UPower/devices/battery_BAT0)
    set bat1 (upower -i /org/freedesktop/UPower/devices/battery_BAT1)

    set bat0_pct (string match -r 'percentage:\s+([0-9]+)%' $bat0)[2]
    set bat1_pct (string match -r 'percentage:\s+([0-9]+)%' $bat1)[2]

    set bat0_cap (string match -r 'capacity:\s+([0-9.]+)%' $bat0)[2]
    set bat1_cap (string match -r 'capacity:\s+([0-9.]+)%' $bat1)[2]

    set bat0_full (string match -r 'energy-full:\s+([0-9.]+)' $bat0)[2]
    set bat1_full (string match -r 'energy-full:\s+([0-9.]+)' $bat1)[2]

    set rate (string match -r 'energy-rate:\s+([0-9.]+)' $bat1)[2]
    if test -z "$rate"
        set rate (string match -r 'energy-rate:\s+([0-9.]+)' $bat0)[2]
    end

    set total_wh (math "$bat0_full + $bat1_full")

    function color_health
        set val (math -s1 "$argv[1]")
        if test $val -ge 80
            set_color green
        else if test $val -ge 60
            set_color yellow
        else
            set_color red
        end
        echo -n "$val%"
        set_color normal
    end

    function batt_icon
        set pct $argv[1]
        if test $pct -le 20
            echo -n ""
        else if test $pct -le 40
            echo -n ""
        else if test $pct -le 60
            echo -n ""
        else if test $pct -le 80
            echo -n ""
        else
            echo -n ""
        end
    end

    echo (batt_icon $bat0_pct)"  Internal (BAT0): $bat0_pct% | Health: "(color_health $bat0_cap)
    echo (batt_icon $bat1_pct)"  External (BAT1): $bat1_pct% | Health: "(color_health $bat1_cap)
    echo "  Total capacity: $total_wh Wh"

end
