# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit user readme.gentoo-r1 distutils-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/esphome/esphome.git"
	EGIT_BRANCH="dev"
	S="${WORKDIR}/${P}/"
else
	MY_P=${P/_beta/b}
	MY_PV=${PV/_beta/b}
	# SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
	S="${WORKDIR}/${MY_P}/"
fi


DESCRIPTION="Make creating custom firmwares for ESP32/ESP8266 super easy."
HOMEPAGE="https://github.com/esphome/esphome https://pypi.org/project/esphome/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="server test"

RDEPEND=""
DEPEND="${REDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.11.7[${PYTHON_USEDEP}]
	>=dev-embedded/platformio-4.0.3
	>=dev-python/pyyaml-5.1.2[${PYTHON_USEDEP}]
	>=dev-python/paho-mqtt-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/colorlog-4.0.2[${PYTHON_USEDEP}]
	~dev-embedded/esptool-2.7[${PYTHON_USEDEP}]
	>=dev-python/typing-3.6.6[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.10.0[${PYTHON_USEDEP}]
	>=dev-libs/protobuf-3.10.0
	>=dev-python/pyserial-3.4[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	server? ( >=dev-python/ifaddr-0.1.6
			>=www-servers/tornado-5.1.1[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
The ESPHome dashboard listens on port 6052
ESPHome configuration is in: /etc/${PN}
dashboard command line arguments are configured in: /etc/conf.d/${PN}
logging is to: /var/log/${PN}/{dashboard,warnings}.log
support at https://git.edevau.net/onkelbeh/HomeAssistantRepository
"

DOCS="README.md"

pkg_setup() {
	if use server; then
		enewgroup "${PN}"
		enewuser "${PN}" -1 -1 "/etc/${PN}" "${PN}"
	fi
}

src_prepare() {
	sed -e 's;protobuf==3.10.0;protobuf==3.10.1;' \
		-i esphome.egg-info/requires.txt \
		-i setup.py
	sed -e 's;paho-mqtt==1.4.0;paho-mqtt==1.5.0;' \
		-i esphome.egg-info/requires.txt \
		-i setup.py
	eapply_user
}

python_install_all() {
	dodoc ${DOCS}
	distutils-r1_python_install_all

	if use server; then
		keepdir "/etc/${PN}"
		fowners -R "${PN}:${PN}" "/etc/${PN}"

		keepdir "/var/log/${PN}"
		fowners -R "${PN}:${PN}" "/var/log/${PN}"

		newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
		newinitd "${FILESDIR}/${PN}.init.d-r2" "${PN}"

		readme.gentoo_create_doc
	fi
}

python_test() {
	nosetests --verbose || die
	py.test -v -v || die
}

pkg_postinst() {
	if use server; then
		readme.gentoo_print_elog
	fi
}