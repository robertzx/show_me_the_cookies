class ShowMeTheCookies::Culerity
  def initialize(driver)
    @driver = driver
    @browser = driver.browser
  end

  def show_me_the_cookie(cookie_name)
    cookie = @browser.webclient.getCookieManager.getCookie(cookie_name.to_s)
    cookie && _translate_cookie(cookie)
  end

  def show_me_the_cookies
    @browser.cookies.send_remote(:inspect)
  end

  def cookie_names
    document_cookie = @driver.evaluate_script("document.cookie")
    pairs = document_cookie && document_cookie.split(/ *; */)
    pairs.map { |pair| pair.split(/\=/)[0].strip }
  end

  def get_me_the_cookies
    # Culerity's browser.cookies.each doesn't appear to work well, so
    # we use Javascript to get the document.cookie string, which is a poort
    # substitute (cf. HTTP only cookies), but it's better than nothing.
    #
    cookie_names.map { |name| show_me_the_cookie(name) }
  end

  def get_me_the_cookies_old
    cookies = []
    hier = @browser.cookies
    binding.pry
    puts "HIER= " + hier.inspect
    hier.map do |domain, namehash|
      namehash.map do |name, value|
        {:name => name, :domain => domain, :value => value}
      end
    end.flatten
  end

  def delete_cookie(cookie_name)
    @browser.remove_cookie('localhost', cookie_name)
  end


  private

  def _translate_cookie(cookie)
    c = {:name => cookie.getName, 
        :domain => cookie.getDomain,
        :value => cookie.getValue, 
        :expires => cookie.getExpires,
        :path => cookie.getPath}
    # Culerity returns a java.util.Date or somesuch; try to convert it
    if c[:expires] && ![Date, DateTime, String].include?(c[:expires].class)
      begin
        c[:expires] = DateTime.parse(c[:expires].toString)
      rescue
      end
    end
    c
  end
end