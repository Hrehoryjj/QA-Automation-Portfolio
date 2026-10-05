import pytest
from deepeval import assert_test

from helpers.metrics import hallucination_metric
from helpers.test_utils import as_params, build_test_case, get_cases_by_category

records = get_cases_by_category("hallucination")


@pytest.mark.parametrize("record", as_params(records))
def test_hallucination(record):
    assert_test(build_test_case(record), [hallucination_metric()])
