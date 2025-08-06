-- Veritabanı Yapısı, İndeksler ve Tetikleyiciler için SQL Komutları

-- UUID uzantısını etkinleştir 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Eğer tablolar varsa önce sil
DROP TABLE IF EXISTS photos CASCADE;
DROP TABLE IF EXISTS user_card_items CASCADE;
DROP TABLE IF EXISTS user_cards CASCADE;
DROP TABLE IF EXISTS word_types CASCADE;
DROP TABLE IF EXISTS words CASCADE;
DROP TABLE IF EXISTS languages CASCADE;

----------------------------------------
-- TABLO YAPILARININ OLUŞTURULMASI
----------------------------------------

-- Diller tablosu
CREATE TABLE IF NOT EXISTS languages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT NOT NULL,  -- 'en', 'tr', 'fr' gibi dil kodları
  name TEXT NOT NULL,  -- 'English', 'Türkçe', 'Français'
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(code)
);

-- Kelimeler tablosu
CREATE TABLE IF NOT EXISTS words (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  word TEXT NOT NULL,
  language_id UUID REFERENCES languages(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(word, language_id)
);

-- Kelime türleri tablosu
CREATE TABLE IF NOT EXISTS word_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  word_id UUID REFERENCES words(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  ipa TEXT,
  level TEXT,
  definition JSONB,
  synonym JSONB,
  sentence JSONB,
  photo_description TEXT,
  view_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(word_id, type)
);

-- Kullanıcı kartları tablosu (ana kart bilgisi)
CREATE TABLE IF NOT EXISTS user_cards (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  word_id UUID REFERENCES words(id) ON DELETE CASCADE,
  word_type_id UUID REFERENCES word_types(id) ON DELETE CASCADE,
  is_favorite BOOLEAN DEFAULT FALSE,
  study_count INTEGER DEFAULT 0,
  last_studied_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, word_id, word_type_id)
);

-- Kullanıcı kart öğeleri tablosu (seçilen definition, sentence vs)
CREATE TABLE IF NOT EXISTS user_card_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_card_id UUID REFERENCES user_cards(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  word_id UUID REFERENCES words(id) ON DELETE CASCADE,
  word_type_id UUID REFERENCES word_types(id) ON DELETE CASCADE,
  item_type TEXT NOT NULL CHECK (item_type IN ('definition', 'sentence', 'synonym')),
  item_index INTEGER NOT NULL,
  item_value TEXT, -- cache için
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_card_id, item_type, item_index)
);



-- Fotoğraflar tablosu
CREATE TABLE IF NOT EXISTS photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  word_type_id UUID REFERENCES word_types(id) ON DELETE CASCADE,
  original_url TEXT,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(word_type_id)
);

----------------------------------------
-- İNDEKSLER
----------------------------------------

DO $$
BEGIN
  -- Kelime aramaları için indeks
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_words_word') THEN
    CREATE INDEX idx_words_word ON words(word);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_words_language') THEN
    CREATE INDEX idx_words_language ON words(language_id);
  END IF;

  -- Kelime-dil combined search
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_words_word_language') THEN
    CREATE INDEX idx_words_word_language ON words(word, language_id);
  END IF;

  -- Word types
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_word_types_word') THEN
    CREATE INDEX idx_word_types_word ON word_types(word_id);
  END IF;

  -- User cards
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_cards_user') THEN
    CREATE INDEX idx_user_cards_user ON user_cards(user_id);
  END IF;

  -- User card items
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_card_items_card') THEN
    CREATE INDEX idx_user_card_items_card ON user_card_items(user_card_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_card_items_user') THEN
    CREATE INDEX idx_user_card_items_user ON user_card_items(user_id);
  END IF;

  -- Photos
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_photos_word_type') THEN
    CREATE INDEX idx_photos_word_type ON photos(word_type_id);
  END IF;

END $$;

----------------------------------------
-- FUNCTIONS & TRIGGERS
----------------------------------------

-- Güncelleme zamanı fonksiyonu
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Tetikleyiciler
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_words_updated_at') THEN
    CREATE TRIGGER update_words_updated_at
    BEFORE UPDATE ON words FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_word_types_updated_at') THEN
    CREATE TRIGGER update_word_types_updated_at
    BEFORE UPDATE ON word_types FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_user_cards_updated_at') THEN
    CREATE TRIGGER update_user_cards_updated_at
    BEFORE UPDATE ON user_cards FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_user_card_items_updated_at') THEN
    CREATE TRIGGER update_user_card_items_updated_at
    BEFORE UPDATE ON user_card_items FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
  END IF;


END $$;

----------------------------------------
-- RLS POLİTİKALARI
----------------------------------------

-- Tabloları enable et
ALTER TABLE languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE words ENABLE ROW LEVEL SECURITY;
ALTER TABLE word_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_card_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

-- Public tabolar için politikalar
DO $$
BEGIN
  -- Languages (herkes okuyabilir)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'languages' AND policyname = 'Languages are viewable by everyone') THEN
    CREATE POLICY "Languages are viewable by everyone" 
    ON languages FOR SELECT TO authenticated, anon USING (true);
  END IF;

  -- Words (herkes okuyabilir)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'words' AND policyname = 'Words are viewable by everyone') THEN
    CREATE POLICY "Words are viewable by everyone"
    ON words FOR SELECT TO authenticated, anon USING (true);
  END IF;

  -- Word types (herkes okuyabilir)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'word_types' AND policyname = 'Word types are viewable by everyone') THEN
    CREATE POLICY "Word types are viewable by everyone"
    ON word_types FOR SELECT TO authenticated, anon USING (true);
  END IF;

  -- Photos (herkes okuyabilir)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'photos' AND policyname = 'Photos are viewable by everyone') THEN
    CREATE POLICY "Photos are viewable by everyone"
    ON photos FOR SELECT TO authenticated, anon USING (true);
  END IF;

  -- User cards (sadece owner)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_cards' AND policyname = 'User cards are accessible by owner') THEN
    CREATE POLICY "User cards are accessible by owner"
    ON user_cards FOR ALL TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());
  END IF;

  -- User card items (sadece owner)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_card_items' AND policyname = 'User card items are accessible by owner') THEN
    CREATE POLICY "User card items are accessible by owner"
    ON user_card_items FOR ALL TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());
  END IF;



END $$;

----------------------------------------
-- ÖRNEK VERİ
----------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM languages WHERE code = 'en') THEN
    INSERT INTO languages (code, name) VALUES ('en', 'English');
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM languages WHERE code = 'de') THEN
    INSERT INTO languages (code, name) VALUES ('de', 'Deutsch');
  END IF;
END $$;