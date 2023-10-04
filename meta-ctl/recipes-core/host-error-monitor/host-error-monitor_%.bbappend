EXTRA_OECMAKE += "-DCTL=${ctl-features}"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Configure-host-error-monitors-for-meta-egs.patch \
    file://0002-Add-SPR-support-for-IERR-and-ERR-pin-handling.patch \
    file://0003-CTL-Remove-poll-of-CPU_ERR0-CPU_ERR1-CPU_ERR2-pins.patch \
    "