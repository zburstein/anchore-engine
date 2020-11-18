from anchore_engine.analyzers.utils import dig


def handler(findings, artifact, pkg_updates):
    """
    Handler function to map syft results for npm package type into the engine "raw" document format.
    """
    pkg_key = artifact['locations'][0]['path']
    name = artifact['name']
    homepage = dig(artifact, 'metadata', 'homepage', default="")
    author = dig(artifact, 'metadata', 'author', default="")
    authors = dig(artifact, 'metadata', 'authors', default=[])
    origins = [] if not author else [author]
    origins.extend(authors)

    pkg_value = {
            'name': name,
            'versions': [artifact['version']],
            'latest': artifact['version'],
            'sourcepkg': dig(artifact, 'metadata', 'url', default=homepage),
            'origins': origins,
            'lics': dig(artifact, 'metadata', 'licenses', default=[]),
        }
    
    pkg_update = pkg_updates.get(name, {})
    if pkg_update:
        pkg_value.clear()
        pkg_value.update(pkg_update)

    # inject the artifact document into the "raw" analyzer document
    findings['package_list']['pkgs.npms']['base'][pkg_key] = pkg_value

