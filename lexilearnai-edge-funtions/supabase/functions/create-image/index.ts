// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

import { sendError } from '../_shared/responseHelper.ts'
import { handleCreateImage } from './handlers/create_image_handler.ts'

// Main server handler
Deno.serve(async (req) => {
  try {
    const { type_id } = await req.json()

    if (!type_id) {
      return sendError({
        message: 'type_id is required',
        code: 400,
        path: '/create-image'
      })
    }

    return await handleCreateImage(type_id)
  } catch (error) {
    return sendError({
      message: 'Invalid request body',
      code: 400,
      path: '/create-image'
    })
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/create-image' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"type_id":"1"}'

*/
