def latest-file [] {
    ls | sort-by modified | last
}
