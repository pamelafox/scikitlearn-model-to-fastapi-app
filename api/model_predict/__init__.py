import os

import azure.functions
import fastapi
import joblib
import nest_asyncio
import numpy

from . import categories

app = fastapi.FastAPI()
nest_asyncio.apply()
model = joblib.load(f"{os.path.dirname(os.path.realpath(__file__))}/model.pkl")

@app.get("/model_predict")
async def model_predict(code_years: int, code_years_pro: int, country: categories.Country, ed_level: categories.EdLevel):
    X_new = numpy.array([[code_years, code_years_pro, country.value, ed_level.value]])
    result = model.predict(X_new)
    return {"prediction": result[0]}

async def main(
    req: azure.functions.HttpRequest, context: azure.functions.Context
) -> azure.functions.HttpResponse:
    return azure.functions.AsgiMiddleware(app).handle(req, context)
