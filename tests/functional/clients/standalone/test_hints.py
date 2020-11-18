from anchore_engine.analyzers.utils import get_hintsfile


class TestHintsNPM:
    def test_npm_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "safe-buffer",
                    "license": "FREE-FOR-ALL",
                    "version": "100",
                    "type": "npm"
                }
            ]
        }
        result = hints_image(hints, 'npm')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.npms']['base']
        path = "/usr/lib/node_modules/npm/node_modules/string_decoder/node_modules/safe-buffer/package.json"
        package = pkgs.get(path)
        assert package['name'] == "safe-buffer"
        assert package['license'] == 'FREE-FOR-ALL'
        assert package['version'] == '100'
        assert package['sourcepkg'] == 'git://github.com/feross/safe-buffer.git'


class TestHintsRPM:

    @staticmethod
    def setup_method():
        get_hintsfile.cache_clear()

    def test_rpm_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "tar",
                    "license": "MIT",
                    "version": "42",
                    "type": "rpm",
                    "origin": "Centos"
                }
            ]
        }
        result = hints_image(hints, 'rpm')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.allinfo']['base']
        package = pkgs.get('tar')
        assert package['type'] == "rpm"
        assert package['license'] == 'MIT'
        assert package['version'] == '42'
        assert package['origin'] == 'Centos'


class TestHintsDPKG:

    @staticmethod
    def setup_method():
        get_hintsfile.cache_clear()

    def test_dpkg_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "adduser",
                    "version": "43",
                    "license": "GPL",
                    "type": "dpkg",
                }
            ]
        }
        result = hints_image(hints, 'stretch-slim')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.allinfo']['base']
        package = pkgs.get('adduser')
        assert package['type'] == "dpkg"
        assert package['version'] == '43'
        assert package['license'] == 'GPL'

