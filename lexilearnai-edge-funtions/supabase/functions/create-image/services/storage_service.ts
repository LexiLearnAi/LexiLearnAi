import { createClient } from 'npm:@supabase/supabase-js'

// Initialize Supabase client
const supabaseClient = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

/**
 * Uploads image to Supabase storage
 */
export async function uploadImageToStorage(imageData: Uint8Array | string, fileName: string, bucket: string = 'images') {
    const { data, error } = await supabaseClient.storage
        .from(bucket)
        .upload(`en/${fileName}.png`, imageData, {
            contentType: 'image/png',
        })

    if (error) {
        console.error(`Failed to upload ${fileName}: ${error.message}`)
        throw new Error(`Upload failed for ${fileName}: ${error.message}`)
    }

    return data
}

/**
 * Gets public URL for the image
 */
export async function getImageUrl(typeId: string) {
    const { data } = supabaseClient.storage.from('images').getPublicUrl(`en/${typeId}.png`)
    return data.publicUrl
}
