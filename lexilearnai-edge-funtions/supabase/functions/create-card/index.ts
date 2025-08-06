// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { sendSuccess, sendError } from "../_shared/responseHelper.ts"
import { GeminiService } from "./services/gemini_service.ts"
import { ResponseEnum } from "./constants/enum/response_enum.ts"

const geminiService = new GeminiService();

// Supabase client oluştur
const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const supabase = createClient(supabaseUrl, supabaseServiceKey)

console.log("Hello from create-card!")

Deno.serve(async (req) => {
  try {
    const { word, language_code = 'en' } = await req.json()

    if (!word || typeof word !== 'string') {
      return sendError({
        message: ResponseEnum.INVALID_INPUT,
        code: 400,
        path: "/create-card"
      })
    }

    const { data: language, error: langError } = await supabase
      .from('languages')
      .select('id')
      .eq('code', language_code)
      .eq('is_active', true)
      .single()

    if (langError || !language) {
      console.error("Language not found:", language_code)
      return sendError({
        message: "Language not supported",
        code: 400,
        path: "/create-card"
      })
    }

    const { data: existingWord, error: wordError } = await supabase
      .from('words')
      .select(`
        id,
        word,
        word_types (
          id,
          type,
          ipa,
          level,
          definition,
          synonym,
          sentence,
          photo_description
        )
      `)
      .eq('word', word.toLowerCase())
      .eq('language_id', language.id)
      .single()

    if (wordError && wordError.code !== 'PGRST116') {
      console.error("Database error:", wordError)
      return sendError({
        message: "Database error occurred",
        code: 500,
        path: "/create-card"
      })
    }

    if (existingWord) {
      console.log("Kelime database'den alındı:", existingWord.word)
      

      return sendSuccess({
        data: {
          success: true,
          reason: "from_database",
          word: existingWord.word,
          word_id: existingWord.id, // ✅ Word ID eklendi
          types: existingWord.word_types.map(type => ({

            id: type.id, // ✅ Word type ID eklendi
            type: type.type,
            ipa: type.ipa,
            definition: type.definition,
            synonym: type.synonym,
            sentence: type.sentence,
            level: type.level,
            photo_description: type.photo_description,
          }))
        },
        code: 200,
        message: ResponseEnum.SUCCESS,
        path: "/create-card"
      })
    }

    console.log("Kelime Gemini API'den alınıyor:", word)
    await geminiService.initialize();
    const response = await geminiService.generateCard(word);

    const parsedResponse = JSON.parse(response);

    if (!parsedResponse.success) {
      return sendError({
        message: parsedResponse.reason || "Gemini API error",
        code: 400,
        path: "/create-card"
      })
    }

    const { data: newWord, error: insertWordError } = await supabase
      .from('words')
      .insert({
        word: word.toLowerCase(),
        language_id: language.id
      })
      .select('id')
      .single()

    if (insertWordError) {
      console.error("Word insert error:", insertWordError)
      return sendError({
        message: "Failed to save word to database",
        code: 500,
        path: "/create-card"
      })
    }

    const wordTypesToInsert = parsedResponse.types.map((type: any) => ({
      word_id: newWord.id,
      type: type.type,
      ipa: type.ipa,
      level: type.level,
      definition: type.definition,
      synonym: type.synonym,
      sentence: type.sentence,
      photo_description: type.photo_description
    }))

    const { error: typesError } = await supabase
      .from('word_types')
      .insert(wordTypesToInsert)

    if (typesError) {
      console.error("Word types insert error:", typesError)
      await supabase.from('words').delete().eq('id', newWord.id)
      return sendError({
        message: "Failed to save word types to database",
        code: 500,
        path: "/create-card"
      })
    }


    console.log("Kart oluşturuldu ve database'e kaydedildi:", parsedResponse.word)

    const { data: savedWord, error: fetchError } = await supabase
      .from('words')
      .select(`
        id,
        word,
        word_types (
          id,
          type,
          ipa,
          level,
          definition,
          synonym,
          sentence,
          photo_description
        )
      `)
      .eq('id', newWord.id)
      .single()

    if (fetchError) {
      console.error("Fetch saved word error:", fetchError)
      return sendError({
        message: "Failed to fetch saved word",
        code: 500,
        path: "/create-card"
      })
    }

    return sendSuccess({
      data: {
        success: true,
        reason: "from_gemini",
        word: savedWord.word,
        word_id: savedWord.id, // ✅ Word ID eklendi
        types: savedWord.word_types.map(type => ({
          id: type.id, // ✅ Word type ID eklendi
          type: type.type,
          ipa: type.ipa,
          definition: type.definition,
          synonym: type.synonym,
          sentence: type.sentence,
          level: type.level,
          photo_description: type.photo_description
        }))
      },
      code: 200,
      message: ResponseEnum.SUCCESS,
      path: "/create-card"
    })

  } catch (error) {
    console.error("Hata oluştu:", error)
    return sendError({
      message: error.message || "Kart oluşturulurken bir hata oluştu",
      code: 500,
      path: "/create-card"
    })
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/create-card' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"word":"hello", "language_code":"en"}'

*/