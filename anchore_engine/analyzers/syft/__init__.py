import collections

from anchore_engine.analyzers.utils import defaultdict_to_dict, content_hints
from anchore_engine.clients.syft_wrapper import run_syft
from .handlers import handlers_by_artifact_type


def filter_artifacts(artifact):
    return artifact['type'] in handlers_by_artifact_type


def catalog_image(image):
    """
    Catalog the given image with syft, keeping only select artifacts in the returned results.
    """
    all_results = run_syft(image)

    # transform output into analyzer-module/service "raw" analyzer json document
    nested_dict = lambda: collections.defaultdict(nested_dict)
    findings = nested_dict()

    # This is the only use case for consuming the top-level results from syft,
    # capturing the information needed for BusyBox. No artifacts should be
    # expected, and having outside of the artifacts loop ensure this will only
    # get called once.
    distro = all_results.get('distro')
    if distro and distro.get('name', '').lower() == 'busybox':
        findings['package_list']['pkgs.all']["base"]["BusyBox"] = distro['version']
    elif not distro.get('name'):
        findings['package_list']['pkgs.all']["base"]["Unknown"] = distro["0"]

    # Package hints update information for handlers to inject additional values.
    pkg_hints = {}

    for package_type in handlers_by_artifact_type:
        # one-off because 'dpkg' is not defined as handler, and syft reports it
        # as a 'deb', but anchore-engine is 'dpkg'
        if package_type == 'deb':
            pkg_hints['deb'] = content_hints(pkg_type='dpkg')
        else:
            pkg_hints[package_type] = content_hints(pkg_type=package_type)

    # take a sub-set of the syft findings and invoke the handler function to
    # craft the artifact document and inject into the "raw" analyzer json
    # document
    for artifact in filter(filter_artifacts, all_results['artifacts']):
        handler = handlers_by_artifact_type[artifact['type']]
        handler.handler(findings, artifact, pkg_hints.get(artifact['type']))

    # Update call to allow for custom define package information.
    for pkg_type, handler in handlers_by_artifact_type.items():
        try:
            handler.update(findings, pkg_hints.get(pkg_type))
        except AttributeError:
            pass

    return defaultdict_to_dict(findings)
