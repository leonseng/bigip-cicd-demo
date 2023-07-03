# BIG-IP CI/CD Demo

This repository showcases management of application configuration of BIG-IP using CI/CD practices.

Ansible and the [f5_bigip](https://galaxy.ansible.com/f5networks/f5_bigip) collection are used to configure
1. firewall policies in the `/Common/Shared` partition
1. multiple virtual servers in separate tenants/partitions, some with Application Security Policies attached.

GitHub Actions is used to develop workflows and CI/CD pipelines which include:

| Workflow | Description |
| --- | --- |
| [Generate Artifacts](.github/workflows/generate-artifacts.yml) | generating [BIG-IP AS3](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) JSON and storing them as artifacts within GitHub |
| [CI Test](.github/workflows/ci-test.yml) | deploying test virtual servers and running tests against them |
| [Deploy](.github/workflows/deploy.yml) | deploying virtual servers in "prod", on merge to the default branch |
| [Test](.github/workflows/test.yml) | running tests against "prod" virtual servers, and raising a [GitHub Issue](https://github.com/leonseng/bigip-cicd-demo/issues) on test run failure |
