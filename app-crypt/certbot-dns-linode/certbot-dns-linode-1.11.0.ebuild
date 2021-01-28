# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{3_6,3_7,3_8,3_9})
DISTUTILS_USE_SETUPTOOLS=rdepend

PARENT_PACKAGE_NAME="certbot"
if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PARENT_PACKAGE_NAME}/${PARENT_PACKAGE_NAME}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PARENT_PACKAGE_NAME}/${PARENT_PACKAGE_NAME}/archive/v${PV}.tar.gz -> ${PARENT_PACKAGE_NAME}-${PV}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
fi
S=${WORKDIR}/${PARENT_PACKAGE_NAME}-${PV}/${PN}

inherit distutils-r1

DESCRIPTION="Linode DNS plugin for certbot"
HOMEPAGE="https://github.com/certbot/certbot"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	app-crypt/certbot[${PYTHON_USEDEP}]"
