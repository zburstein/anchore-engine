

class TestHints:

    def test_npm(self, hints_image):
        hints = {
            "packages": [
                {"name": "safe-buffer",
                "license": "FREE-FOR-ALL",
                "version": "100",
                "type": "npm"}
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
