# Solver testdata

This directory contains the testdata for the DNSimple webhook solver.


### dnsimple.env
Specify the environment variables for testing. These are read by the `Makefile` and used to run the tests.
- `TEST_ZONE_NAME` - the zone name to use for testing (Note the trailing dot)
- `DNSIMPLE_BASE_URL` - the URL to the DNSimple API (can be https://api.dnsimple.com for `production` or https://api.sandbox.dnsimple.com for `sandbox`)


### dnsimple-token.yaml

Copy the `dnsimple-token.yaml.example` example file removing the `.example` suffix:

```bash
$ cp dnsimple-token.yaml{.example,}
```

Replace the placeholders for the API token with a valid token. The API token can be generated in your DNSimple account settings in the automation tab.
