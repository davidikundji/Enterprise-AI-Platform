from fastapi import FastAPI
from pydantic import BaseModel

from app.bedrock_client import generate_text


app = FastAPI(
    title="Enterprise AI DevOps API",
    description="AI API deployed using AWS, Terraform, ECS, and Amazon Bedrock",
    version="1.0.0"
)


class PromptRequest(BaseModel):
    prompt: str


@app.get("/")
def root():
    return {
        "message": "Enterprise AI DevOps API",
        "status": "running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.post("/generate")
def generate(request: PromptRequest):
    result = generate_text(request.prompt)

    return {
        "prompt": request.prompt,
        "response": result["text"],
        "usage": result["usage"],
        "metrics": result["metrics"]
    }
