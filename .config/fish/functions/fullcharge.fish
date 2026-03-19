function fullcharge
    sudo tlp setcharge 100 100 BAT0
    sudo tlp setcharge 100 100 BAT1
    echo "Both batteries set to charge to 100%."
end
