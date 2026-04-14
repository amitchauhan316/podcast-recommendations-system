import pandas as pd
import os

# Get the directory of this script and navigate to find podcast_dataset.csv
current_dir = os.path.dirname(os.path.abspath(__file__))
backend_dir = os.path.dirname(current_dir)
project_root = os.path.dirname(backend_dir)

csv_path = os.path.join(project_root, "podcast_dataset.csv")
if not os.path.exists(csv_path):
    csv_path = os.path.join(backend_dir, "podcast_dataset.csv")

# Global dataset and timestamp tracking so updates are visible without restarting the backend
df = pd.DataFrame()
csv_last_mtime = None


def _log(message):
    print(f"[RecommendationService] {message}")


def _get_csv_mtime(path):
    try:
        return os.path.getmtime(path)
    except OSError:
        return None


def load_dataset():
    global df, csv_last_mtime

    if not os.path.exists(csv_path):
        _log(f"podcast_dataset.csv not found at: {csv_path}")
        df = pd.DataFrame()
        csv_last_mtime = None
        return

    try:
        df = pd.read_csv(csv_path)
        csv_last_mtime = _get_csv_mtime(csv_path)
        _log(f"Loaded podcast_dataset.csv ({len(df)} rows) from: {csv_path}")
    except Exception as e:
        df = pd.DataFrame()
        csv_last_mtime = None
        _log(f"Could not load podcast_dataset.csv from {csv_path}. Error: {e}")


def _ensure_dataset_loaded():
    global csv_last_mtime

    if not os.path.exists(csv_path):
        return

    current_mtime = _get_csv_mtime(csv_path)
    if csv_last_mtime is None or current_mtime != csv_last_mtime:
        load_dataset()


load_dataset()


def _safe_int(value, default=0):
    try:
        return int(float(value))
    except (ValueError, TypeError):
        return default


def _safe_float(value, default=0.0):
    try:
        return float(value)
    except (ValueError, TypeError):
        return default


def _first_value(row, *keys, default=""):
    for key in keys:
        if key in row and pd.notna(row[key]) and str(row[key]).strip() != "":
            return row[key]
    return default


def _format_podcast(row, idx):
    minutes = _safe_int(_first_value(row, "Duration_min", "Episode_Length_minutes", "Duration", 0))
    duration_str = f"{minutes // 60}h {minutes % 60}m" if minutes >= 60 else f"{minutes}m"

    audio_url = _first_value(
        row,
        "YouTube_Link",
        "audio",
        "Audio_Link",
        "AudioURL",
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
    )

    category = _first_value(row, "Category", "Genre", default="Unknown")
    title = _first_value(row, "Episode_Title", "Podcast_Name", "Title", default="Unknown Title")
    author = _first_value(row, "Podcast_Name", "Author", "Channel", default="Unknown Author")

    return {
        "id": str(idx),
        "title": str(title),
        "author": str(author),
        "image": f"https://picsum.photos/seed/{idx}/200",
        "audio": str(audio_url),
        "duration": duration_str,
        "duration_minutes": minutes,
        "category": str(category),
        "rating": _safe_float(_first_value(row, "Rating"), 0.0),
    }


def get_all_podcasts(limit=50, excluded_ids=None):
    _ensure_dataset_loaded()

    if df.empty:
        return []

    if excluded_ids is None:
        excluded_ids = []

    # Exclude previously disliked podcasts
    filtered = df[~df.index.isin(excluded_ids)]

    sort_col = None
    for col in ['Host_Popularity_percentage', 'Rating']:
        if col in filtered.columns:
            sort_col = col
            break

    if sort_col is not None:
        try:
            subset = filtered.sort_values(by=sort_col, ascending=False).head(limit)
        except Exception:
            subset = filtered.head(limit)
    else:
        subset = filtered.head(limit)

    return [_format_podcast(row, idx) for idx, row in subset.iterrows()]


def search_podcasts(query, categories=None, max_duration=None, min_rating=None, limit=50, excluded_ids=None):
    _ensure_dataset_loaded()

    if df.empty:
        return []

    if excluded_ids is None:
        excluded_ids = []

    q = str(query or "").strip().lower()
    if categories is not None and isinstance(categories, str):
        categories = [c.strip() for c in categories.split(",") if c.strip()]

    filtered = df

    if q:
        def match_row(row):
            title = str(_first_value(row, "Episode_Title", "Podcast_Name", "Title", default="")).lower()
            author = str(_first_value(row, "Author", "Channel", default="")).lower()
            category = str(_first_value(row, "Category", "Genre", default="")).lower()
            return q in title or q in author or q in category

        filtered = filtered[filtered.apply(match_row, axis=1)]

    if categories:
        category_col = 'Category' if 'Category' in filtered.columns else 'Genre' if 'Genre' in filtered.columns else None
        if category_col is not None:
            filtered = filtered[filtered[category_col].isin(categories)]

    if max_duration is not None and 'Duration_min' in filtered.columns:
        filtered = filtered[filtered['Duration_min'].astype(float) <= float(max_duration)]

    if min_rating is not None and 'Rating' in filtered.columns:
        filtered = filtered[filtered['Rating'].astype(float) >= float(min_rating)]

    if excluded_ids:
        filtered = filtered[~filtered.index.isin(excluded_ids)]

    if q == "" and not categories and max_duration is None and min_rating is None:
        return get_all_podcasts(limit, excluded_ids)

    if filtered.empty:
        return get_all_podcasts(limit, excluded_ids)

    sort_col = None
    for col in ['Host_Popularity_percentage', 'Rating']:
        if col in filtered.columns:
            sort_col = col
            break

    if sort_col is not None:
        try:
            filtered = filtered.sort_values(by=sort_col, ascending=False)
        except Exception:
            pass

    return [_format_podcast(row, idx) for idx, row in filtered.head(limit).iterrows()]


def get_related_podcasts(clicked_id, limit=10, excluded_ids=None):
    _ensure_dataset_loaded()

    if df.empty:
        return []

    clicked_str = str(clicked_id).strip()
    if clicked_str == "":
        return get_all_podcasts(limit, excluded_ids)

    item = None
    if clicked_str.isdigit():
        idx = int(clicked_str)
        if idx in df.index:
            item = df.loc[[idx]]

    if item is None or item.empty:
        item = df[df['id'].astype(str) == clicked_str] if 'id' in df.columns else pd.DataFrame()

    if item is None or item.empty:
        return get_all_podcasts(limit, excluded_ids)

    category = str(_first_value(item.iloc[0], "Category", "Genre", default="")).strip()
    if category == "":
        return get_all_podcasts(limit, excluded_ids)

    related = df[df.apply(lambda row: str(_first_value(row, "Category", "Genre", default="")).strip().lower() == category.lower(), axis=1)]
    related = related[related.index != item.index[0]]

    if excluded_ids:
        related = related[~related.index.isin(excluded_ids)]

    return [_format_podcast(row, idx) for idx, row in related.head(limit).iterrows()]


def get_recommendations(user_interests, limit=20, excluded_ids=None):
    _ensure_dataset_loaded()

    if df.empty or not user_interests:
        return get_all_podcasts(limit, excluded_ids)

    if excluded_ids is None:
        excluded_ids = []

    category_col = 'Category' if 'Category' in df.columns else 'Genre' if 'Genre' in df.columns else None
    if category_col is None:
        return get_all_podcasts(limit, excluded_ids)

    filtered = df[df[category_col].isin(user_interests)]

    # Exclude previously disliked podcasts
    if excluded_ids:
        filtered = filtered[~filtered.index.isin(excluded_ids)]

    sort_col = None
    for col in ['Host_Popularity_percentage', 'Rating']:
        if col in filtered.columns:
            sort_col = col
            break

    if sort_col is not None:
        try:
            filtered = filtered.sort_values(by=sort_col, ascending=False)
        except Exception:
            pass

    subset = filtered.head(limit)
    if subset.empty:
        return get_all_podcasts(limit, excluded_ids)

    return [_format_podcast(row, idx) for idx, row in subset.iterrows()]
