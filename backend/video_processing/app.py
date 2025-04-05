from flask import Flask, request, jsonify
import subprocess
import os
import json
import requests

app = Flask(__name__)

@app.route("/process-video", methods=["POST"])
def process_video():
    data = request.get_json()
    video_url = data.get("video_url")

    if not video_url:
        return jsonify({"error": "Missing video_url"}), 400
    
    files_before = os.listdir(".")

    # download video
    video_filename = "input_video.mp4"
    try:
        response = requests.get(video_url, stream=True)
        response.raise_for_status()

        with open(video_filename, "wb") as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)

    except requests.exceptions.RequestException as e:
        return jsonify({"error": "Failed to download video", "details": str(e)}), 500

    
    files_after = os.listdir(".")

    
    try:
        #same as python3 ./FinalVideoProcessing.py in the terminal
        result = subprocess.run(
            ["python3", "FinalVideoProcessing.py"],
            capture_output=True,  
            text=True,  
            check=True 
        )

        for line in result.stdout.splitlines():
            try:
                json_output = json.loads(line)  #only parsing the json characteristics and continuing for the other prints
                return jsonify(json_output), 200  
            except json.JSONDecodeError:
                continue  

        return jsonify({"error": "No JSON output received from processing"}), 500

    except subprocess.CalledProcessError as e:
        return jsonify({"error": "Processing failed", "details": e.stderr.strip(), "files before":files_before,"files after" : files_after}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
