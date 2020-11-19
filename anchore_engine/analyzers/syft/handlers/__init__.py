from . import alpine
from . import gem
from . import java
from . import npm
from . import python
from . import rpm
from . import debian

# this is a mapping of syft artifact types to handler functions to transform syft output into engine-compliant output
handlers_by_artifact_type = {
    'gem': gem,
    'python': python,
    'npm': npm,
    'java-archive': java,
    'jenkins-plugin': java,
    'apk': alpine,
    'rpm': rpm,
    'deb': debian,
}
