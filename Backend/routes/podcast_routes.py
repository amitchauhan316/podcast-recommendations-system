from flask import Blueprint, request, jsonify
from services.recommendation_service import get_all_podcasts, search_podcasts

podcast_bp = Blueprint('podcasts', __name__)

@podcast_bp.route("/", methods=["GET"])
def get_podcasts():
    return jsonify(get_all_podcasts())

@podcast_bp.route("/search", methods=["GET"])
def search_podcasts_route():
    query = request.args.get("q", "")
    categories = request.args.get("categories", "")
    max_duration = request.args.get("max_duration")
    min_rating = request.args.get("min_rating")
    excluded = request.args.get("excluded_ids", "")

    excluded_ids = [int(x) for x in excluded.split(",") if x.strip().isdigit()]
    category_list = [c.strip() for c in categories.split(",") if c.strip()]

    try:
        max_duration_val = int(max_duration) if max_duration is not None else None
    except ValueError:
        max_duration_val = None

    try:
        min_rating_val = float(min_rating) if min_rating is not None else None
    except ValueError:
        min_rating_val = None

    return jsonify(search_podcasts(
        query,
        categories=category_list,
        max_duration=max_duration_val,
        min_rating=min_rating_val,
        excluded_ids=excluded_ids,
    ))
