

class TestHintsNPM:
    def test_npm_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "safe-buffer",
                    "license": "FREE-FOR-ALL",
                    "version": "100",
                    "type": "npm"
                },
                {
                    "name": "toure-awesome",
                    "license": "Propietary",
                    "version": "1.0rc",
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
        assert package.get('sourcepkg') is None

        # Include non-existent package from a custom hint
        package = pkgs.get('toure-awesome')
        assert package['name'] == "toure-awesome"
        assert package['license'] == 'Propietary'
        assert package['version'] == '1.0rc'


class TestHintsRPM:

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

class TestHintsJava:

    def test_java_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "TwilioNotifier",
                    "origin": "com.twilio.jenkins",
                    "location": "/TwilioNotifier.hpi",
                    "type": "java-hpi",
                    "version": "N/A"
                }
            ]
        }
        result = hints_image(hints, 'java')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.java']['base']
        packages = pkgs.get('/TwilioNotifier.hpi')
        assert packages['type'] == "java-hpi"
        assert packages['location'] == "/TwilioNotifier.hpi"
        assert packages['origin'] == "com.twilio.jenkins"

class TestHintsAPKG:
    
    def test_apkg_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "version": "2.2",
                    "sourcepkg": "alpine-keys",
                    "release": "r0",
                    "origin": "Natanael Copa <ncopa@alpinelinux.org>",
                    "arch": "x86_64",
                    "license": "MIT",
                    "size": "1000",
                    "type": "APKG",
                    "name": "alpine-keys"
                }
            ]
        }

        result = hints_image(hints, 'py38')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.allinfo']['base']
        packages = pkgs.get('alpine-keys')
        assert packages['type'] == "APKG"
        assert packages['size'] == "1000"
        assert packages['license'] == "MIT"
        assert packages['release'] == "r0"


class TestHintsPython:
    def test_python_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "py",
                    "version": "1.9.1",
                    "type": "python",
                    "location": "/usr/lib/python3.8/my-site-packages",  
                }
            ]
        }

        result = hints_image(hints, 'py38')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.python']['base']
        packages = pkgs.get('py')
        assert packages['type'] == "python"
        assert packages['version'] == "1.9.1"
        assert packages['location'] == "/usr/lib/python3.8/my-site-packages"

class TestHintsGem:
    def test_gem_hints(self, hints_image):
        hints = {
            "packages": [
                {
                    "name": "uri",
                    "lics": ["GPL"],
                    "version": "0.11.0",
                    "latest": "0.10.0",
                    "origins": ["Akira Yamada"],
                    "sourcepkg": "https://example.com",
                    "type": "gem"
                }
            ]
        }

        result = hints_image(hints, 'lean')
        pkgs = result['image']['imagedata']['analysis_report']['package_list']['pkgs.gems']['base']
        packages = pkgs.get('uri')
        assert packages['lics'] == ["GPL"]
        assert packages['version'] == "0.11.0"
        assert packages['sourcepkg'] == "https://example.com"
        assert packages['type'] == "gem"
