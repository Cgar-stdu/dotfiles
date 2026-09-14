# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

#sshkey
eval "$(keychain --quiet id_ed25519_bitbucket id_ed25519_github)"
source ~/.keychain/$HOSTNAME-sh

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
# Silent ESP-IDF alias
alias gidf='[ -f "/home/cgar/esp-idf/export.sh" ] && . "/home/cgar/esp-idf/export.sh" >/dev/null 2>&1'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# jtag-Quartus
alias quartus-jtag='distrobox enter quartus-env -- /home/cgar/intelFPGA_lite/20.1/quartus/bin/jtagd && distrobox enter quartus-env -- /home/cgar/intelFPGA_lite/20.1/quartus/bin/jtagconfig'


export PATH="/home/cgar/bin:$PATH"
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt


# Added by Antigravity CLI installer
export PATH="/home/cgar/.local/bin:$PATH"

export QSYS_ROOTDIR="/home/cgar/intelFPGA_lite/20.1/quartus/sopc_builder/bin"
