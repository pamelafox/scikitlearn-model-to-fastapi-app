import os
from contextlib import asynccontextmanager

import fastapi
import joblib

models = {}


@asynccontextmanager
async def lifespan(app: fastapi.FastAPI):
    models["predicter"] = joblib.load(f"{os.path.dirname(os.path.realpath(__file__))}/model.pkl")
    yield
    models.clear()


app = fastapi.FastAPI(lifespan=lifespan)

from . import routes  # NOQA
