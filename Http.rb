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

def TemplateSMS(sid,token,time,appId,templateId,to,param)
	sig=getSig(sid,token,time)
	auth=getAuth(sid,time)
	uri=URI("https://api.ucpaas.com/2014-06-30/Accounts/#{sid}/Messages/templateSMS?sig=#{sig}")

	https=Net::HTTP.new(uri.host,uri.port)
	https.use_ssl=true

	req=Net::HTTP::Post.new(uri)
	req['Accept']='application/json'
	req['Content-Type']='application/json;charset=utf-8'
	req['Authorization']=auth
	req.body=getJsonBody(appId,templateId,to,param)	
	
	response=https.request req 
	puts "#{response.code}\n#{response.code}\n#{response.body}"

end

sid="409ab4c20241243879e4b8dffb17fe9e"
token="7481ebd80d7888ca2963506087d4a0df"
time=Time.now.strftime("%Y%m%d%H%M%S")
appId="d9d2f519037345f280c0f23a92ff01d1"
templateId="5314"
to="13544516576"
param="1234"

TemplateSMS(sid,token,time,appId,templateId,to,param)
#getSig(sid,token,time)
#getAuth(sid,time)
#getJsonBody(appId,templateId,to,param)
