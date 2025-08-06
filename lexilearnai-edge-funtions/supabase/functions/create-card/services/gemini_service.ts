// gemini_service.ts
import { GoogleGenAI } from "npm:@google/genai";
import { loadPrompt } from "../utils/load_prompt.ts";

class GeminiService {
    private ai: GoogleGenAI;
    private systemPrompt: string = '';

    constructor() {
        this.ai = new GoogleGenAI({ apiKey: Deno.env.get("GEMINI_API_KEY") });
    }

    async initialize() {
        this.systemPrompt = await loadPrompt();
        //console.log(this.systemPrompt)
    }


    async generateCard(word: string) {


        const response = await this.ai.models.generateContent({
            config: {
                systemInstruction: [
                    {
                        text: this.systemPrompt,
                    }
                ],
            },
            model: 'gemini-2.5-pro',
            contents: [
                { role: 'user', parts: [{ text: `{"word": "${word}"}` }] }
            ]
        });
        console.log(response.text)
        let cleanedResponse = response.text.trim();
        if (cleanedResponse.startsWith('```json')) {
            cleanedResponse = cleanedResponse.replace(/^```json\s*/, '');
        }
        if (cleanedResponse.endsWith('```')) {
            cleanedResponse = cleanedResponse.replace(/\s*```$/, '');
        }

        return cleanedResponse;
    }


}

export { GeminiService };