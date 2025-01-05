OHOST="$(hostname)"
export NVIM_APPNAME=anvim
if [[ "$OHOST" == "GCGPP5J3E" || "$OHOST" == "fedoraremix" ]]; then
    export NVIM_APPNAME=rnvim
fi

alias vim=nvim
alias vi=nvim
export EDITOR=nvim
