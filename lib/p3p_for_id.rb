# The purpose of this is to disable etags when processing requests from Internet Explorer
# This is because IE requires a P3P header in order to accept cookies within an iframe
# and if etags are used then subsequent calls for the same page are met with a 304 not changed
# response, which is not allowed (by W3C) to contain P3P headers.  Apache strips them even if we
# patch Rails to set them anyway

# see refs:
# Apache filters P3P headers from 304 responses: http://groups.google.com/group/rack-devel/browse_thread/thread/11da5971522b107b
# general explanation of the problem: http://tempe.st/tag/ruby-on-rails/

module ActionController

  class Request

    alias_method :etag_matches_original?, :etag_matches?

    def etag_matches?(etag)
      (not (env['HTTP_USER_AGENT'] =~ /MSIE [6|7]]/)) && etag_matches_original?(etag)
    end

  end

  class Response

    alias_method :etag_original?, :etag?

    def etag?
      (request.env['HTTP_USER_AGENT'] =~ /MSIE [6|7]]/)  || etag_original?
    end

  end
end
