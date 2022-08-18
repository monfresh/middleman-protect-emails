Feature: Email Protection

  Scenario: Shows obfuscated email on page
    Given the Server is running at "test-app"
    When I go to "/"
    Then I should see "<a href='http://www.noir-music.com'>Noir Music</a>"

  Scenario: Replaces all matches
    Given the Server is running at "test-app"
    When I go to "/with_multiple_matches.html"
    Then I should see "single on <a href='http://www.noir-music.com'>Noir Music</a>"
    Then I should see "<a href='http://www.amazon.com/gp/product/B001BSEIUS/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B001BSEIUS&linkCode=as2&tag=chemon08-20'>MOTU 896</a><img src='http://ir-na.amazon-adsystem.com/e/ir?t=chemon08-20&l=as2&o=1&a=B001BSEIUS' width='1' height='1' border='0' alt='' style='border:none !important; margin:0px !important;' />"
    Then I should see "I used it on <a href='http://www.noir-music.com'>Noir Music</a>"

  Scenario: Returns original body when there are no matches
    Given the Server is running at "test-app"
    When I go to "/with_no_matches.html"
    Then I should see "<html><head></head><body>Hello!</body></html>"
