class ShowMeTheCookies::Selenium
  def initialize(driver)
    @browser = driver.browser
    self
  end

  def get_me_the_cookies
    @browser.manage.all_cookies
  end

  def show_me_the_cookie(cookie_name)
    @browser.manage.cookie_named(cookie_name)
  end

  def show_me_the_cookies
    @browser.manage.all_cookies.map(&:inspect).join("\n")
  end

  def delete_cookie(cookie_name)
    @browser.manage.delete_cookie(cookie_name)
  end
end