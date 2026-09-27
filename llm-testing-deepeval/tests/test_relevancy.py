import pytest
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import SingleTurnParams

from helpers.llm_client import LocalLLM
from helpers.test_utils import get_cases_by_category, build_test_case

judge_model = LocalLLM()

relevancy_metric = GEval(
    name="Relevancy",
    criteria=(
        "Determine whether 'actual_output' directly addresses and stays relevant "
        "to what was asked in 'input', without going off-topic."
    ),
    evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
    threshold=0.7,
    model=judge_model,
)

relevancy_records = get_cases_by_category("relevancy")


@pytest.mark.parametrize("record", relevancy_records, ids=[r["id"] for r in relevancy_records])
def test_relevancy(record):
    test_case = build_test_case(record)
    assert_test(test_case, [relevancy_metric])