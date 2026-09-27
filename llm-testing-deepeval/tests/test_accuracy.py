import pytest
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import SingleTurnParams

from helpers.llm_client import LocalLLM
from helpers.test_utils import get_cases_by_category, build_test_case

judge_model = LocalLLM()

correctness_metric = GEval(
    name="Correctness",
    criteria=(
        "Determine whether 'actual_output' is factually correct and consistent "
        "with 'expected_output'. Minor differences in wording are fine as long "
        "as the factual content matches." 
        "additional correct details are acceptable as long as they don't contradict the expected output"
    ),
    evaluation_params=[SingleTurnParams.ACTUAL_OUTPUT, SingleTurnParams.EXPECTED_OUTPUT],
    threshold=0.7,
    model=judge_model,
)

accuracy_records = get_cases_by_category("accuracy")


@pytest.mark.parametrize("record", accuracy_records, ids=[r["id"] for r in accuracy_records])
def test_accuracy(record):
    test_case = build_test_case(record)
    assert_test(test_case, [correctness_metric])