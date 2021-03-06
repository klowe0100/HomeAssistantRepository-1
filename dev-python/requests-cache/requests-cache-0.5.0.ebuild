# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

HOMEPAGE="https://pypi.org/project/requests-cache/"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="https://github.com/reclosedev/${PN}/archive/v${PV}.tar.gz -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

# Portage only has versions of request >= minimum border
RDEPEND=">=dev-python/requests-2.6[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Testsuite excels in tests connecting to the network via local server daemons
python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
