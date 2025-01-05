choosevim() {
    local SELECTION="$1"
    local SETTING="NVIM_APPNAME=$SELECTION nvim"
    alias vim=$SETTING
    alias vi=$SETTING
    export EDITOR=$SETTING
}

OHOST="$(hostname)"
if [[ "$OHOST" == "GCGPP5J3E" || "$OHOST" == "fedoraremix" ]]; then
    choosevim rnvim
else
    choosevim anvim
fi
