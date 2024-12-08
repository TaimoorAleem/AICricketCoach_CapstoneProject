import os
import firebase_admin
import json
from firebase_admin import credentials, auth, firestore, storage
from flask import Flask, request, jsonify, send_file
from io import BytesIO


# Initialize Firebase Admin SDK
firebase_creds_json = os.getenv('FIREBASE_CREDENTIALS')
firebase_creds_dict = json.loads(firebase_creds_json)
firebase_admin.initialize_app(
    credentials.Certificate(firebase_creds_dict),
    {"storageBucket":"aicc-proj-1.firebasestorage.app"}
)

bucket = storage.bucket()

# Initialize Flask
app = Flask(__name__)

# Firestore client
db = firestore.client()

@app.route('/')
def home():
    return jsonify({"status": "success", "message": "Welcome to the app!"}), 200

@app.route('/signup', methods=['POST'])
def sign_up():
    try:
        # Get request data
        data = request.get_json()
        email = data['email']
        uid = data['password']

        # Add the user to Firestore
        user_data = {
            "email": email,
            "uid": uid
        }
        db.collection('Users').document(uid).set(user_data)

        return jsonify({
            "status": "success",
            "message": "User registered successfully",
            "uid": uid
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/login', methods=['POST'])
def log_in():
    try:
        # Get request data
        data = request.get_json()
        id_token = data['password']

        decoded_token = auth.verify_id_token(id_token)

        uid = decoded_token['uid']



        #data to send to home page eventually
        user_ref = db.collection('Users').document(uid)
        user = user_ref.get()

        if user.exists:
            return jsonify({
                "status": "success",
                "message": "User logged in successfully",
                "uid": uid,
                "email": user.to_dict()['email']
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": "User not found"
            }), 404

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": uid
        }), 500


@app.route('/get-players', methods=['GET'])
def get_players():
    #implement for coach
    return jsonify({"status": "success", "message": "List of players"}), 200

@app.route('/edit-profile-picture', methods=['POST'])
def edit_profile_picture():
    try:
        if 'file' not in request.files:
            return jsonify({"status": "error", "message": "No file found."}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"status":"error", "message":"No image selected."}), 400


        blob = bucket.blob(f'uploads/{file.filename}')
        blob.upload_from_file(file)

        blob_url = blob.public_url

        return jsonify({
            "status" : "success",
            "message" : "Profile picture updated successfully",
            "url" : blob_url
        }),200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/get-profile-picture', methods=['GET'])
def get_profile_picture():
    try:
        blob_url = request.args.get('url')
        if not blob_url:
            return jsonify({"status": "error", "message": "No URL provided."}), 400
        blob_path = blob_url.split('uploads/')[-1]
        blob = bucket.blob(f'uploads/{blob_path}')
        if not blob.exists():
            return jsonify({"status": "error", "message": "Image not found."}), 404

        image_data = blob.download_as_bytes()

        return send_file(
            BytesIO(image_data),
            mimetype='image/jpg',  # Adjust the MIME type to match the file format (e.g., 'image/png')
            as_attachment=True,    # Set to True if you want to force download
            download_name=blob_path # Suggested file name for download (optional)
        )
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/edit-profile', methods=['POST'])
def edit_profile():
    try:
        data = request.get_json()
        uid = data['uid']
        if 'uid' not in data:
            return jsonify({"status" :"error","message" : str(e) })
        uid = data['uid']
        users_check = db.collection('Users').where('uid', '==', uid).get()
        if not users_check:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404


        user_doc = db.collection('Users').document(uid).get()

        user_data = user_doc.to_dict()

        new_data = {
            "firstName": data.get('firstName', ''),
            "lastName": data.get('lastName', ''),
            "teamName": data.get('teamName', ''),
            "age": data.get('age', ''),
            "role": data.get('role', ''),
            "city": data.get('city', ''),
            "country": data.get('country', ''),
            "description": data.get('description', ''),
            "pfpUrl" : data.get('pfpUrl', '')
        }

        updated_data = {**user_data, **new_data}

        db.collection('Users').document(uid).update(new_data)

        return jsonify({
            "status" : "success",
            "message" : "Profile updated successfully.",
            "user" : updated_data
        }),200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/get-user', methods=['GET'])
def get_user():
    try:
        uid = request.args.get('uid')

        if not uid:
            return jsonify({"status": "error", "message": "UID is missing."}), 400

        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404

        # Reference to the user document
        user_data = db.collection('Users').document(uid).get().to_dict()
        return jsonify({
            "status": "success",
            "message" : f'User data retrieved successfully.',
            "data" : user_data
        }), 200


    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/upload-video', methods=["POST"])
def upload_video():
    try:
        if 'file' not in request.files:
            return jsonify({"status": "error", "message": "No file found."}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"status":"error", "message":"No image selected."}), 400


        blob = bucket.blob(f'uploads/{file.filename}')
        blob.upload_from_file(file)

        blob_url = blob.public_url

        return jsonify({
            "status" : "success",
            "message" : "Profile picture updated successfully",
            "url" : blob_url
        }),200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/add-delivery', methods=["POST"])
def upload_delivery():
    try :
        data = request.get_json()
        if 'uid' not in data:
            return jsonify({"status" :"error","message" : str(e) })

        uid = data['uid']
        users_check = db.collection('Users').where('uid', '==', uid).get()
        if not users_check:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404
        session = data['sessionId']
        sessions_check = db.collection('Users').document(uid).collection('sessions').where('sessionId', '==', session).get()
        if not sessions_check:
            return jsonify({"status": "error", "message": f"Session with SessionId {session} does not exist."}), 404

        delivery = data['delivery']
        user_ref = db.collection('Users').document(uid)
        session_ref = user_ref.collection('sessions').document(session)
        delivery_ref = session_ref.collection('deliveries').add({
            'speed': delivery['speed'],
            'bounceHeight': delivery['bounceHeight'],
            'ballLength': delivery['ballLength'],
            'horizontalPosition': delivery['horizontalPosition'],
            'rightHandedBatsman': delivery['rightHandedBatsman'],
            'accuracy': delivery['accuracy'],
            'executionRating': delivery['executionRating'],
            'idealShot': delivery['idealShot'],
            'videoUrl' : delivery['videoUrl']
        })

        return jsonify({
            "data" :{
                "deliveryId" : delivery_ref[1].id
            },
            "status": "success",
            "message": "Delivery uploaded successfully."
        }), 200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/get-delivery', methods=["GET"])
def get_delivery():
    try:

        uid = request.args.get('uid')
        if not uid:
            return jsonify({"status": "error", "message": "UID is missing."}), 400

        users_check = db.collection('Users').where('uid', '==', uid).get()
        if not users_check:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404
        sessionId = request.args.get('sessionId')
        sessions_check = users_check.collection('sessions').where('sessionId', '==', sessionId).get()
        if not sessions_check:
            return jsonify({"status": "error", "message": f"Session with SessionId {sessionId} does not exist."}), 404

        deliveryId = request.args.get('deliveryId')
        deliveries_check = sessions_check.collection('deliveries').where('deliveryId', '==', deliveryId).get()
        if not deliveries_check:
            return jsonify({"status": "error", "message": f"Delivery with deliveryId {deliveryId} does not exist."}), 404


        # Reference to the user document
        delivery_ref = ((db.collection('Users').document(uid)).collection('sessions').document(sessionId)).collection('deliveries').document(deliveryId)

        delivery = delivery_ref.get()

        result = [delivery.to_dict()]

        return jsonify({
            "status": "success",
            "sessions": result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/create-session', methods=['POST'])
def upload_session():
    try :
        data = request.get_json()
        uid = data['uid']
        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404


        session = data['session']
        user_ref = db.collection('Users').document(uid)

        session_ref = user_ref.collection('sessions').add({
            'date' : session['date'],
            'deliveries' : {},
            'performance' : {}
        })

        doc_ref =  session_ref[1]
        doc_ref.update({"sessionId": doc_ref.id})
        sessionId = doc_ref.id



        delivery = session['delivery']

        delivery_ref = session_ref[1].collection('deliveries').add({
            'speed': delivery['speed'],
            'bounceHeight': delivery['bounceHeight'],
            'ballLength': delivery['ballLength'],
            'horizontalPosition': delivery['horizontalPosition'],
            'rightHandedBatsman': delivery['rightHandedBatsman'],
            'accuracy': delivery['accuracy'],
            'executionRating': delivery['executionRating'],
            'idealShot': delivery['idealShot'],
            'videoUrl' : delivery['videoUrl']
        })

        doc_ref = delivery_ref[1]
        doc_ref.update({"deliveryId": doc_ref.id})
        deliveryId = delivery_ref[1].id

        return jsonify({
            "status": "success",
            "message": f'Session and Delivery created successfully.',
            "data" :{
                "sessionId" : sessionId,
                "deliveryId" : deliveryId
            }
        }), 200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })


@app.route('/get-sessions', methods=['GET'])
def get_sessions():
    try:

        uid = request.args.get('uid')

        if not uid:
            return jsonify({"status": "error", "message": "UID is missing."}), 400

        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404

        # Reference to the user document
        user_ref = db.collection('Users').document(uid)

        # Get the sessions subcollection for the user
        sessions_ref = user_ref.collection('sessions')

        sessionId = request.args.get('sessionId')

        if not sessionId:
            #no sessionId passed, return all sessions
            sessions = sessions_ref.stream()  # Retrieve all sessions
            result = []

            for session in sessions:
                session_data = session.to_dict()
                session_data['sessionId'] = session.id  # Add the sessionId to the result

                # Get the deliveries for the current session
                deliveries_ref = session.reference.collection('deliveries')
                deliveries = deliveries_ref.stream()  # Retrieve all deliveries for this session

                session_data['deliveries'] = []

                for delivery in deliveries:
                    delivery_data = delivery.to_dict()
                    delivery_data['deliveryId'] = delivery.id  # Add the deliveryId to the result
                    session_data['deliveries'].append(delivery_data)

                result.append(session_data)

            return jsonify({
                "status": "success",
                "sessions": result
            }), 200

        else:
            sessions = sessions_ref.where('sessionId', '==', sessionId).get()
            if not sessions:
                return jsonify({"status": "error", "message": f"User {uid} does not have a session {sessionId}."}), 404

            session = sessions_ref.document(sessionId).get()
            session_data = session.to_dict()
            deliveries_ref = sessions_ref.document(sessionId).collection('deliveries')
            deliveries = [delivery.to_dict() for delivery in deliveries_ref.stream()]
            session_data['deliveries'] = deliveries

            return jsonify({
                "status": "success",
                "session": session_data
            }), 200


    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/get-performance-history', methods=['GET'])
def get_performance_history():

    try:
        uid = request.args.get('uid')

        if not uid:
            return jsonify({"status": "error", "message": "UID is missing."}), 400

        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404


        # Reference to the user document
        user_ref = db.collection('Users').document(uid)



        sessionId = request.args.get('sessionId')
        sessions_check = user_ref.collection('sessions').where('sessionId', '==', sessionId).get()
        if not sessions_check:
            return jsonify({"status": "error", "message": f"Session with SessionId {sessionId} does not exist."}), 404



        # Get the sessions subcollection for the user
        session_ref = user_ref.collection('sessions').document(sessionId)
        deliveries = session_ref.collection('deliveries').get()

        performances= session_ref.collection('performance').get()

        if len(performances) == 0:
            #performance for the session is yet to be calculated

            avg_speed = 0
            avg_accuracy = 0
            avg_exec_rating = 0
            count = 0

            for delivery_ref in deliveries:
                delivery = delivery_ref.to_dict()
                count = count+1
                avg_speed = avg_speed + delivery['speed']
                avg_accuracy = avg_accuracy + delivery['accuracy']
                avg_exec_rating = avg_exec_rating + delivery['executionRating']

            avg_speed = avg_speed / count
            avg_accuracy = avg_accuracy / count
            avg_exec_rating = avg_exec_rating / count
            perf_ref = session_ref.collection('performance').add({
                "averageSpeed": avg_speed,
                "averageAccuracy": avg_accuracy,
                "averageExecutionRating" : avg_exec_rating
            })



        # Get all sessions for the user
        sessions_ref = user_ref.collection('sessions').get()
        result = []

        for session in sessions_ref:
            session_data = session.to_dict()

            session_data['date'] = session_data.get('date')

            perf_ref = session.reference.collection('performance')
            performances = perf_ref.stream()  # Stream all performance documents in the subcollection

            session_data['performance'] = []

            # Iterate over performance documents
            for performance in performances:
                performance_data = performance.to_dict()  # Convert each performance document to dict
                session_data['performance'].append(performance_data)  # Add to the session's performances list

            result.append(session_data)  # Append the session with its performances to the result


        return jsonify({
            "status": "success",
            "message" : f'The performance for Session {sessionId} has been updated successfully.',
            "performanceHistory" : result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


