from fastapi.testclient import TestClient

from .app import app

client = TestClient(app)


def test_model_predict():
    with TestClient(app) as client:
        response = client.get(
            "/model_predict",
            params={
                "years_code": 8,
                "years_code_pro": 6,
                "ed_level": "Bachelor’s degree (B.A., B.S., B.Eng., etc.)",
                "main_branch": "I am a developer by profession",
                "country": "United States of America",
            },
        )
    assert response.json() == {"prediction": 134882.17}
    assert response.status_code == 200
