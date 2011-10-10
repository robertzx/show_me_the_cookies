module ShowMeTheCookies

  require 'show_me_the_cookies/culerity'
  require 'show_me_the_cookies/rack_test'
  require 'show_me_the_cookies/selenium'
  require 'show_me_the_cookies/akephalos'

  def current_driver_adapter
    errmsg = "unsupported driver; use rack::test, selenium/webdriver, akephalos, or culerity"
    driver = Capybara.current_session.driver
    case driver.class.name
    when "Capybara::Selenium::Driver"
      ShowMeTheCookies::Selenium.new driver
    when "Capybara::RackTest::Driver"
      ShowMeTheCookies::RackTest.new driver
    when "Capybara::Driver::Culerity"
      ShowMeTheCookies::Culerity.new driver
    when "Capybara::Driver::Akephalos"
      ShowMeTheCookies::Akephalos.new driver  
    else
      raise errmsg
    end
  end

  def show_me_the_cookie(cookie_name)
    current_driver_adapter.show_me_the_cookie(cookie_name)
  end

  def get_me_the_cookies
    current_driver_adapter.get_me_the_cookies
  end

  def show_me_the_cookies
    puts "Current cookies: #{current_driver_adapter.show_me_the_cookies}"
  end

  def delete_cookie(cookie_name)
    puts current_driver_adapter.show_me_the_cookies if @announce
    current_driver_adapter.delete_cookie(cookie_name)
    puts "Deleted cookie: #{cookie_name}" if @announce
    puts current_driver_adapter.show_me_the_cookies if @announce
  end

private
  @@session_cookie_name = nil
end