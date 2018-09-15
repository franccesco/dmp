Feature: Passphrase
  It displays a 7 length passphrase by default

  Scenario: Call dmp to get a passphrase by default
    When I run `dmp`
    Then the output should contain "Passphrase:"

  Scenario: dmp copy the new passphrase to the clipboard
    When I run `dmp -c`
    Then the output should contain "clipboard."
