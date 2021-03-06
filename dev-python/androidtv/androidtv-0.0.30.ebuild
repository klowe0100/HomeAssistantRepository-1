# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Communicate with an Android TV or Fire TV device via ADB over a network."
HOMEPAGE="https://github.com/JeffLIrion/python-androidtv/ https://pypi.org/project/androidtv/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/rsa[${PYTHON_USEDEP}]
		 >=dev-python/pure-python-adb-homeassistant-0.1.7[${PYTHON_USEDEP}]
		 >=dev-python/adb-shell-0.0.4[${PYTHON_USEDEP}]
		 dev-python/pyasn1[${PYTHON_USEDEP}]"
DEPEND="${REDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests --verbose || die
	py.test -v -v || die
}
