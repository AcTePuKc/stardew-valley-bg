# Stardew Valley Bulgarian Translation

---

## Описание

Български превод за Stardew Valley и избрани модове.

Преводът покрива основната игра версия   и някои популярни модове.

---

### 📊 Прогрес

## Прогрес

- Основна игра – 100%
- Диалози – 100%
- След брак – 100%
- Предпочитания за подаръци – 100%
- Писма и тайни бележки – 100%
- Имена и описания на предмети – 100%
- Фестивали и събития – 100%
- Текстури (PNG) – ~65% (в процес/нужна е помощ)

---

### 📂 Структура на репото

## Съдържание

- [CP] Stardew Valley - BG  
  Основен превод на играта (Content Patcher)

- UIInfoSuite2  - ползвайте UIInfoSuite2Alt
  Превод (чрез i18n/bg.json)

- UIInfoSuite2Alt  
  Превод (чрез замяна на default.json)

- Stardrop  
  Превод (замяна на ru.json)

---

### ⚙️ Инсталация

## Инсталация

1. Инсталирайте SMAPI
2. Инсталирайте Content Patcher
3. Поставете папките в Mods

### За модовете

- UIInfoSuite2  
→ използва bg.json (работи при избран български език)

- UIInfoSuite2Alt  
→ заменете default.json

- Stardrop  
→ заменете ru.json (изисква точно това име)

---

### ⚠️ Забележки

## Забележки

- Всички файлове са с правилните имена
- Някои текстури все още се превеждат
- Stardrop използва ru.json вместо отделен език

---

### 👤 Автор

## Автор

Превод: AcTePuKc

---

## GitHub / Nexus workflow

Репото е подготвено да следи само:

- `[CP] Stardew Valley - BG`
- `UIInfoSuite2Alt`

Следните локални неща се игнорират засега:

- `Stardrop/`
- `hidden_folder/`
- `UIInfoSuite2/`
- `UIInfoSuite2Alt.zip`

### Качване към Nexus

GitHub Actions workflow: `.github/workflows/nexus-upload.yml`

Нужен GitHub Secret:

- `NEXUSMODS_API_KEY`

Не е нужен cookie при официалния `Nexus-Mods/upload-action`.

Пускане:

1. Отвори `Actions` в GitHub.
2. Стартирай `Nexus Upload`.
3. Избери `mod_key`.
4. За `stardew-valley-bg` можеш да оставиш `version` празно, защото се взима от `manifest.json`.
5. За `uiinfosuite2alt` подай версия ръчно.
6. По желание добави `changelog`.
7. Ако искаш само тест на пакетирането, пусни с `dry_run = true`.

### Автоматично качване при GitHub Release

При публикуване на GitHub Release workflow-ът качва автоматично `stardew-valley-bg` и използва release tag-а като версия.

---

### ❤️ Благодарности

## Благодарности

- Stardew Valley общността
