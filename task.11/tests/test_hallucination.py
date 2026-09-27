import pytest
from deepeval import assert_test
from deepeval.metrics import HallucinationMetric

from helpers.llm_client import LocalLLM
from helpers.test_utils import get_cases_by_category, build_test_case

judge_model = LocalLLM()

hallucination_metric = HallucinationMetric(threshold=0.7, model=judge_model, include_reason=True)

hallucination_records = get_cases_by_category("hallucination")


@pytest.mark.parametrize(
    "record", hallucination_records, ids=[r["id"] for r in hallucination_records]
)
def test_hallucination(record):
    test_case = build_test_case(record)
    assert_test(test_case, [hallucination_metric])