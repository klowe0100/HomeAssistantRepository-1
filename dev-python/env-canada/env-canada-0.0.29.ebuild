# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN=${PN//-/_}
DESCRIPTION="A package to access meteorological data from Environment Canada"
HOMEPAGE="https://github.com/michaeldavie/env_canada https://pypi.org/project/env-canada/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/requests-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/geopy-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/imageio-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/requests-futures-0.9.7[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.7.1[${PYTHON_USEDEP}]
	>=dev-python/ratelimit-2.2.1[${PYTHON_USEDEP}]"
DEPEND="${REDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	nosetests --verbose || die
	py.test -v -v || die
}
