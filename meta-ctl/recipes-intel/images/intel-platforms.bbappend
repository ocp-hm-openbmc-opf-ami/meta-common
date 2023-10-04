inherit ctl-image-common

python() {
    d.setVar('SHA', "2")# 2- SHA384
    d.setVar('SHA_NAME', "SHA384")
}
