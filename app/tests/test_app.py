from unittest.mock import patch

from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json()["status"] == "running"


def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy"
    }


@patch("app.main.generate_text")
def test_generate(mock_generate_text):

    mock_generate_text.return_value = {
        "text": "Amazon ECS is a managed container orchestration service.",
        "usage": {
            "inputTokens": 10,
            "outputTokens": 20,
            "totalTokens": 30
        },
        "metrics": {
            "latencyMs": 100
        }
    }

    response = client.post(
        "/generate",
        json={
            "prompt": "What is Amazon ECS?"
        }
    )

    assert response.status_code == 200

    data = response.json()

    assert data["prompt"] == "What is Amazon ECS?"
    assert data["response"] == "Amazon ECS is a managed container orchestration service."
    assert data["usage"]["totalTokens"] == 30
    assert data["metrics"]["latencyMs"] == 100

    mock_generate_text.assert_called_once_with(
        "What is Amazon ECS?"
    )
