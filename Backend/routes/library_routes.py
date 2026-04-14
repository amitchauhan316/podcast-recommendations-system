from flask import Blueprint, request, jsonify
import json
import os

library_bp = Blueprint('library', __name__)

# File to store library data
LIBRARY_FILE = os.path.join(os.path.dirname(os.path.dirname(__file__)), "library_data.json")

def load_library_data():
    if os.path.exists(LIBRARY_FILE):
        with open(LIBRARY_FILE, 'r') as f:
            return json.load(f)
    return {
        "subscribed": [],
        "saved": [],
        "downloaded": []
    }

def save_library_data(data):
    with open(LIBRARY_FILE, 'w') as f:
        json.dump(data, f, indent=2)

@library_bp.route("/subscribed", methods=["GET"])
def get_subscribed():
    data = load_library_data()
    return jsonify(data["subscribed"])

@library_bp.route("/saved", methods=["GET"])
def get_saved():
    data = load_library_data()
    return jsonify(data["saved"])

@library_bp.route("/downloaded", methods=["GET"])
def get_downloaded():
    data = load_library_data()
    return jsonify(data["downloaded"])

@library_bp.route("/play", methods=["POST"])
def play_episode():
    data = request.json or {}
    episode_id = data.get("episode_id")
    episode_data = data.get("episode")

    if not episode_id or not episode_data:
        return jsonify({"error": "episode_id and episode data required"}), 400

    library_data = load_library_data()

    # Add to saved if not already there
    saved_ids = [ep["id"] for ep in library_data["saved"]]
    if episode_id not in saved_ids:
        episode_data["statusTag"] = "In Progress"
        episode_data["progress"] = 0.1  # Started playing
        episode_data["timeLeft"] = ""
        library_data["saved"].append(episode_data)

    # If it was subscribed, remove from subscribed
    subscribed_ids = [ep["id"] for ep in library_data["subscribed"]]
    if episode_id in subscribed_ids:
        library_data["subscribed"] = [ep for ep in library_data["subscribed"] if ep["id"] != episode_id]

    save_library_data(library_data)
    return jsonify({"message": "Episode saved and removed from subscribed if applicable"})

@library_bp.route("/subscribe", methods=["POST"])
def subscribe_episode():
    data = request.json or {}
    episode = data.get("episode")

    if not episode:
        return jsonify({"error": "episode data required"}), 400

    library_data = load_library_data()
    episode_id = episode["id"]

    # Check if already subscribed
    subscribed_ids = [ep["id"] for ep in library_data["subscribed"]]
    if episode_id not in subscribed_ids:
        library_data["subscribed"].append(episode)
        save_library_data(library_data)
        return jsonify({"message": "Subscribed"})
    else:
        return jsonify({"message": "Already subscribed"})

@library_bp.route("/unsubscribe/<episode_id>", methods=["DELETE"])
def unsubscribe_episode(episode_id):
    library_data = load_library_data()
    library_data["subscribed"] = [ep for ep in library_data["subscribed"] if ep["id"] != episode_id]
    save_library_data(library_data)
    return jsonify({"message": "Unsubscribed"})

@library_bp.route("/download", methods=["POST"])
def download_episode():
    data = request.json or {}
    episode = data.get("episode")

    if not episode:
        return jsonify({"error": "episode data required"}), 400

    library_data = load_library_data()
    episode_id = episode["id"]

    # Check if already downloaded
    downloaded_ids = [ep["id"] for ep in library_data["downloaded"]]
    if episode_id not in downloaded_ids:
        library_data["downloaded"].append(episode)
        save_library_data(library_data)
        return jsonify({"message": "Downloaded"})
    else:
        return jsonify({"message": "Already downloaded"})