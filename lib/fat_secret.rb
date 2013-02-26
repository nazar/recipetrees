module FatSecret

  require 'hmac-sha1'

  require 'rubygems'
  require 'json'

  FAT_SECRET = "SECRET"
  FAT_KEY    = "KEY"
  FAT_SHA1   = "HMAC-SHA1"
  FAT_SITE   = "http://platform.fatsecret.com/rest/server.api"


  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    #methods to interface with Fat Secret REST api

    def foods_search(expression)
      params        = {
          :oauth_consumer_key     => FAT_KEY,
          :oauth_nonce            => "1234",
          :oauth_signature_method => FAT_SHA1,
          :oauth_timestamp        => Time.now.to_i,
          :oauth_version          => "1.0",
          :method                 => 'foods.search',
          :format                 => 'json',
          :search_expression      => expression.esc
      }
      sorted_params = params.sort { |a, b| a.first.to_s <=> b.first.to_s }
      base          = base_string("GET", sorted_params)
      http_params   = http_params(params)
      sig           = sign(base).esc
      uri           = uri_for(http_params, sig)
      result        = Net::HTTP.get(uri)
      #parse and return relevant hash
      unless result.blank?
        begin
        JSON.parse(result)['foods']['food']
        rescue
        end
      else
        nil
      end
    end

    def food_get(food_id)
      params        = {
          :oauth_consumer_key     => FAT_KEY,
          :oauth_nonce            => "1234",
          :oauth_signature_method => FAT_SHA1,
          :oauth_timestamp        => Time.now.to_i,
          :oauth_version          => "1.0",
          :method                 => 'food.get',
          :format                 => 'json',
          :food_id                => food_id
      }
      sorted_params = params.sort { |a, b| a.first.to_s <=> b.first.to_s }
      base          = base_string("GET", sorted_params)
      http_params   = http_params(params)
      sig           = sign(base).esc
      uri           = uri_for(http_params, sig)
      result        = Net::HTTP.get(uri)
      #parse and return relevant hash
      unless result.blank?
        begin
          out = JSON.parse(result)['food']['servings']
          #out can either be a hash (for single) or an array.. if a hash convert into single array
          if out['serving'].is_a?(Hash)
            out['serving'] = [out['serving']]; out
          else
            out
          end
        rescue
        end
      else
        nil
      end
    end


    #support methods


    def base_string(http_method, param_pairs)
      param_str = param_pairs.collect { |pair| "#{pair.first}=#{pair.last}" }.join('&')
      [http_method.esc, FAT_SITE.esc, param_str.esc].join("&")
    end

    def http_params(args)
      pairs = args.sort { |a, b| a.first.to_s <=> b.first.to_s }
      pairs.inject([]) { |arr, pair| arr << "#{pair.first.to_s}=#{pair.last}" }.join('&')
    end

    def sign(base, token='')
      secret = "#{FAT_SECRET.esc}&#{token.esc}"
      Base64.encode64(HMAC::SHA1.digest(secret, base)).gsub(/\n/, '')
    end

    def uri_for(params, signature)
      parts = params.split('&')
      parts << "oauth_signature=#{signature}"
      URI.parse("#{FAT_SITE}?#{parts.join('&')}")
    end
  end



end