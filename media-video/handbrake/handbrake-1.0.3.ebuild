# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2-utils python-any-r1

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/HandBrake/HandBrake.git"
	inherit git-r3
	KEYWORDS=""
else
	EGIT_REPO_URI="https://github.com/HandBrake/HandBrake.git"
	EGIT_COMMIT="1.0.3"
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open-source, GPL-licensed, multiplatform, multithreaded video transcoder"
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"

SLOT="0"
IUSE="+fdk gstreamer gtk libav libav-aac x265"

REQUIRED_USE="^^ ( fdk libav-aac )"

RDEPEND="
	dev-libs/jansson
	media-libs/a52dec
	media-libs/libass:=
	>=media-libs/libbluray-1.0
	media-libs/libdvdnav
	media-libs/libdvdread
	media-libs/libsamplerate
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/libvpx
	media-libs/opus
	media-libs/x264:=
	media-sound/lame
	sys-libs/zlib
	libav? ( >=media-video/libav-10.1:0=[fdk?] )
	!libav? ( >=media-video/ffmpeg-2.3:0=[fdk?] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-a52dec:1.0
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-x264:1.0
	)
	gtk? (
		>=x11-libs/gtk+-3.10
		dev-libs/dbus-glib
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/libnotify
		x11-libs/pango
		virtual/libgudev:=
	)
	fdk? ( media-libs/fdk-aac )
	x265? ( >=media-libs/x265-1.7:0= )
	"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/yasm
	dev-util/intltool
	sys-devel/automake"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	./configure \
		--force \
		--verbose \
		--prefix="${EPREFIX}/usr" \
		--disable-gtk-update-checks \
		$(use_enable libav-aac) \
		$(use_enable fdk fdk-aac) \
		$(use_enable gtk) \
		$(usex !gstreamer --disable-gst) \
		$(use_enable x265) || die "Configure failed."
}

src_compile() {
	emake -C build

	# TODO: Documentation building is currently broken, try to fix it.
	#
	# if use doc ; then
	# 	emake -C build doc
	# fi
}

src_install() {
	emake -C build DESTDIR="${D}" install

	dodoc README.markdown AUTHORS.markdown NEWS.markdown THANKS.markdown
}

pkg_postinst() {
	einfo "For the CLI version of HandBrake, you can use \`HandBrakeCLI\`."

	if use gtk ; then
		einfo ""
		einfo "For the GTK+ version of HandBrake, you can run \`ghb\`."
	fi

	gnome2_icon_cache_update
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
}
