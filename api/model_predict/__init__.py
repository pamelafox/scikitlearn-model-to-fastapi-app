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
async def model_predict(
    years_code: int,
    years_code_pro: int,
    ed_level: categories.EdLevel,
    main_branch: categories.MainBranch,
    country: categories.Country,
):
    X_new = numpy.array([[years_code, years_code_pro, ed_level.value, main_branch.value, country.value]])
    result = model.predict(X_new)
    return {"prediction": result[0]}


async def main(req: azure.functions.HttpRequest, context: azure.functions.Context) -> azure.functions.HttpResponse:
    return azure.functions.AsgiMiddleware(app).handle(req, context)
