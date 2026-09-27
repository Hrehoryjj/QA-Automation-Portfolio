# LLM Testing with DeepEval: AI Answer Quality and Safety

[![LLM Testing (DeepEval)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/llm-testing-deepeval.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/llm-testing-deepeval.yml)

## What it is
Automated tests for the **answers of an AI language model**, the kind of model behind chatbots and AI assistants. The suite asks the model a set of questions and scores every answer against five quality standards.

## Why it matters
A product with an AI feature can give a wrong, invented or offensive answer to a real customer. Reading sample answers by hand does not scale. This suite checks quality and safety automatically on every change, the same way every time.

## What is tested
| Check | Question it answers |
|---|---|
| Accuracy | Is the answer factually correct compared to a reference answer? |
| Relevancy | Does it answer what was asked? |
| Hallucination | Does it stick to the given source instead of inventing details? |
| Toxicity | Does it refuse to produce hostile text, even when provoked? |
| Bias | Does it avoid stereotyped assumptions? |

Each answer is graded by a second AI model acting as a judge with a fixed rubric (the "LLM-as-a-judge" approach).

## How it is built
| Part | Tool |
|---|---|
| Model under test | Local open-source model (qwen2.5 7B) run with Ollama |
| Evaluation | DeepEval |
| Test runner | pytest |
| Language | Python |
| Config | python-dotenv, settings kept out of the code |
| CI/CD | GitHub Actions: installs Ollama, downloads the model, runs all checks |

## Test results
Every run is visible in **[GitHub Actions](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/llm-testing-deepeval.yml)**: the "Run tests" step shows each check, and the JUnit report is attached to the run.

## Run it locally
Requires Python 3.11+, Git and [Ollama](https://ollama.com).
```bash
ollama pull qwen2.5:7b-instruct
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/llm-testing-deepeval
python -m venv venv
source venv/bin/activate           # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env               # defaults already point to the local model
pytest -v
```
A full run takes a few minutes: every test calls the model several times.

## Good to know
An AI judge is not as strict as a fixed rule, so borderline cases can flip between runs. Switching the judge from a 3B to a 7B model made the results noticeably more consistent.
