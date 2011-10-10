class ShowMeTheCookies::RackTest
  def initialize(rack_test_driver)
    @rack_test_driver = rack_test_driver
  end

  def get_me_the_cookies
    cookie_jar.instance_variable_get(:@cookies).map do |cookie|
      _translate_cookie(cookie)
    end
  end

  def show_me_the_cookie(cookie_name)
    cookie = cookie_jar.instance_variable_get(:@cookies).find { |c| c.name == cookie_name }
    cookie && _translate_cookie(cookie)
  end

  def show_me_the_cookies
    cookie_jar.instance_variable_get(:@cookies).map(&:inspect).join("\n")
  end

  def delete_cookie(cookie_name)
    cookie_jar.instance_variable_get(:@cookies).reject! do |existing_cookie|
      # See http://j-ferguson.com/testing/bdd/hacking-capybara-cookies/
      # catch session cookies/no expiry (nil) and past expiry (true)
      existing_cookie.expired? != false
    end
  end

private
  def cookie_jar
    @rack_test_driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  end

  def _translate_cookie(cookie)
      {:name => cookie.name,
       :value => cookie.value,
       :domain => cookie.domain,
       :path => cookie.path,
       :expires => cookie.expires}
  end
end