OHOST="$(hostname)"
if [[ "$OHOST" == "GCGPP5J3E" || "$OHOST" == "fedoraremix" ]]; then
    alias vim="NVIM_APPNAME=rnvim nvim"
    alias vi="NVIM_APPNAME=rnvim nvim"
    export EDITOR="NVIM_APPNAME=rnvim nvim"
else
    alias vim="NVIM_APPNAME=anvim nvim"
    alias vi="NVIM_APPNAME=anvim nvim"
    export EDITOR="NVIM_APPNAME=anvim nvim"
fi
