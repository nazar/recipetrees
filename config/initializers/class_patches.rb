#monkey patch base classes to add useful functionality

class String

  def self.random_string(len)
    rand_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" << "0123456789" << "abcdefghijklmnopqrstuvwxyz"
    rand_max = rand_chars.size
    ret = ""
    len.times{ ret << rand_chars[rand(rand_max)] }
    ret
  end

  def to_permalink
    self.gsub(/[^-_\s\w]/, ' ').downcase.squeeze(' ').tr(' ','-').gsub(/-+$/,'')
  end

  def to_redcloth(options={})
    unless self.blank?
      #escape and textalise
      rc = RedCloth.new(self)
      body = rc.to_html
      #place back manual escapes
      unless options.blank? || options[:escape].blank?
        body = CGI::unescapeElement(body, options[:escape])
      end
      body
    end
  end

  #for FatSecret
  def esc
    CGI.escape(self).gsub("%7E", "~").gsub("+", "%20")
  end


end

class Numeric

  def commify(dec='.', sep=',')
    num = to_s.sub(/\./, dec)
    dec = Regexp.escape dec
    num.reverse.gsub(/(\d\d\d)(?=\d)(?!\d*#{dec})/, "\\1#{sep}").reverse
  end

  def time_to_s
    if self > 0
      [self/3600, self/60 % 60, self % 60].map{|t| t.to_s.rjust(2, '0')}.join(':')
    else
      '00:00:00'
    end
  end

  def time_array
    stamp = self.time_to_s
    stamp.scan(/(\d+):(\d{2}):(\d{2})/).flatten
  end

  def time_to_iso8601_duration
    if self > 0
      result = self.time_array
      result.enum_for(:each_with_index).collect{|t,i| t.to_i > 0 ? "#{t.to_i}#{['H','M','S'].at(i)}" : '' }.select{|t| not t.blank?}.join
    else
      ''
    end
  end

  def seconds_to_stopwatch
    result = self.time_array
    result.enum_for(:each_with_index).collect{|t, i| t.to_i > 0 ? "#{t.to_i}#{['h','m','s'].at(i)}" : ''}.select{|s| not s.blank?}.join(':')
  end

  def pretty_roundify
    roundify.commify
  end

  def roundify
    if self.to_f > 0.0
      if self.to_f > 500.0
        result = (self / 10.0).to_i * 10.0
      else
        result = self.to_f
      end
      result.to_i
    else
      0
    end
  end

end