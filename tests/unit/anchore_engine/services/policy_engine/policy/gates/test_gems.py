import pytest
from anchore_engine.services.policy_engine.engine.policy.gates import gems
from anchore_engine.services.policy_engine.engine.policy.gate import ExecutionContext
from anchore_engine.db.entities.policy_engine import Image, ImagePackage, GemMetadata


image_id = '1'
user = 'admin'

@pytest.fixture()
def image():
    img = Image()
    img.id = image_id
    img.user_id = user
    img.get_packages_by_type = mock_get_packages_by_type
    return img

def mock_get_packages_by_type(type):
    return [
        ImagePackage(
            image_id=image_id,
            image_user_id=user,
            name="rails",
            version="5.0.1",
            pkg_type="gem"
        ),
        ImagePackage(
            image_id=image_id,
            image_user_id=user,
            name="nokogiri",
            version="1.7.0.1",
            pkg_type="gem"
        ),
    ]

@pytest.fixture()
def exec_context():
    return ExecutionContext(db_session=None, configuration={})

@pytest.fixture()
def gems_gate():
    return gems.GemCheckGate()


def test_123(gems_gate, exec_context, image):
    print("test")
    gems_gate.prepare_context(image, exec_context)





# need to mock context query to db for GemMetadata