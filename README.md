## Yambo test-suite

This is the Yambo (http://www.yambo-code.org) test-suite.

The yambo test-suite is composed of a basic perl library of functions that are run via the 

`> driver.pl`

Before using it please read carefully the [online documentation](http://www.yambo-code.org/wiki/index.php?title=Test-suite).

## External Libraries linking test

In order to test a new MODULE on the branch BRANCH 

`>./scripts/launcher.tcsh -y BRANCH -m MODULE -f ext-libs`
