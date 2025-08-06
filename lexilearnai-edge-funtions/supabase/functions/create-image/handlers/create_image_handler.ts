import { generateImage } from '../services/gemini_service.ts'
import { checkExistingPhoto, getWordType, savePhotoRecord } from '../services/database_service.ts'
import { uploadImageToStorage, getImageUrl } from '../services/storage_service.ts'
import { decodeImageData, validateImageData } from '../utils/image_utils.ts'
import { sendSuccess, sendError } from '../../_shared/responseHelper.ts'

/**
 * Saves the generated image to storage and database
 */
async function saveImageToDatabase(imageData: string, typeId: string) {
    try {
        // Upload original image only
        await uploadImageToStorage(decodeImageData(imageData), `${typeId}`)

        // Get public URL
        const imageUrl = await getImageUrl(typeId)

        // Save record to database
        const data = await savePhotoRecord(typeId, imageUrl)

        return data
    } catch (error) {
        console.error('Error saving image to database:', error)
        throw error
    }
}

/**
 * Main handler function for the create-image endpoint
 */
export async function handleCreateImage(typeId: string) {
    try {
        // Check if photo already exists
        const existingPhoto = await checkExistingPhoto(typeId)
        if (existingPhoto) {
            return sendSuccess({
                data: existingPhoto,
                message: 'Photo already exists',
                code: 200,
                path: '/create-image'
            })
        }

        // Get word type information
        const wordType = await getWordType(typeId)

        // Generate image
        const imageData = await generateImage(wordType.photo_description)
        if (!validateImageData(imageData)) {
            return sendError({
                message: 'Image generation failed',
                code: 500,
                path: '/create-image'
            })
        }

        // Save image to database
        const savedData = await saveImageToDatabase(imageData!, typeId)

        return sendSuccess({
            data: savedData,
            message: 'Image created successfully',
            code: 200,
            path: '/create-image'
        })

    } catch (error) {
        return sendError({
            message: error.message,
            code: 500,
            path: '/create-image'
        })
    }
}