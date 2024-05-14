## Chart - Usage

### Prerequisites
- [Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.
- Once Helm has been set up correctly, add the repo as follows:
    ```
    helm repo add <alias> https://puzzle.github.io/cert-manager-webhook-dnsimple
    ```
    If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.


### Installing
To install the cert-manager-webhook-dnsimple chart:
```
helm install <my-chart-name> <alias>/cert-manager-webhook-dnsimple
```
To uninstall the chart:
```
helm delete <my-chart-name>
```

### Configuration
The required configuration values are listed in the repository's README under [puzzle/cert-manager-webhook-dnsimple](https://github.com/puzzle/cert-manager-webhook-dnsimple#options).
