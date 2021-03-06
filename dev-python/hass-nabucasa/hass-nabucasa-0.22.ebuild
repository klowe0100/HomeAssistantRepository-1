# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Home Assistant cloud integration by Nabu Casa, inc."
HOMEPAGE="https://www.nabucasa.com/ https://pypi.org/project/hass-nabucasa/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="~dev-python/warrant-0.6.1[${PYTHON_USEDEP}]
		 ~dev-python/snitun-0.18[${PYTHON_USEDEP}]
		 >=app-crypt/acme-0.32.0
		 >=dev-python/cryptography-2.5[${PYTHON_USEDEP}]
		 >=dev-python/attrs-18.2.0[${PYTHON_USEDEP}]
		 dev-python/pytz[${PYTHON_USEDEP}]"
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
