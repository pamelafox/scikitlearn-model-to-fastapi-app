# Building a regression model and deploying to Azure

This project turns a scikit-learn regression model into an HTTP API using the FastAPI framework,
and deploys it to Azure functions using the Azure Developer CLI.

Technologies used: pandas, scikit-learn, numpy, matplotlib, joblib, Azure functions, Azure Developer CLI, FastAPI

## From model to API

The `api_gen` folder contains functionality that can process a scikit-learn regression model and output FastAPI function code.

It's used like this:

```python
import api_generator

api_generator.generate_fastapi(data, numeric_features, categorical_features, model, api_path)
```

where the parameter types are:

| Parameter            | Type                       |
| -------------------- |:-------------:             |
| data                 | `pandas` data frame        |
| numeric_features     | `iterable` of column names |
| categorical_features | `iterable` of column names |
| model                | `scikit-learn` model       |
| api_path             | `pathlib` Path             |

To try it yourself, modify `main.py` and run it. That will update files in the `api` folder.

## The API

The `api` folder contains the FastAPI code and function configuration that will actually get deployed to Azure functions.

* `app.py`: The FastAPI app, including a startup event that loads the model
* `routes.py`: Defines the `model_predict` API endpoint
* `categories.py`: The values of the enums for `model_predict` (generated from the `categorical features` in the notebook)
* `model.pkl`: The pickled regression model

## Local testing

The FastAPI app can be run locally using gunicorn and a uvicorn worker

```shell
python -m gunicorn api.model_predict.app:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:8888
```

Once the app is running, navigate to "/docs" to try out the API.

## Deployment

The Azure app can be deployed using the [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/overview). The `azd` CLI uses these files:

* `infra`:
  * `main.bicep`: Creates an Azure resource group and passes parameters to `resources.bicep`
  * `resources.bicep`: Creates a Function App, Storage account, App Service Plan, Log Analytics workspace, and Application Insights.
  * `main.parameters.json`: Describes parameters needed for `main.bicep`
* `azure.yaml`: Describes which code to upload to the Function App

To deploy the code, download the `azd` CLI and run:

```shell
azd up
```

It will prompt you to login and to provide a name (like "salary-model") and location (like "centralus"). Then it will provision the resources in your account (if they don't yet exist) and deploy the latest code.

When you've made any changes to the function, you can just run:

```shell
azd deploy
```


## Feedback!?

If you have any issues going through this repository, you can use the discussions tab on this repo or tweet at @pamelafox.
