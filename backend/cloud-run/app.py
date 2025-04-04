import os
import firebase_admin
import json
from datetime import timedelta
import requests
from firebase_admin import credentials, auth, firestore, storage, messaging
from flask import Flask, request, jsonify, send_file
from io import BytesIO
#from google.cloud import pubsub_v1


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

@app.route('/auth/signup', methods=['POST'])
def sign_up():
    try:
        # Get request data
        data = request.get_json()
        email = data['email']
        uid = data['password']
        role = data['role']
        firstName = data['firstName']
        lastName = data['lastName']
        # if role == 'Coach':
        #     create_coach_topic(uid)

        user_data = {
            "email": email,
            "uid": uid,
            "role": role,
            "firstName": firstName,
            "lastName": lastName}
        db.collection('Users').document(uid).set(user_data)


        return jsonify({
            "status": "success",
            "message": "User registered successfully",
            "uid": uid,
            "role": role
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/auth/login', methods=['POST'])
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
                "role" : user.to_dict()['role'],
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

@app.route('/coaches/get-players', methods=['GET'])
def get_players():
    try:
        uid = request.args.get('uid')

        if not uid:
            return jsonify({"status": "error", "message": "UID is missing."}), 400

        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404

        # Reference to the user document
        user_ref = db.collection('Users').document(uid)
        userRole = user_ref.get().to_dict().get('role')
        if userRole != 'Coach':
            return jsonify({"status": "Forbidden", "message": f"User does not have permissions to access this resource."}), 403

        # Get the sessions subcollection for the user
        players_ref = user_ref.collection('Players')

        players = players_ref.stream()  # Retrieve all players

        result = {}

        for player in players:
            player_data = player.to_dict()
            p_id=player_data['uid']
            result[p_id] = db.collection('Users').document(p_id).get().to_dict()



        return jsonify({
            "status" : "success",
            "message" : "Players retrieved successfully.",
            "players" : result
        }),200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/coaches/get-open-players', methods=['GET'])
def get_open_players():
    try:
        all_users = db.collection('Users').stream()
        all_players =[]
        open_players = []
        for user_doc in all_users:
            user_role = user_doc.to_dict().get('role')
            if user_role == 'Player':
                all_players.append(user_doc.to_dict())
        for player in all_players:
            if 'coach_id' not in player:
                open_players.append(player)

        return jsonify({
            "status" : "success",
            "message" : "Retrieved all open players",
            "players" : open_players
        }),200
    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/coaches/create-pairing', methods=['POST'])
def create_pairing():
    try:
        data = request.get_json()
        if 'uid' not in data:
            return jsonify({"status": "error", "message": "Coach Id required."}), 400
        uid = data['uid']

        if not uid:
            return jsonify({"status": "error", "message": "Please provide a valid Coach ID."}), 400

        coach_doc_ref = db.collection('Users').document(uid)
        coach_doc = coach_doc_ref.get()

        if not coach_doc.exists:
            return jsonify({"status": "error", "message": f"Coach with UID {uid} does not exist."}), 404

        if coach_doc.to_dict().get('role') != 'Coach':
            return jsonify({"status": "Forbidden", "message": f"User {uid} must be a coach to access this resource."}), 403

        if 'player_id' not in data:
            return jsonify({"status": "error", "message": "Player Id required."}), 400
        player_id = data['player_id']

        if not player_id:
            return jsonify({"status": "error", "message": "Please provide a valid Coach ID."}), 400

        player_doc_ref = db.collection('Users').document(player_id)
        player_doc = player_doc_ref.get()

        if not player_doc.exists:
            return jsonify({"status": "error", "message": f"Player with UID {player_id} does not exist."}), 404

        if player_doc.to_dict().get('role') != 'Player':
            return jsonify({"status": "Forbidden", "message": f"Invalid player ID {player_id}"}), 400

        player_doc_ref.update({"coach_id": uid})

        pairing_ref = coach_doc_ref.collection("Players").document(player_id)
        pairing_ref.set({"uid" : player_id})



        return jsonify({
            "status": "success",
            "message": "Pairing created successfuly."
        }), 200


    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/users/edit-profile-picture', methods=['POST'])
def edit_profile_picture():
    try:
        if 'file' not in request.files:
            return jsonify({"status": "error", "message": "No file found."}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"status":"error", "message":"No image selected."}), 400
        uid = request.form['uid']


        blob = bucket.blob(f'uploads/{uid}/{file.filename}')
        blob.upload_from_file(file)

        blob_url = blob.public_url
        user_ref = db.collection('Users').document(uid)


        signed_url = blob.generate_signed_url(expiration=timedelta(days=5*365), method='GET')
        user_ref.update({'pfpUrl': signed_url})

        return jsonify({
            "status" : "success",
            "message" : "Profile picture updated successfully",
            "url" : signed_url
        }),200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/users/get-profile-picture', methods=['GET'])
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
            mimetype='image/jpg',
            as_attachment=True,
            download_name=blob_path
        )
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/users/edit-profile', methods=['POST'])
def edit_profile():
    try:
        data = request.get_json()

        if 'uid' not in data:
            return jsonify({"status": "error", "message": "UID is required."}), 400

        uid = data['uid']


        user_doc_ref = db.collection('Users').document(uid)
        user_doc = user_doc_ref.get()

        if not user_doc.exists:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404


        update_data = {key: value for key, value in data.items() if key != "uid"}

        if not update_data:
            return jsonify({"status": "error", "message": "No fields provided for update."}), 400
        user_data = db.collection('Users').document(uid).get().to_dict()

        user_doc_ref.update(update_data)
        user_data = db.collection('Users').document(uid).get().to_dict()

        return jsonify({
            "status": "success",
            "message": "Profile updated successfully.",
            "updated_fields": update_data,
            "user": user_data
        }), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/users/get-profile', methods=['GET'])
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

@app.route('/videos/upload', methods=["POST"])
def upload_video():
    try:
        video_processed = False
        rsp = None

        if 'file' not in request.files:
            return jsonify({"status": "error", "message": "No file found."}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"status":"error", "message":"No video selected."}), 400

        fname = file.filename
        blob = bucket.blob(f'videos/{fname}')
        blob.upload_from_file(file)

        signed_url = blob.generate_signed_url(expiration=timedelta(days=5*365), method='GET')

        vp_url = "https://my-vp-app-174827312206.us-central1.run.app/process-video"
        payload = {"video_url": signed_url}

        rsp = requests.post(vp_url, json=payload, timeout=180)  # 180 seconds timeout

        try:
            response = rsp.json()
        except ValueError:
            return jsonify({
                "status": "error",
                "message": "Invalid JSON response from video processing API",
                "vp": video_processed,
                "rsp_text": rsp.text
            }), 500

        video_processed = True

        ml_url = "https://shot-recommendation-api-857244658015.us-central1.run.app/predict"
        payload = {
            "Ball Speed": response.get('BallSpeed'),
            "Batsman Position": response.get('BatsmanPosition'),
            "Ball Horizontal Line": response.get('BallLine'),
            "Ball Length": response.get('BallLength')
        }

        shot_rec = requests.post(ml_url, json=payload)

        if shot_rec.status_code != 200:
            return jsonify({
                "status": "error",
                "message": f"ML API error {shot_rec.status_code}: {shot_rec.text}"
            }), 500

        return jsonify({
            "status" : "success",
            "message" : "Delivery video uploaded successfully",
            "ballCharacteristics" : response,
            "idealShot" : shot_rec.json(),
            "videoUrl" : signed_url,
        }), 200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e),
            "vp": video_processed,
            "rsp": rsp.text if rsp else None
        })


@app.route('/users/delete-account', methods=["POST"])
def delete_account():
    try:
        data = request.get_json()
        uid = data['uid']

        if "uid" not in data:
            return jsonify({"status": "error", "message": "No uid found."}), 400

        id_token = data['password']

        decoded_token = auth.verify_id_token(id_token)

        uid = decoded_token['uid']

        user_ref = db.collection('Users').document(uid)
        user = user_ref.get()

        if user.exists:
            user_ref.delete()
            auth.delete_user(uid)
            return jsonify({
                "status": "success",
                "message": "User account deleted successfully",
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": "User not found"
            }), 404

    except Exception as e:
        return jsonify({
            "status": "error",
            "message" : str(e)
        })

def send_notification(topic, uid, coach_id):
    try:
        player_ref = db.collection('Users').document(uid)
        player_name= f"{player_ref.get().to_dict().get('firstName')} {player_ref.get().to_dict().get('lastName')}"
        coach_ref = db.collection('Users').document(coach_id)
        coach_name = coach_ref.get().to_dict().get('lastName')
        if (topic == 'feedback-added-topic'):
            registration_token = player_ref.get().to_dict().get('fcm_token')
            message = messaging.Message(
                notification=messaging.Notification(
                    title="New Feedback",
                    body=f"Coach {coach_name} has reviewed your delivery."
                ),
                token=registration_token,
            )
        elif (topic == 'delivery-uploaded-topic'):
            registration_token = coach_ref.get().to_dict().get('fcm_token')
            message = messaging.Message(
                notification=messaging.Notification(
                    title="New Delivery",
                    body=f"Player {player_name} has posted a new delivery."
                ),
                token=registration_token,)

        response = messaging.send(message)

        return response

    except Exception as e:
        raise Exception(f"Error sending notification: {str(e)}")

@app.route('/deliveries/create', methods=["POST"])
def upload_delivery():
    try :
        data = request.get_json()
        if 'uid' not in data:
            return jsonify({"status" :"error","message" : str(e) })

        uid = data['uid']
        users_check = db.collection('Users').where('uid', '==', uid).get()
        if not users_check:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404
        userRole = db.collection('Users').document(uid).get().to_dict().get('role')
        if userRole == 'Coach':
            return jsonify({"status": "Forbidden", "message": f"User does not have permissions to access this resource."}), 403
        session = data['sessionId']
        sessions_check = db.collection('Users').document(uid).collection('sessions').where('sessionId', '==', session).get()
        if not sessions_check:
            return jsonify({"status": "error", "message": f"Session with SessionId {session} does not exist."}), 404

        delivery = data['delivery']
        ball_characteristics = delivery['ballCharacteristics']
        user_ref = db.collection('Users').document(uid)
        session_ref = user_ref.collection('sessions').document(session)
        delivery_ref = session_ref.collection('deliveries').add({
            'BallSpeed': ball_characteristics['ballSpeed'],
            'BallLength': ball_characteristics['ballLength'],
            'BallLine': ball_characteristics['ballLine'],
            'BatsmanPosition': ball_characteristics['batsmanPosition'],
            'idealShot': delivery['idealShot'],
            'videoUrl' : delivery['videoUrl']
        })
        delivery_doc_ref = delivery_ref[1]
        delivery_doc_ref.update({'deliveryId': delivery_doc_ref.id})


        coach_id = user_ref.get().to_dict().get('coach_id', None)
        if coach_id != None:
            topic ='delivery-uploaded-topic'
            send_notification(topic, uid, coach_id)

            # publish_to_topic(coach_id, uid)



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

@app.route('/deliveries/feedback/add', methods=['POST'])
def add_feedback():
    try:
        data = request.get_json()
        uid = data['uid']
        user_ref = db.collection('Users').where('uid', '==', uid).get()
        if not user_ref:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404
        userRole = db.collection('Users').document(uid).get().to_dict().get('role')
        if userRole != 'Coach':
            return jsonify({"status": "Forbidden", "message": "User does not have permissions to access this resource."}), 403

        player_id = data['playerId']
        session_id = data['sessionId']
        delivery_id = data['deliveryId']

        player = db.collection('Users').where('uid', '==', player_id).get()
        if not player:
            return jsonify({"status": "error", "message": f"Player with UID {player_id} does not exist."}), 404

        user_ref = db.collection('Users').document(player_id)
        session_ref = user_ref.collection('sessions').document(session_id)
        delivery_ref = session_ref.collection('deliveries').document(delivery_id)
        coach_id = user_ref.get().to_dict().get('coach_id')
        if coach_id != uid:
            return jsonify({"status": "Forbidden", "message": "User does not have permissions to access this resource."}), 403

        sessions_doc = session_ref.get()
        if not sessions_doc.exists:
            return jsonify({"status": "error", "message": f"Session with ID {session_id} does not exist."}), 404

        delivery_doc = delivery_ref.get()
        if not delivery_doc.exists:
            return jsonify({"status": "error", "message": f"Delivery with ID {delivery_id} does not exist."}), 404

        update_data = {}
        if 'executionRating' in data:
            update_data['executionRating'] = data['executionRating']
        if 'feedback' in data:
            update_data['feedback'] = data['feedback']

        if not update_data:
            return jsonify({"status": "error", "message": "No feedback or rating provided."}), 400


        delivery_ref.update(update_data)

        # Send notification after feedback is added
        message_id = send_notification(
            topic='feedback-added-topic',
            uid=player_id,
            coach_id=coach_id,
            session_id=session_id,
            delivery_id=delivery_id
        )

        return jsonify({
            "status": "success",
            "message" : f'Feedback added successfully.',
            "data" : message_id
        }), 200


    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/deliveries/get', methods=["GET"])
def get_delivery():
    try:

        # Get query params
        uid = request.args.get('uid')
        sessionId = request.args.get('sessionId')
        deliveryId = request.args.get('deliveryId')

        # Basic validation
        if not all([uid, sessionId, deliveryId]):
            return jsonify({"status": "error", "message": "uid, sessionId, and deliveryId are required."}), 400

        # Get user document
        user_ref = db.collection('Users').document(uid)
        user_doc = user_ref.get()
        if not user_doc.exists:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404

        # Get session document
        session_ref = user_ref.collection('sessions').document(sessionId)
        session_doc = session_ref.get()
        if not session_doc.exists:
            return jsonify({"status": "error", "message": f"Session with ID {sessionId} does not exist."}), 404

        # Get delivery document
        delivery_ref = session_ref.collection('deliveries').document(deliveryId)
        delivery_doc = delivery_ref.get()
        if not delivery_doc.exists:
            return jsonify({"status": "error", "message": f"Delivery with ID {deliveryId} does not exist."}), 404

        return jsonify({
            "status": "success",
            "delivery": delivery_doc.to_dict()
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/sessions/create', methods=['POST'])
def upload_session():
    try :
        data = request.get_json()
        uid = data['uid']
        users = db.collection('Users').where('uid', '==', uid).get()
        if not users:
            return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404



        user_ref = db.collection('Users').document(uid)
        if user_ref.get().to_dict().get('role') == 'Coach':
            return jsonify({
                "status": "Forbidden",
                "message": "User does not have permission to access this resource."}), 403

        session_ref = user_ref.collection('sessions').add({
            'date' : data['date'],
            'deliveries' : {},
            'performance' : {}
        })

        doc_ref =  session_ref[1]
        doc_ref.update({"sessionId": doc_ref.id})
        sessionId = doc_ref.id

        return jsonify({
            "status": "success",
            "message": f'Session created successfully.',
            "data" :{
                "sessionId" : sessionId,
            }
        }), 200

    except Exception as e:
        return jsonify({
            "status" :"error",
            "message" : str(e)
        })

@app.route('/sessions/get', methods=['GET'])
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

@app.route('/performance/get', methods=['GET'])
def get_performance_history():

    try:
        uid_list = request.args.get('uid_list')
        if uid_list:
            uid_list = json.loads(uid_list)
        if not uid_list:
            uid = request.args.get('uid')
            if not uid:
                return jsonify({"status": "error", "message": "UID is missing."}), 400
            userRole = db.collection('Users').document(uid).get().to_dict().get('role')
            if userRole == 'Coach':
                return jsonify({"status": "Forbidden", "message": "User does not have permissions to access this resource."}), 403
            sessionId= request.args.get('sessionId')
            user_ref = db.collection('Users').document(uid)
            if sessionId:
                # Get the sessions subcollection for the user
                session_ref = user_ref.collection('sessions').document(sessionId)
                deliveries = session_ref.collection('deliveries').get()

                performances= session_ref.collection('performance').get() #to recalculate
                if len(performances) == 1:
                    for performance in performances:
                        performance.reference.delete()

                performances= session_ref.collection('performance').get()

                if len(performances) == 0:
                    #performance for the session is yet to be calculated

                    avg_speed = 0
                    avg_exec_rating = 0
                    s_count = 0
                    er_count = 0

                    for delivery_ref in deliveries:
                        delivery = delivery_ref.to_dict()
                        s_count = s_count+1
                        avg_speed = avg_speed + delivery['BallSpeed']

                        if 'executionRating' in delivery:
                            er_count = er_count + 1
                            avg_exec_rating += delivery['executionRating']

                    avg_speed = avg_speed / s_count
                    avg_exec_rating = avg_exec_rating / er_count
                    perf_ref = session_ref.collection('performance').add({
                        "averageSpeed": avg_speed,
                        "averageExecutionRating" : avg_exec_rating
                    })


            uid_list = [uid]

        response={}

        for uid in uid_list:

            users = db.collection('Users').where('uid', '==', uid).get()

            if not users:
                return jsonify({"status": "error", "message": f"User with UID {uid} does not exist."}), 404

            userRole = db.collection('Users').document(uid).get().to_dict().get('role')
            if userRole != 'Player':
                return jsonify({"status": "Forbidden", "message": "User does not have permissions to access this resource."}), 403


            # Reference to the user document
            user_ref = db.collection('Users').document(uid)


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


            response[uid] = result

        return jsonify({
            "status": "success",
            "data": response
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


