import numpy

from . import categories
from .app import app, models


@app.get("/model_predict")
async def model_predict(
    years_code: int,
    years_code_pro: int,
    ed_level: categories.EdLevel,
    main_branch: categories.MainBranch,
    country: categories.Country,
):
    X_new = numpy.array([[years_code, years_code_pro, ed_level.value, main_branch.value, country.value]])
    result = models["predicter"].predict(X_new)
    return {"prediction": round(result[0], 2)}
