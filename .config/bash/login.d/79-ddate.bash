if type -t ddate >/dev/null; then
    ddate +"Today is %{%A, the %e day of %B,%} in the YOLD %Y.%N%nIt's %H! %."
fi
