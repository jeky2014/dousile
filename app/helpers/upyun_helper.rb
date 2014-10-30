module UpyunHelper

  def upyun_tag
    policy = getPolicy
    sign = getSignature policy
    raw [tag(:input, :type => "hidden", :name => "policy", :value => policy),tag(:input, :type => :hidden, :name => "signature",:value => sign)].join("\n")
  end
  
  def upyun_bucket
    'dousile'
  end

  private
  
  def getPolicy
    hash = {
      "bucket" => upyun_bucket,
      "save-key" => '/{year}/{mon}/{day}/{filemd5}{.suffix}',
      "expiration" => 20.minutes.since.to_i,
      "allow-file-type" => "jpg,jpeg,gif,png",
      "content-length-range" => "100,3145728",
      "return-url" => request.url
    }
    # puts "JSON: #{hash.to_json}"
    Base64.encode64(hash.to_json).gsub("\n","")
  end
  
  def getSignature(policy)
    form_api_key =  ENV["DOUSILE_UPYUN_FORMKEY"]
    sign = Digest::MD5.hexdigest([policy,form_api_key].join("&"))
  end
  
end