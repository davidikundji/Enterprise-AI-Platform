import os

import boto3


AWS_REGION = os.getenv("AWS_REGION", "us-east-1")

BEDROCK_MODEL_ID = os.getenv(
    "BEDROCK_MODEL_ID",
    "us.anthropic.claude-haiku-4-5-20251001-v1:0"
)


def get_bedrock_client():
    return boto3.client(
        "bedrock-runtime",
        region_name=AWS_REGION
    )


def generate_text(prompt: str):
    client = get_bedrock_client()

    response = client.converse(
        modelId=BEDROCK_MODEL_ID,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "text": prompt
                    }
                ]
            }
        ],
        inferenceConfig={
            "maxTokens": 200,
            "temperature": 0.2
        }
    )

    return {
        "text": response["output"]["message"]["content"][0]["text"],
        "usage": response.get("usage", {}),
        "metrics": response.get("metrics", {})
    }
