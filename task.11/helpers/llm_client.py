import os
from deepeval.models.base_model import DeepEvalBaseLLM
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

DEFAULT_BASE_URL = os.getenv("LOCAL_LLM_BASE_URL", "http://localhost:11434/v1")
DEFAULT_MODEL = os.getenv("LOCAL_LLM_MODEL", "qwen2.5:0.5b")
DEFAULT_API_KEY = os.getenv("LOCAL_LLM_API_KEY", "ollama")


def get_client(base_url=DEFAULT_BASE_URL, api_key=DEFAULT_API_KEY) -> OpenAI:
    return OpenAI(base_url=base_url, api_key=api_key)


def generate_response(prompt: str, model: str = DEFAULT_MODEL, temperature: float = 0.0) -> str:
    client = get_client()
    completion = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature,
    )
    return completion.choices[0].message.content.strip()


class LocalLLM(DeepEvalBaseLLM):

    def __init__(self, base_url=DEFAULT_BASE_URL, model=DEFAULT_MODEL, api_key=DEFAULT_API_KEY):
        self.base_url = base_url
        self.model_name = model
        self.api_key = api_key

    def load_model(self):
        return get_client(self.base_url, self.api_key)

    def generate(self, prompt: str, schema=None) -> str:
        client = self.load_model()
        kwargs = {}
        if schema is not None:
            kwargs["response_format"] = {"type": "json_object"}
        completion = client.chat.completions.create(
            model=self.model_name,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.0,
            **kwargs,
        )
        return completion.choices[0].message.content.strip()

    async def a_generate(self, prompt: str, schema=None) -> str:
        return self.generate(prompt, schema=schema)

    def get_model_name(self) -> str:
        return f"Local model ({self.model_name})"