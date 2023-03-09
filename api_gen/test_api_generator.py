import pathlib

import api_generator
import pandas as pd
import pytest
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler


@pytest.fixture
def mock_numeric_features():
    return ("Years Code", "Years Code Pro")


@pytest.fixture
def mock_categorical_features():
    return ("Country", "Ed level")


@pytest.fixture
def mock_data():
    return pd.DataFrame(
        {
            "Country": ["Brazil", "Portugal", "Australia"],
            "Ed level": ["High school", "Bachelors degree", "Masters degree"],
            "Years Code": [10, 20, 30],
            "Years Code Pro": [15, 25, 35],
            "Comp Yearly": [60, 80, 100],
        }
    )


def test_make_param_name():
    assert api_generator.make_param_name("Code Years") == "code_years"
    assert api_generator.make_param_name("CodeYears") == "code_years"


def test_make_class_name():
    assert api_generator.make_class_name("Code Years") == "CodeYears"
    assert api_generator.make_class_name("Ed level") == "EdLevel"
    assert api_generator.make_class_name("CodeYears") == "CodeYears"


def test_generate_enums(mock_data, mock_categorical_features):
    enums_module = api_generator.generate_enums(mock_data, mock_categorical_features)
    test_enums_file_path = pathlib.Path(__file__).resolve().parent / "test_enums_file.py.txt"
    assert enums_module == open(test_enums_file_path).read()


def test_generate_routes(mock_numeric_features, mock_categorical_features):
    routes_file = api_generator.generate_routes(mock_numeric_features, mock_categorical_features)
    test_routes_file_path = pathlib.Path(__file__).resolve().parent / "test_routes_file.py.txt"
    print(routes_file)
    assert routes_file == open(test_routes_file_path).read()


def test_generate_fastapi(mock_data, mock_numeric_features, mock_categorical_features, tmp_path):
    X = mock_data[list(mock_numeric_features + mock_categorical_features)].values
    y = mock_data["Comp Yearly"].values
    X_train, _, y_train, _ = train_test_split(X, y, test_size=0.30, random_state=0)

    # Define preprocessing for numeric columns (scale them)
    numeric_features_indices = list(range(0, len(mock_numeric_features)))
    numeric_transformer = Pipeline(steps=[("scaler", StandardScaler())])

    # Define preprocessing for categorical features (encode them)
    categorical_features_indices = list(
        range(len(mock_numeric_features), len(mock_numeric_features) + len(mock_categorical_features))
    )
    categorical_transformer = Pipeline(steps=[("onehot", OneHotEncoder(handle_unknown="ignore"))])

    # Combine preprocessing steps
    preprocessor = ColumnTransformer(
        transformers=[
            ("num", numeric_transformer, numeric_features_indices),
            ("cat", categorical_transformer, categorical_features_indices),
        ]
    )

    # Create preprocessing and training pipeline
    pipeline = Pipeline(
        steps=[("preprocessor", preprocessor), ("regressor", GradientBoostingRegressor(n_estimators=50))]
    )
    model = pipeline.fit(X_train, (y_train))

    api_generator.generate_fastapi(mock_data, mock_numeric_features, mock_categorical_features, model, tmp_path)

    assert tmp_path.is_dir()
    assert (tmp_path / "model.pkl").is_file()
    assert (tmp_path / "categories.py").is_file()
    assert (tmp_path / "routes.py").is_file()
