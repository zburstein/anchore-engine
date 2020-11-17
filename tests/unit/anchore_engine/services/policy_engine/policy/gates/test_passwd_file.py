import pytest
from anchore_engine.services.policy_engine.engine.policy.gates import passwd_file
from anchore_engine.services.policy_engine.engine.policy.gate import ExecutionContext
from anchore_engine.db.entities.policy_engine import Image, AnalysisArtifact


image_id = '1'
user = 'admin'
digest = '1'

@pytest.fixture()
def image(monkeypatch):
    monkeypatch.setattr(Image, 'analysis_artifacts', MockAnalysisArtifacts(), raising=True)

    img = Image()
    img.id = image_id
    img.digest = digest
    img.user_id = user
    return img


class MockAnalysisArtifacts:
    def __init__(self,):
        artifact1 = AnalysisArtifact()
        artifact1.analyzer_id = 'retrieve_files'
        artifact1.analyzer_artifact = 'file_content.all'
        artifact1.artifact_key = '/etc/passwd'
        artifact1.analyzer_type = 'base'
        artifact1.image_id = image_id
        artifact1.image_user_id = user
        artifact1.binary_value = """root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/usr/bin/false
adm:x:22:22:adm:/var/adm:/usr/bin/false
redis:x:41:41:redis:/var/redis:/bin/zsh"""

        self.artifacts = [
            artifact1
        ]

    def __call__(self, *args, **kwargs):
        return self.artifacts

    def __iter__(self):
        return self.artifacts.__iter__()

    def filter(self, *args, **kwargs):
        a = [artifact for artifact in self.artifacts if artifact.artifact_key == "/etc/passwd"]

        class A:
            def first(self):
                return a[0] if len(a) > 0 else None

        return A()


@pytest.fixture()
def passwd_gate():
    return passwd_file.FileparsePasswordGate()

@pytest.fixture()
def exec_context():
    return ExecutionContext(db_session=None, configuration={})

@pytest.fixture()
def file_not_stored_trigger(passwd_gate):
    return passwd_file.FileNotStoredTrigger(parent_gate_cls=passwd_gate.__class__)

@pytest.fixture()
def make_username_match_trigger(passwd_gate):
    def _make_username_match_trigger(trigger_params):
        return passwd_file.UsernameMatchTrigger(
            parent_gate_cls=passwd_gate.__class__, **trigger_params
        )

    return _make_username_match_trigger

@pytest.fixture()
def make_user_id_match_trigger(passwd_gate):
    def _make_user_id_match_trigger(trigger_params):
        return passwd_file.UserIdMatchTrigger(
            parent_gate_cls=passwd_gate.__class__, **trigger_params
        )

    return _make_user_id_match_trigger


def test_file_not_stored(passwd_gate, file_not_stored_trigger, exec_context, image):
    image.analysis_artifacts()[0].artifact_key = "other"

    passwd_gate.prepare_context(image, exec_context)
    assert file_not_stored_trigger.execute(image, exec_context)
    assert file_not_stored_trigger.did_fire
    assert len(file_not_stored_trigger.fired) == 1
    assert file_not_stored_trigger.fired[0].msg == file_not_stored_trigger.__msg__

adm_blacklist_msg = "Blacklisted user 'adm' found in image's /etc/passwd: pentry=adm:x:2:2:adm:/var/adm:/sbin/nologin"
blacklisted_users_context = [
    {
        'user_names': "adm",
        'expected_fire': True,
        'expected_msgs': [
            adm_blacklist_msg
        ]
    },
    {
        'user_names': "adm,bin",
        'expected_fire': True,
        'expected_msgs': [
            "Blacklisted user 'bin' found in image's /etc/passwd: pentry=bin:x:1:1:bin:/bin:/sbin/nologin",
            adm_blacklist_msg
        ]
    },
    {
        'user_names': "postgres",
        'expected_fire': False,
    }

]

@pytest.mark.parametrize('test_context', blacklisted_users_context)
def test_user_blacklist_triggered(passwd_gate, make_username_match_trigger, exec_context, image, test_context):
    trigger = make_username_match_trigger({'user_names': test_context['user_names']})
    passwd_gate.prepare_context(image, exec_context)

    assert trigger.execute(image, exec_context)
    if test_context['expected_fire']:
        assert trigger.did_fire
        assert len(trigger.fired) == len(test_context['expected_msgs'])
        diff = set(test_context['expected_msgs']) - set(map(lambda t: t.msg, trigger.fired))
        assert len(diff) == 0
    else:
        assert not trigger.did_fire

uid_22_blacklist_msg = "Blacklisted uid '22' found in image's /etc/passwd: pentry=adm:x:22:22:adm:/var/adm:/usr/bin/false"
blacklisted_user_ids_context = [
    {
        'user_ids': "22",
        'expected_fire': True,
        'expected_msgs': [
            uid_22_blacklist_msg
        ]
    },
    {
        'user_ids': "22,41",
        'expected_fire': True,
        'expected_msgs': [
            "Blacklisted uid '41' found in image's /etc/passwd: pentry=redis:x:41:41:redis:/var/redis:/bin/zsh",
            uid_22_blacklist_msg
        ]
    },
    {
        'user_ids': "220",
        'expected_fire': False,
    }

]

@pytest.mark.parametrize('test_context', blacklisted_user_ids_context)
def test_user_ids_triggered(passwd_gate, make_user_id_match_trigger, exec_context, image, test_context):
    trigger = make_user_id_match_trigger({'user_ids': test_context['user_ids']})
    passwd_gate.prepare_context(image, exec_context)

    assert trigger.execute(image, exec_context)
    if test_context['expected_fire']:
        assert trigger.did_fire
        assert len(trigger.fired) == len(test_context['expected_msgs'])
        diff = set(test_context['expected_msgs']) - set(map(lambda t: t.msg, trigger.fired))
        assert len(diff) == 0
    else:
        assert not trigger.did_fire

