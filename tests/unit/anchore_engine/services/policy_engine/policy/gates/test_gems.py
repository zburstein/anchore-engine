import pytest
from unittest.mock import Mock
from anchore_engine.services.policy_engine.engine.policy.gates import gems
from anchore_engine.services.policy_engine.engine.policy.gate import ExecutionContext
from anchore_engine.db.entities.policy_engine import Image, ImagePackage, GemMetadata


image_id = '1'
user = 'admin'

def gem_metadata():
    return [
        GemMetadata(
            id="1",
            name="rails",
            latest="123"
        ),
        GemMetadata(
            id="2",
            name="nokogiri",
            latest="123"
        )
    ]


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
    mock_db = Mock()
    mock_db.query().filter().all = gem_metadata
    return ExecutionContext(db_session=mock_db, configuration={})


@pytest.fixture()
def gems_gate():
    return gems.GemCheckGate()

@pytest.fixture()
def not_latest_trigger(gems_gate):
    return gems.NotLatestTrigger(parent_gate_cls=gems_gate.__class__)

def test_123(gems_gate, exec_context, image, not_latest_trigger):
    gems_gate.prepare_context(image, exec_context)

    assert not_latest_trigger.execute(image, exec_context)
    print("test")



# need to mock context query to db for GemMetadata