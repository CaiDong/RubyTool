require 'net/https'
require 'net/http'
require 'digest'
require 'base64'
require 'json'

def getSig(sid,token,timestamp)
	
	md5=Digest::MD5.new()
	sig=md5.hexdigest("#{sid}#{token}#{timestamp}").upcase
	puts sig
	return sig
end

def getAuth(sid,timestamp)
	auth=Base64.encode64("#{sid}:#{timestamp}").gsub(/\n/,'')
	puts auth
	return auth
end

def getJsonBody(appId,templateId,to,param)
	json={
		"appId" => appId,
		"templateId" => templateId,
		"to" => to,
		"param" => param
	}.to_json
	body ="{\"templateSMS\":#{json}}"
	puts body
	return body
end

sid="409ab4c20241243879e4b8dffb17fe9e"
token="7481ebd80d7888ca2963506087d4a0df"
time=Time.now.strftime("%Y%m%d%H%M%S")
appId="d9d2f519037345f280c0f23a92ff01d1"
templateId="5314"
to="13544516576"
param="1234"

getSig(sid,token,time)
getAuth(sid,time)
getJsonBody(appId,templateId,to,param)