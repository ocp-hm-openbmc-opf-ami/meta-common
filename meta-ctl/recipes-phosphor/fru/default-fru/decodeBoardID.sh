decode_board_id() {
    local board_id="$1"
    local name=
    local prod_id=
    case $board_id in
        # 16 is a WA for Fab-1 boards with inverted board IDs.
        # 47 is the actual Catalina Beach board ID.
        # 61+62 are WAs to test CTL image on Archer City (Modular).
        16|47|61|62)
            name="CatalinaBeach"
            prod_id="0xaf";;
        *)  name="AST2600EVB"
            prod_id="0x00";;
    esac
    echo $name
    echo $prod_id
}
