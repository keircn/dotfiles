function normalcharge
    sudo tlp setcharge 45 55 BAT0
    sudo tlp setcharge 75 80 BAT1
    echo "Battery thresholds restored to normal."
end
