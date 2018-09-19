Feature: Check HIBP Database
  It displays a warning if password is found on
  HIBP database, else it displays that
  it is safe to use it.

  Scenario: Call dmp to get 1 insecure passphrase
    When I run `dmp -H 1`
    Then the output should contain "WARNING:"

  Scenario: dmp generates a secure password
    When I run `dmp gen 12 -H`
    Then the output should contain "Password is safe to use."
