export def nim [...$args] {
	if ($args | is-empty) {
		niri msg --help
	} else {
		niri msg -j ...$args | from json
	}
}
