import json
from pathlib import Path

import pytest
from deepeval.test_case import LLMTestCase

from helpers.metrics import METRICS

CONTROLS = json.loads((Path(__file__).parent.parent / "data" / "negative_controls.json").read_text(encoding="utf-8"))


@pytest.mark.parametrize("record", CONTROLS, ids=[r["id"] for r in CONTROLS])
def test_metric_rejects_known_bad_output(record):
    metric = METRICS[record["metric"]]()
    case = LLMTestCase(
        input=record["input"],
        actual_output=record["actual_output"],
        expected_output=record.get("expected_output"),
        context=record.get("context"),
    )
    metric.measure(case)
    assert not metric.is_successful(), f"{metric.__name__} passed a known-bad output: score={metric.score}, reason={metric.reason}"
