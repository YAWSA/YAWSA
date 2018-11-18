<?php
/**
*@copyright   : OZVID Technologies Pvt. Ltd < https://ozvid.com >
*@author      : Shiv Charan Panjeta < shiv@ozvid.com >
*/

namespace app\components;


use Yii;
use yii\base\BaseObject;

/**
 *
 * @author Amr Alshroof
 */
class FirebaseNotifications extends BaseObject {
	/**
	 *
	 * @var string the auth_key Firebase cloude messageing server key.
	 */
    private $authKey ='AAAAl_MOqJg:APA91bEygA1Ci6-By3m3GijZ0brO9WQI7W1prXcZKku1ynpnwSZy_C3NgFZBacIzCcLs7rPq_Jhqd79dYUhSZpJuHNNdUyoTsmJQ0oxd6Pt3JyAGTq28OYJy5AR2O9xizA6KOq3pynT3';
	public $timeout = 5;
	public $sslVerifyHost = false;
	public $sslVerifyPeer = false;
	public $response;
	/**
	 *
	 * @var string the api_url for Firebase cloude messageing.
	 */
	public $apiUrl = 'https://fcm.googleapis.com/fcm/send';
	public function init() {
		if (! $this->authKey)
			throw new \Exception ( "Empty authKey" );
	}
	
	/**
	 * send raw body to FCM
	 *
	 * @param array $body        	
	 * @return mixed
	 */
	public function send($body) {
		$headers = [ 
				"Authorization:key={$this->authKey}",
				'Content-Type: application/json',
				'Expect: ' 
		];
		
		$ch = curl_init ( $this->apiUrl );
		curl_setopt_array ( $ch, [ 
				CURLOPT_POST => true,
				CURLOPT_SSL_VERIFYHOST => $this->sslVerifyHost,
				CURLOPT_SSL_VERIFYPEER => $this->sslVerifyPeer,
				CURLOPT_RETURNTRANSFER => true,
				CURLOPT_BINARYTRANSFER => true,
				CURLOPT_RETURNTRANSFER => true,
				CURLOPT_HEADER => false,
				CURLOPT_FRESH_CONNECT => false,
				CURLOPT_FORBID_REUSE => false,
				CURLOPT_HTTPHEADER => $headers,
				CURLOPT_TIMEOUT => $this->timeout,
				CURLOPT_POSTFIELDS => json_encode ( $body ) 
		] );
		
		$result = curl_exec ( $ch );
		$this->response = $result;
		
		if ($result === false) {
			Yii::error ( 'Curl failed: ' . curl_error ( $ch ) );
			throw new \Exception ( "Could not send notification" );
		}
		$code = ( int ) curl_getinfo ( $ch, CURLINFO_HTTP_CODE );
		if ($code < 200 || $code >= 300) {
			Yii::error ( "got unexpected response code $code" );
			throw new \Exception ( "Could not send notification" );
		}
		curl_close ( $ch );
		$result = json_decode ( $result, true );
		return $result;
	}
	
	/**
	 * send notification for a specific tokens with FCM
	 *
	 * @param array $tokens        	
	 * @param array $data
	 *        	(can be something like ["message"=>$message] )
	 * @param string $collapse_key        	
	 * @param bool $delay_while_idle        	
	 * @param
	 *        	array other
	 * @return mixed
	 */
	public function sendDataMessage($tokens = [], $data, $collapse_key = null, $delay_while_idle = null, $other = null) {
		$body = [ 
				'registration_ids' => $tokens,
				'data' => $data 
		];
		if ($collapse_key)
			$body ['collapse_key'] = $collapse_key;
		if ($delay_while_idle !== null)
			$body ['delay_while_idle'] = $delay_while_idle;
		if ($other)
			$body += $other;
		return $this->send ( $body );
	}
}
