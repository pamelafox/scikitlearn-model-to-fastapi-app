import json
import os
from string import Template
import pathlib

import joblib


def make_param_name(feature_name):
    """Returns a snake_case version of the given feature_name string."""
    param_name = ''
    for char in feature_name:
        if char.isspace():
            if param_name:
                param_name += '_'
            continue
        elif char.isupper():
            if param_name and param_name[-1] != "_":
                param_name += '_'
        param_name += char.lower()
    return param_name


def make_class_name(feature_name):
    """Returns a CamelCase version of the given feature_name string"""
    class_name = ''
    should_upper_next = False
    for char in feature_name:
        if char.isspace():
            if class_name:
                should_upper_next = True
        elif char.isupper() or should_upper_next:
            class_name += char.upper()
            should_upper_next = False
        else:
            class_name += char
    return class_name

def generate_enums(data, categorical_features):
    enums_lines = []
    for feature in categorical_features:
        feature_class_name = make_class_name(feature)
        enums_lines.append(f'class {feature_class_name}(str, Enum):')
        for ind, value in enumerate(sorted(data[feature].unique())):
            enum_name = f'{feature_class_name}_{ind}'
            enums_lines.append(f'    {enum_name} = "{value}"')
        enums_lines.append('\n')

    enums_module = 'from enum import Enum\n\n'  + '\n'.join(enums_lines)
    return enums_module

def generate_function(numeric_features, categorical_features):
    params = {}
    params_list = []
    for feature in numeric_features:
        param_name = make_param_name(feature)
        params[param_name] = "int"
        params_list.append(param_name)
    for feature in categorical_features:
        param_name = make_param_name(feature)
        params[param_name] = f"categories.{make_class_name(feature)}"
        params_list.append(f"{param_name}.value")
    
    features_params = json.dumps(params).replace("\"", "").replace("{", "").replace("}", "")
    features_list = ", ".join(params_list)

    function_template_filename = os.path.join(os.path.dirname(__file__), "function_template.py.txt")
    function_template_file = open(function_template_filename, "r")
    function_template = Template(function_template_file.read())
    function_template_file.close()
    return function_template.substitute(features_params=features_params, features_list=features_list)


def generate_fastapi(data, numeric_features, categorical_features, model, api_path):
    model_path = api_path / "model.pkl"
    joblib.dump(model, model_path)

    enums_path = api_path / "categories.py"
    with open(enums_path, "w") as enums_file:
        enums_file.write(generate_enums(data, categorical_features))

    init_path = api_path / "__init__.py"
    with open(init_path, "w") as init_file:
        init_file.write(generate_function(numeric_features, categorical_features))