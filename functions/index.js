const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

exports.getCustomToken = functions.https.onRequest(async (req, res) => {
  const kakaoAccessToken = req.body.token;

  try {
    // 카카오 사용자 정보 가져오기
    const kakaoUserResponse = await axios.get('https://kapi.kakao.com/v2/user/me', {
      headers: {
        Authorization: `Bearer ${kakaoAccessToken}`,
      },
    });

    const kakaoUid = kakaoUserResponse.data.id;

    // Firebase Custom Token 생성
    const firebaseToken = await admin.auth().createCustomToken(kakaoUid);

    res.status(200).send({ firebase_token: firebaseToken });
  } catch (error) {
    console.error('Error creating custom token:', error);
    res.status(500).send('Internal Server Error');
  }
});
