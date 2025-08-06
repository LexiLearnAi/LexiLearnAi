import { createClient } from 'npm:@supabase/supabase-js'

// Initialize Supabase client
const supabaseClient = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

/**
 * Checks if a photo already exists for the given type_id
 */
export async function checkExistingPhoto(typeId: string) {
    const { data: photo, error: photoError } = await supabaseClient
        .from('photos')
        .select('*')
        .eq('word_type_id', typeId)
        .single()

    if (photoError && photoError.code !== 'PGRST116') {
        throw new Error(`Database error: ${photoError.message}`)
    }

    return photo
}

/**
 * Fetches word type information from database
 */
export async function getWordType(typeId: string) {
    const { data: wordType, error: wordTypeError } = await supabaseClient
        .from('word_types')
        .select('id, photo_description')
        .eq('id', typeId)
        .single()

    if (wordTypeError) {
        throw new Error(`Word type not found: ${wordTypeError.message}`)
    }

    return wordType
}

/**
 * Saves photo record to database
 */
export async function savePhotoRecord(typeId: string, imageUrl: string) {
    const { data, error } = await supabaseClient
        .from('photos')
        .insert({
            word_type_id: typeId,
            original_url: imageUrl,
            created_at: new Date().toISOString(),
        }).select().single()

    if (error) {
        throw new Error(`Failed to save image: ${error.message}`)
    }

    return data
}