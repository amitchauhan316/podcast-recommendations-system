from flask import Blueprint, request, jsonify
from services.recommendation_service import get_recommendations, get_related_podcasts

rec_bp = Blueprint('recommend', __name__)

@rec_bp.route("/", methods=["POST"])
def recommend():
    data = request.json or {}
    interests = data.get("interests", [])
    excluded_ids = data.get("excluded_ids", [])

    result = get_recommendations(interests, excluded_ids=excluded_ids)
    return jsonify(result)

@rec_bp.route("/related", methods=["POST"])
def recommend_related():
    data = request.json or {}
    clicked_id = data.get("clicked_id")
    category = data.get("category")
    excluded_ids = data.get("excluded_ids", [])

    if clicked_id:
        result = get_related_podcasts(clicked_id, excluded_ids=excluded_ids)
    elif category:
        result = get_recommendations([category], excluded_ids=excluded_ids)
    else:
        result = get_recommendations([], excluded_ids=excluded_ids)

    return jsonify(result)
