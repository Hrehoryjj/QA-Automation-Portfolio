# Task 11 — Automated LLM Testing with DeepEval

## What this is

An automated test suite that checks the **quality and safety of an AI language
model's answers** before they can reach real users. If your product includes
a chatbot, an AI assistant, or any feature where an LLM generates text for
customers, this is the kind of testing that catches problems automatically,
on every change, instead of relying on someone manually reading through
sample answers.

Concretely, the suite asks a language model a set of questions and checks
each answer against five different quality standards — is it factually
correct, does it actually answer what was asked, does it invent things that
aren't true, is it toxic, is it biased. Each check is itself powered by
another AI model acting as an automated judge, following the same rubric
every time.

You do **not** need to be a tester to run it — the steps below are
copy-paste, and the "what it checks" table below explains each check in
plain language.

## What it checks

| Category | What it checks | Why it matters |
|---|---|---|
| **Accuracy** | Is the answer factually correct compared to a known-correct reference answer? | A confidently wrong answer erodes trust faster than no answer at all |
| **Relevancy** | Does the answer actually address what was asked, without wandering off-topic? | Users abandon a product that talks around their question instead of answering it |
| **Hallucination** | When given source material, does the answer stick to what's actually in it, instead of inventing details? | Made-up facts (wrong return policies, wrong specs, wrong dates) create real business and legal risk |
| **Toxicity** | Does the model refuse to produce insulting, hostile or abusive text, even when a user tries to provoke it? | Protects both end users and the brand from the product being used to generate harmful content |
| **Bias** | Does the model avoid unfair or stereotyped assumptions (e.g. about gender) in its answers? | Biased output is a reputational and fairness risk, and in some markets a legal one |

Each category has its own set of test questions (15 in total) and its own
pass/fail threshold.

## How it's built

| Piece | Tool | In one line |
|---|---|---|
| LLM under test | **Ollama**, running a local open-weight model | The "product" being tested — generates the answers we check |
| Evaluation framework | **DeepEval** | Runs each answer through the five quality checks and scores it |
| LLM-as-judge | Same local model, via DeepEval's model interface | Another AI reads each answer and decides if it passes, using a fixed rubric |
| Test runner | **pytest** | Finds the test cases, runs them, reports pass/fail |
| Config | **python-dotenv** | Keeps model settings and API keys out of the code, in a local `.env` file |

## Run it yourself

**Prerequisites:** Python 3.11+, and [Ollama](https://ollama.com) installed
locally.

```bash
# 1. Pull the local model used for both generating and judging answers
ollama pull qwen2.5:7b-instruct

# 2. Set up the Python environment
cd task.11
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt

# 3. Configure
cp .env.example .env            # defaults already point at the local Ollama model

# 4. Run the suite
pytest -v
```

A full run takes a few minutes, since every test case makes several calls to
the local model (one to generate the answer, more for the judge to evaluate
it).

## Project structure

```
task.11/
├── tests/                    one file per quality category
│   ├── test_accuracy.py
│   ├── test_relevancy.py
│   ├── test_hallucination.py
│   ├── test_toxicity.py
│   └── test_bias.py
├── helpers/
│   ├── llm_client.py         talks to the local model (via Ollama's OpenAI-compatible API)
│   └── test_utils.py         loads test cases, builds each test case for DeepEval
├── data/
│   └── test_cases.json       the 15 questions/inputs, grouped by category
├── conftest.py                shared pytest setup
├── .env.example               template for local configuration
└── requirements.txt
```

## Configuration

| Variable | Purpose |
|---|---|
| `LOCAL_LLM_BASE_URL` | Where the local model server (Ollama) is running |
| `LOCAL_LLM_MODEL` | Which model to use, for both generating and judging answers |
| `LOCAL_LLM_API_KEY` | Placeholder key Ollama requires but doesn't check |
| `CONFIDENT_API_KEY` | Optional: connects results to DeepEval's cloud dashboard (Confident AI) |
| `OLLAMA_KEEP_ALIVE` | How long Ollama keeps the model loaded in memory between calls, to avoid reload delays |

`.env` is git-ignored; `.env.example` is the template to copy.

## Known limitations

This suite tests a small model running entirely on a local machine's CPU,
both as the thing being tested *and* as the judge deciding pass/fail. Two
practical consequences worth knowing about:

- **Results can vary slightly between runs.** An AI judge doesn't grade with
  100% consistency the way a fixed rule would — borderline cases can flip
  between passing and failing from one run to the next.
- **A stronger model gives more reliable judging, at the cost of speed.**
  During development, switching the judge from a 3B-parameter model to a
  7B-parameter one fixed several unreliable results — the bigger model both
  followed the grading instructions more consistently and, in practice, ran
  faster overall (fewer confused retries). This is a real trade-off in any
  LLM-testing setup, not a bug in the suite itself.
