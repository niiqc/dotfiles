function cover
    if test (count $argv) -ne 2
        echo "Use: resize_cover input.[jpg|png|webp|...] output.[jpg|png|webp|...]"
        return 1
    end

    set input $argv[1]
    set output $argv[2]

    if not test -f $input
        echo "Error: File '$input' not found."
        return 1
    end

    set dimensions (identify -format "%w %h" "$input")
    set width (echo $dimensions | cut -d' ' -f1)
    set height (echo $dimensions | cut -d' ' -f2)

    set new_width 2048
    set new_height 1024

    if test $width -ge $new_width -a $height -ge $new_height
        echo "Nothing to do image is ok"
        cp "$input" "$output"
    else
        convert "$input" -resize "$new_width"x"$new_height"^ -gravity center -extent "$new_width"x"$new_height" "$output"
        echo "Imaged convert to 2048x1024 (16:9): $output"
    end

    echo "Image saved: $output"
end
