import { decodeBase64 } from "jsr:@std/encoding/base64";

/**
 * Decodes base64 image data to Uint8Array
 */
export function decodeImageData(base64Data: string): Uint8Array {
    return decodeBase64(base64Data)
}

/**
 * Validates if image data is valid
 */
export function validateImageData(imageData: string | null): boolean {
    return imageData !== null && imageData.trim().length > 0
}