import os
import json
import asyncio
from typing import List, Dict, Any, Optional
from openai import AsyncOpenAI

class LLM_Optimiser:
    """
    Handles LLM-driven optimisation of FFmpeg flags using OpenAI Structured Outputs.
    """
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.client = AsyncOpenAI(api_key=self.api_key)

    async def suggest_optimisations(self, metadata: Dict[str, Any], current_flags: List[str]) -> List[str]:
        """
        Uses an LLM to suggest optimal FFmpeg flags based on file metadata.
        """
        if not self.api_key:
            return []

        # Define the JSON schema for structured output
        # We want a list of strings representing FFmpeg flags.
        response_format = {
            "type": "json_schema",
            "json_schema": {
                "name": "ffmpeg_optimisation",
                "strict": True,
                "schema": {
                    "type": "object",
                    "properties": {
                        "suggested_flags": {
                            "type": "array",
                            "items": {"type": "string"}
                        },
                        "reasoning": {"type": "string"}
                    },
                    "required": ["suggested_flags", "reasoning"],
                    "additionalProperties": False
                }
            }
        }

        prompt = (
            f"You are an expert video engineer specialising in FFmpeg optimisation. "
            f"Analyse the following video metadata and current FFmpeg flags, then suggest additional "
            f"flags to optimise for a balance between quality and processing speed.\n\n"
            f"Metadata: {json.dumps(metadata)}\n"
            f"Current Flags: {', '.join(current_flags)}\n\n"
            f"Rules:\n"
            f"1. Only suggest parameter optimisations (e.g., -crf, -preset, -q:v, -threads).\n"
            f"2. NEVER suggest changing the target video codec.\n"
            f"3. Output only the suggested flags in the 'suggested_flags' array.\n"
            f"4. Provide a brief explanation in 'reasoning'."
        )

        try:
            response = await self.client.chat.completions.create(
                model="gpt-4o", # or "gpt-4o-mini"
                messages=[{"role": "user", "content": prompt}],
                response_format=response_format
            )

            # Parse the structured output
            res_content = response.choices[0].message.content
            if res_content:
                data = json.loads(res_content)
                return data.get("suggested_flags", [])
            return []
        except Exception as e:
            # In a real production system, we might want to log this error 
            # and return an empty list rather than failing the whole job.
            print(f"LLM Optimisation failed: {e}")
            return []
