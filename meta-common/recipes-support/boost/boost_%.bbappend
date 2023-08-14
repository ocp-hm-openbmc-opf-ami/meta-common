FILES:${PN} += "/usr/lib/libboost_chrono.so* \
               /usr/lib/libboost_atomic.so* \
               /usr/lib/libboost_context.so* \
               /usr/lib/libboost_thread.so* \
               /usr/lib/libboost_coroutine.so*"

# BOOST Libs is needed for all the platforms
BOOST_LIBS:append = " iostreams filesystem program_options regex system"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
