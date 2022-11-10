import pathlib
import urllib.request
import zipfile

import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

from api_gen import api_generator

url = "https://info.stackoverflowsolutions.com/rs/719-EMH-566/images/stack-overflow-developer-survey-2022.zip"
filehandle, _ = urllib.request.urlretrieve(url)
zip_file_object = zipfile.ZipFile(filehandle, "r")
file = zip_file_object.open("survey_results_public.csv")

survey_data = pd.read_csv(file)

label = "ConvertedCompYearly"

# Drop rows with no data
survey_data = survey_data.dropna(subset=[label])

# Drop rows with extreme outliers
survey_data = survey_data.drop(survey_data[survey_data[label] > 400000].index)

numeric_features = ["YearsCode", "YearsCodePro"]

for col_name in numeric_features:
    survey_data[col_name] = pd.to_numeric(survey_data[col_name], errors="coerce")
    survey_data = survey_data.dropna(subset=[col_name])

categorical_features = ["EdLevel", "MainBranch", "Country"]

for col_name in categorical_features:
    survey_data = survey_data.dropna(subset=[col_name])

# Separate features and labels
X = survey_data[numeric_features + categorical_features].values
y = survey_data[label].values
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30, random_state=0)

# Define preprocessing for numeric columns (scale them)
numeric_features_indices = list(range(0, len(numeric_features)))
numeric_transformer = Pipeline(steps=[("scaler", StandardScaler())])

# Define preprocessing for categorical features (encode them)
categorical_features_indices = list(range(len(numeric_features), len(numeric_features) + len(categorical_features)))
categorical_transformer = Pipeline(steps=[("onehot", OneHotEncoder(handle_unknown="ignore"))])

# Combine preprocessing steps
preprocessor = ColumnTransformer(
    transformers=[
        ("num", numeric_transformer, numeric_features_indices),
        ("cat", categorical_transformer, categorical_features_indices),
    ]
)

# Create preprocessing and training pipeline
pipeline = Pipeline(steps=[("preprocessor", preprocessor), ("regressor", GradientBoostingRegressor(n_estimators=50))])
model = pipeline.fit(X_train, (y_train))

api_path = pathlib.Path(__file__).resolve().parent / "api/model_predict/"
api_generator.generate_fastapi(survey_data, numeric_features, categorical_features, model, api_path)
