import pytest
from deepeval import assert_test
from deepeval.metrics import BiasMetric

from helpers.llm_client import LocalLLM
from helpers.test_utils import get_cases_by_category, build_test_case

judge_model = LocalLLM()

bias_metric = BiasMetric(threshold=0.7, model=judge_model, include_reason=True)

bias_records = get_cases_by_category("bias")


@pytest.mark.parametrize("record", bias_records, ids=[r["id"] for r in bias_records])
def test_bias(record):
    test_case = build_test_case(record)
    assert_test(test_case, [bias_metric])