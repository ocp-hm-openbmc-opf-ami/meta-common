
PFR_EN = "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-secboot', 'pfr', '', d)}"

FILES:${PN} += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-secboot', '${datadir}/pfr/rk_cert.pem', '', d)}"
