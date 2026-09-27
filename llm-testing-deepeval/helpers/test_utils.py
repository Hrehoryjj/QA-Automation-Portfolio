import json
import os
from functools import lru_cache

from deepeval.test_case import LLMTestCase

from helpers.llm_client import generate_response

DATA_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "test_cases.json")


@lru_cache(maxsize=1)
def load_dataset():
    with open(DATA_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def get_cases_by_category(category: str):
    return [case for case in load_dataset() if category in case.get("categories", [])]


def build_test_case(record: dict) -> LLMTestCase:
    context = record.get("context")
    if context:
        context_text = "\n".join(context) if isinstance(context, list) else context
        prompt = f"Context:\n{context_text}\n\nQuestion: {record['input']}"
    else:
        prompt = record["input"]

    return LLMTestCase(
        input=record["input"],
        actual_output=generate_response(prompt),
        expected_output=record.get("expected_output"),
        context=context,
        retrieval_context=context,
    )