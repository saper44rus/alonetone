module Recaptcha
  def recaptcha_correct?
    !Alonetone.recaptcha? or
      begin
        verify_uri = URI("https://www.google.com/recaptcha/api/siteverify")
        resp = Net::HTTP.post_form(verify_uri,
                                   "secret" => Alonetone.recaptcha["secret_key"],
                                   "response" => params[:"g-recaptcha-response"],
                                   "remoteip" => request.remote_ip)
        resp.code == "200" && JSON.parse(resp.body)["success"]
      end
  rescue
    # Call it a success if for some reason there's e.g. a network/api error
    true
  end
end
