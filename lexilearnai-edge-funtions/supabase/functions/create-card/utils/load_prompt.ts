import { EN_PROMPT } from "../constants/prompt/en_prompt.ts";

export async function loadPrompt(language: string = 'en'): Promise<string> {
    switch (language) {
        case 'en':
            return EN_PROMPT;
        default:
            return EN_PROMPT;
    }
}