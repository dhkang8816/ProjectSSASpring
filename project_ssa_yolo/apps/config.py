import os
import secrets
from pathlib import Path

basedir = Path(__file__).parent.parent


def _secret(name, fallback=None):
    """Read deployment secrets without committing a reusable fallback value."""
    value = os.getenv(name, "").strip()
    return value or fallback or secrets.token_urlsafe(32)

# BaseConfig 클래스를 작성한다
class BaseConfig:
    SECRET_KEY = _secret("SSA_FLASK_SECRET_KEY")
    WTF_CSRF_SECRET_KEY = _secret("SSA_FLASK_CSRF_SECRET_KEY", SECRET_KEY)


# BaseConfig 클래스를 상속하여 LocalConfig 클래스를 작성한다
class LocalConfig(BaseConfig):
    SQLALCHEMY_DATABASE_URI= f"sqlite:///{basedir / 'local.sqlite'}"
    SQLALCHEMY_TRACK_MODIFICATIONS=False
    SQLALCHEMY_ECHO=False


# BaseConfig 클래스를 상속하여 TestingConfig 클래스를 작성한다
class TestingConfig(BaseConfig):
    SQLALCHEMY_DATABASE_URI = f"sqlite:///{basedir / 'testing.sqlite'}"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    WTF_CSRF_ENABLED = False
    
# config 사전에 매핑한다
config = {
    "testing": TestingConfig,
    "local": LocalConfig,
}


