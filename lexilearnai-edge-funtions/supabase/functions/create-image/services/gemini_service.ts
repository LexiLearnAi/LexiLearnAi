import { GoogleGenAI } from 'npm:@google/genai'

// Initialize Google GenAI client
const genai = new GoogleGenAI({
    apiKey: Deno.env.get('IMAGEN_API_KEY')!,
})

/**
 * Generates an image using Google GenAI based on the provided prompt
 */
export async function generateImage(prompt: string): Promise<string | null> {
    


    try {
        const response = await genai.models.generateImages({
            model: 'imagen-4.0-generate-preview-06-06',
            config: {
                numberOfImages: 1,
            },
            prompt: prompt,
        })

        for (const generatedImage of response.generatedImages) {
            let imgBytes = generatedImage.image.imageBytes;
            return imgBytes;
            
        }

        return null
    } catch (error) {
        console.error('Image generation error:', error)
        return null
    }
}