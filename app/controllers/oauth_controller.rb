class OauthController
	def authorization_code_url
		authorization_code_url = 'https://www.linkedin.com/uas/oauth2/authorization?response_type=code'
		authorization_code_url += '&client_id=' + LINKEDIN_KEY
		authorization_code_url += '&scope=r_fullprofile'
		authorization_code_url += '&state=' + LINKEDIN_STATE
		callback_url = CGI.escape 'http://localhost:4567/oauth/callback'
		authorization_code_url += '&redirect_uri=' + callback_url
		authorization_code_url
    end

    def access_token(params)
    	if params[:code] and params[:state] == LINKEDIN_STATE
			access_token_url = 'https://www.linkedin.com/uas/oauth2/accessToken' #?grant_type=authorization_code'

			access_token_params = {}
			access_token_params[:grant_type] = 'authorization_code'
			access_token_params[:code] = params[:code]
			access_token_params[:client_id] = LINKEDIN_KEY
			access_token_params[:client_secret] = LINKEDIN_SECRET
			access_token_params[:redirect_uri] = 'http://localhost:4567/oauth/callback'

		    http = Curl.post access_token_url, access_token_params
		    result = JSON.parse(http.body_str)
		    if result['access_token']
		    	access_token = result['access_token']
	    		expires_in = result['expires_in']
				linkedin_user = LinkedinApi::get_user_by_token(result['access_token'])
				user = User.where(:linkedin_id => linkedin_user['id']).first_or_initialize
				user.from_linkedin! access_token, expires_in, linkedin_user
				user.save!
				return access_token
			end
			false
    	else
    		error_description = 'Access denied'
    		if params[:error_description]
    			error_description = params[:error_description]
    		end
    		false
    	end
	end
end
