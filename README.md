# DNSimple Webhook for cert-manager

A [cert-manager][2] ACME DNS01 solver webhook for [DNSimple][1].

## Pre-requisites

- [cert-manager][2] >= 0.13 (The Helm chart uses the new API versions)
- Kubernetes >= 1.17.x
- Helm 3 (otherwise adjust the example below accordingly)

## Quickstart

1. Take note of your DNSimple API token from the account settings in the automation tab. 
2. Run the following commands replacing the API token placeholders and email address:
    ```bash
    $ helm repo add certmanager-webhook https://puzzle.github.io/cert-manager-webhook-dnsimple
    $ helm install cert-manager-webhook-dnsimple \
        --dry-run \
        --namespace cert-manager \
        --set dnsimple.token='<DNSIMPLE_API_TOKEN>' \
        --set clusterIssuer.production.enabled=true \
        --set clusterIssuer.staging.enabled=true \
        --set clusterIssuer.email=email@example.com \
        certmanager-webhook/cert-manager-webhook-dnsimple
    ```
    (Alternatively you can check out this repository and substitute the source of the install command with `./charts/cert-manager-webhook-dnsimple`.)

3. Afterwards you can issue a certificate:
    ```bash
    $ cat << EOF | kubectl apply -f -
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: dnsimple-test
      namespace: default
    spec:
      dnsNames:
        - test.example.com
      issuerRef:
        name: cert-manager-webhook-dnsimple-production
        kind: ClusterIssuer
      secretName: dnsimple-test-tls
    EOF
    ```

## Chart options
The chart options are documented under [https://puzzle.github.io/cert-manager-webhook-dnsimple][4].
<!-- The Helm chart accepts the following values:

| name                               | required | description                                     | default value                           |
| ---------------------------------- | -------- | ----------------------------------------------- | --------------------------------------- |
| `dnsimple.token`                   | ✔️       | DNSimple API Token                              | _empty_                                 |
| `clusterIssuer.email`              |          | LetsEncrypt Admin Email                         | `name@example.com`                      |
| `clusterIssuer.production.enabled` |          | Create a production `ClusterIssuer`             | `false`                                 |
| `clusterIssuer.staging.enabled`    |          | Create a staging `ClusterIssuer`                | `false`                                 |
| `image.repository`                 | ✔️       | Docker image for the webhook solver             | `neoskop/cert-manager-webhook-dnsimple` |
| `image.tag`                        | ✔️       | Docker image tag of the solver                  | `latest`                                |
| `image.pullPolicy`                 | ✔️       | Image pull policy of the solver                 | `IfNotPresent`                          |
| `logLevel`                         |          | Set the verbosity of the solver                 | _empty_                                 |
| `groupName`                        | ✔️       | Identifies the company that created the webhook | `acme.neoskop.de`                       |
| `certManager.namespace`            | ✔️       | The namespace cert-manager was installed to     | `cert-manager`                          |
| `certManager.serviceAccountName`   | ✔️       | The service account cert-manager runs under     | `cert-manager`                          |
 -->
<!-- TODO: move to gh-pages branch so that it appears on the github.io page. -->

## Testing

All cert-manager webhooks have to pass the DNS01 provider conformance testing suite. This is enforced by the PR-prerequisites which run as GitHub-actions.

### Local testing
#### Test suite
You can also run tests locally, as specified in the `Makefile`:

1. Set-up `testdata/` according to its [README][3].
    - `dnsimple-token.yaml` should be filled with a valid token (for either the sandbox or production environment)
    - `dnsimple.env` should contain the remaining environment variables (non sensitive)
2. Execute the test suite:
    ```bash
    make test
    ```
#### In-cluster testing
1. Install cert-manager:
    ```bash
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
    ```
2. Install the webhook:
    ```bash
    helm install cert-manager-webhook-dnsimple \
        --namespace cert-manager \
        --set dnsimple.token='<DNSIMPLE TOKEN>' \
        --set clusterIssuer.production.enabled=true \
        ./charts/cert-manager-webhook-dnsimple
    ```


## Releases
Every push to the `master` branch triggers the upload of a new docker image to the GitHub Container Registry. These images are considered stable but are not tagged as such. We recommend using a specific version tag for production deployments.

Tagged releases are also pushed to the GitHub Container Registry and are considered stable. Every tag also has its corresponding Helm chart (published [here][4]).

## Contributing
We welcome contributions. Please open an issue or a pull request.



[1]: https://dnsimple.com/
[2]: https://cert-manager.io/docs/installation/kubernetes/
[3]: ./testdata/dnsimple/README.md
[4]: https://puzzle.github.io/cert-manager-webhook-dnsimple
