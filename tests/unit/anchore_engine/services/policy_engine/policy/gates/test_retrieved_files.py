import pytest
from anchore_engine.services.policy_engine.engine.policy.gates import retrieved_files
from anchore_engine.services.policy_engine.engine.policy.gate import ExecutionContext
from anchore_engine.db.entities.policy_engine import Image, AnalysisArtifact

image_id = '1'
user = 'admin'
artifacts = [
    AnalysisArtifact(
        analyzer_id='retrieve_files',
        analyzer_artifact ='file_content.all',
        analyzer_type="base",
        artifact_key="/etc/passwd"
    ),
    AnalysisArtifact(
        analyzer_id='retrieve_files',
        analyzer_artifact ='file_content.all',
        analyzer_type="base",
        artifact_key="/usr/local/lib/ruby/gems/2.3.0/"
    )
]

@pytest.fixture()
# def image(monkeypatch):
def image():
    # monkeypatch.setattr(Image, 'analysis_artifacts', MockAnalysisArtifacts(), raising=True)

    image =  Image(
        id=image_id,
        user_id=user,
        analysis_artifacts=artifacts
    )

    image.analysis_artifacts.filter().all = image.analysis_artifacts

    return image

@pytest.fixture()
def retrieved_files_gate():
    return retrieved_files.RetrievedFileChecksGate()


@pytest.fixture()
def file_not_stored_trigger(retrieved_files_gate):
    return retrieved_files.FileNotStoredTrigger(parent_gate_cls=retrieved_files_gate.__class__)


@pytest.fixture()
def exec_context():
    return ExecutionContext(db_session=None, configuration={})


def test_file_not_stored_trigger(retrieved_files_gate, exec_context, image, file_not_stored_trigger):
    retrieved_files_gate.prepare_context(image, exec_context)
    assert file_not_stored_trigger.execute(image, exec_context)
    print("test")